#include "ota_update_manager.h"
#include <esp_task_wdt.h>

const char* OTAUpdateManager::GITHUB_API_BASE = "https://api.github.com";
const char* OTAUpdateManager::GITHUB_RELEASES_ENDPOINT = "/repos/%s/releases/latest";

// GitHub's root CA certificate (valid until 2031)
const char* OTAUpdateManager::GITHUB_ROOT_CA = \
"-----BEGIN CERTIFICATE-----\n" \
"MIIEVzCCAz+gAwIBAgIJAPIAGQ2bX2p8MA0GCSqGSIb3DQEBCwUAMIGxMQswCQYD\n" \
"VQQGEwJVUzEQMA4GA1UECAwHQXJpem9uYTETMBEGA1UEBwwKU2NvdHRzZGFsZTEa\n" \
"MBgGA1UECgwRR29EYWRkeSBHcm91cCBJbmMuMTEwLwYDVQQLDChHbyBEYWRkeSBSb290\n" \
"IENlcnRpZmljYXRlIEF1dGhvcml0eSAtIEcyMB4XDTIwMDkwMTAwMDAwMFoXDTMxMDkw\n" \
"MTAwMDAwMFowXjELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAlRYMRAwDgYDVQQHDAdIb3Vz\n" \
"dG9uMRgwFgYDVQQKDA9TU0wgQ29ycG9yYXRpb24xFjAUBgNVBAMMDVNTTC5jb20gUlNB\n" \
"IFNTTCBzdWJDQSBSMzEKMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEjX1lSB4C9oM\n" \
"CKYPmBUvEKGjHlBYmZQhANPDd/H4VhwQtPfTpGFDXf4QZhgN8+QALWaLzBHJcpHqXSL\n" \
"SY0wIDAQABo4IBOTCCATUwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8C\n" \
"AQAwHQYDVR0OBBYEFBQusxe3WFbLrlAJQOYfr52LFMLGMAfBgNVHSMEGDAWgBTEp7g\n" \
"MIIEVzCCAz+gAwIBAgIJAPIAGQ2bX2p8MA0GCSqGSIb3DQEBCwUAMIGxMQswCQYD\n" \
"-----END CERTIFICATE-----\n";

OTAUpdateManager::OTAUpdateManager(const std::string& repo, const std::string& version) 
    : githubRepo(repo), currentVersion(version), updateInProgress(false), 
      totalSize(0), downloadedSize(0) {
    
    // Configure secure client
    secureClient.setCACert(GITHUB_ROOT_CA);
    secureClient.setTimeout(30000); // 30 second timeout
}

OTAUpdateManager::~OTAUpdateManager() {
    if (updateInProgress) {
        cancelUpdate();
    }
}

void OTAUpdateManager::setGitHubToken(const std::string& token) {
    githubToken = token;
}

void OTAUpdateManager::setProgressCallback(std::function<void(int)> callback) {
    progressCallback = callback;
}

void OTAUpdateManager::setStatusCallback(std::function<void(const std::string&)> callback) {
    statusCallback = callback;
}

void OTAUpdateManager::setCompleteCallback(std::function<void(bool, const std::string&)> callback) {
    completeCallback = callback;
}

bool OTAUpdateManager::checkForUpdates(GitHubRelease& latestRelease) {
    if (WiFi.status() != WL_CONNECTED) {
        updateStatus("WiFi not connected");
        return false;
    }
    
    updateStatus("Checking for updates...");
    
    char endpoint[256];
    snprintf(endpoint, sizeof(endpoint), GITHUB_RELEASES_ENDPOINT, githubRepo.c_str());
    
    std::string response;
    if (!makeGitHubRequest(endpoint, response)) {
        updateStatus("Failed to connect to GitHub");
        return false;
    }
    
    if (!parseLatestRelease(response, latestRelease)) {
        updateStatus("Failed to parse release data");
        return false;
    }
    
    updateStatus("Update check completed");
    return true;
}

bool OTAUpdateManager::downloadAndInstall(const GitHubRelease& release) {
    if (updateInProgress) {
        updateStatus("Update already in progress");
        return false;
    }
    
    if (WiFi.status() != WL_CONNECTED) {
        updateStatus("WiFi not connected");
        return false;
    }
    
    updateInProgress = true;
    updateStatus("Starting download...");
    
    // Initialize update
    if (!Update.begin(release.fileSize)) {
        updateStatus("Failed to initialize update");
        updateInProgress = false;
        return false;
    }
    
    // Download and install firmware
    bool success = downloadFirmware(release.downloadUrl, release.fileSize);
    
    if (success) {
        if (Update.end()) {
            updateStatus("Update completed successfully");
            updateComplete(true, "Update installed. Restarting...");
            delay(2000);
            ESP.restart();
        } else {
            updateStatus("Update failed to finalize");
            updateComplete(false, "Update finalization failed");
        }
    } else {
        Update.abort();
        updateStatus("Download failed");
        updateComplete(false, "Download failed");
    }
    
    updateInProgress = false;
    return success;
}

bool OTAUpdateManager::isUpdateAvailable(const GitHubRelease& release) {
    return compareVersions(release.version, currentVersion) > 0;
}

std::string OTAUpdateManager::getCurrentVersion() const {
    return currentVersion;
}

bool OTAUpdateManager::isUpdateInProgress() const {
    return updateInProgress;
}

void OTAUpdateManager::cancelUpdate() {
    if (updateInProgress) {
        Update.abort();
        updateInProgress = false;
        updateStatus("Update cancelled");
        updateComplete(false, "Update cancelled by user");
    }
}

bool OTAUpdateManager::makeGitHubRequest(const std::string& endpoint, std::string& response) {
    http.begin(secureClient, GITHUB_API_BASE);
    
    // Set headers
    http.addHeader("User-Agent", "ESP32-Trimix-Analyzer");
    http.addHeader("Accept", "application/vnd.github.v3+json");
    
    if (!githubToken.empty()) {
        http.addHeader("Authorization", ("token " + githubToken).c_str());
    }
    
    std::string fullUrl = GITHUB_API_BASE + endpoint;
    int httpCode = http.GET();
    
    if (httpCode == HTTP_CODE_OK) {
        response = http.getString().c_str();
        http.end();
        return true;
    } else {
        Serial.printf("HTTP request failed: %d\n", httpCode);
        http.end();
        return false;
    }
}

bool OTAUpdateManager::parseLatestRelease(const std::string& jsonResponse, GitHubRelease& release) {
    DynamicJsonDocument doc(8192);
    DeserializationError error = deserializeJson(doc, jsonResponse);
    
    if (error) {
        Serial.printf("JSON parsing failed: %s\n", error.c_str());
        return false;
    }
    
    // Parse release information
    release.version = doc["tag_name"].as<std::string>();
    release.name = doc["name"].as<std::string>();
    release.body = doc["body"].as<std::string>();
    release.publishedAt = doc["published_at"].as<std::string>();
    release.prerelease = doc["prerelease"].as<bool>();
    release.isDraft = doc["draft"].as<bool>();
    
    // Find firmware asset
    JsonArray assets = doc["assets"].as<JsonArray>();
    for (JsonObject asset : assets) {
        std::string assetName = asset["name"].as<std::string>();
        
        // Look for firmware file (typically .bin extension)
        if (assetName.find(".bin") != std::string::npos || 
            assetName.find("firmware") != std::string::npos) {
            release.downloadUrl = asset["browser_download_url"].as<std::string>();
            release.fileSize = asset["size"].as<size_t>();
            break;
        }
    }
    
    if (release.downloadUrl.empty()) {
        Serial.println("No firmware asset found in release");
        return false;
    }
    
    return true;
}

bool OTAUpdateManager::downloadFirmware(const std::string& url, size_t expectedSize) {
    updateStatus("Downloading firmware...");
    
    http.begin(secureClient, url.c_str());
    http.addHeader("User-Agent", "ESP32-Trimix-Analyzer");
    
    int httpCode = http.GET();
    
    if (httpCode != HTTP_CODE_OK) {
        http.end();
        return false;
    }
    
    totalSize = expectedSize;
    downloadedSize = 0;
    
    WiFiClient* stream = http.getStreamPtr();
    uint8_t buffer[1024];
    
    while (http.connected() && downloadedSize < totalSize) {
        esp_task_wdt_reset(); // Reset watchdog
        
        size_t available = stream->available();
        if (available > 0) {
            size_t bytesToRead = min(available, sizeof(buffer));
            size_t bytesRead = stream->readBytes(buffer, bytesToRead);
            
            // Write to update partition
            if (Update.write(buffer, bytesRead) != bytesRead) {
                updateStatus("Write failed");
                http.end();
                return false;
            }
            
            downloadedSize += bytesRead;
            updateProgress(downloadedSize, totalSize);
        }
        
        delay(1); // Yield to other tasks
    }
    
    http.end();
    
    if (downloadedSize != totalSize) {
        updateStatus("Download incomplete");
        return false;
    }
    
    return true;
}

int OTAUpdateManager::compareVersions(const std::string& v1, const std::string& v2) {
    // Simple version comparison (assumes semantic versioning)
    // Returns: 1 if v1 > v2, -1 if v1 < v2, 0 if equal
    
    auto parseVersion = [](const std::string& version) {
        std::vector<int> parts;
        std::string current = version;
        
        // Remove 'v' prefix if present
        if (current[0] == 'v') {
            current = current.substr(1);
        }
        
        size_t pos = 0;
        while (pos < current.length()) {
            size_t next = current.find('.', pos);
            if (next == std::string::npos) {
                next = current.length();
            }
            
            std::string part = current.substr(pos, next - pos);
            parts.push_back(std::stoi(part));
            pos = next + 1;
        }
        
        return parts;
    };
    
    auto version1 = parseVersion(v1);
    auto version2 = parseVersion(v2);
    
    // Pad shorter version with zeros
    while (version1.size() < version2.size()) version1.push_back(0);
    while (version2.size() < version1.size()) version2.push_back(0);
    
    for (size_t i = 0; i < version1.size(); i++) {
        if (version1[i] > version2[i]) return 1;
        if (version1[i] < version2[i]) return -1;
    }
    
    return 0;
}

void OTAUpdateManager::updateProgress(size_t current, size_t total) {
    if (progressCallback) {
        int percentage = (current * 100) / total;
        progressCallback(percentage);
    }
}

void OTAUpdateManager::updateStatus(const std::string& status) {
    Serial.println(status.c_str());
    if (statusCallback) {
        statusCallback(status);
    }
}

void OTAUpdateManager::updateComplete(bool success, const std::string& message) {
    if (completeCallback) {
        completeCallback(success, message);
    }
}
