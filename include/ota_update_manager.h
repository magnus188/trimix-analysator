#ifndef OTA_UPDATE_MANAGER_H
#define OTA_UPDATE_MANAGER_H

#include "arduino_compat.h"
#include "main.h"
#ifdef NATIVE_BUILD
#include <string>
// Stub classes for native build
class HTTPClient {
public:
    void begin(const char* url) {}
    int GET() { return 200; }
    String getString() { return ""; }
    void end() {}
};

class WiFiClientSecure {
public:
    void setCACert(const char* cert) {}
};

class UpdateClass {
public:
    void begin(size_t size) {}
    size_t write(uint8_t* data, size_t len) { return len; }
    bool end() { return true; }
};

extern UpdateClass Update;

#else
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <Update.h>
#include <WiFiClientSecure.h>
#endif
#include <string>
#include <functional>

struct GitHubRelease {
    std::string version;
    std::string name;
    std::string body;
    std::string downloadUrl;
    std::string publishedAt;
    size_t fileSize;
    bool prerelease;
    bool isDraft;
};

class OTAUpdateManager {
private:
    std::string githubRepo;
    std::string currentVersion;
    std::string githubToken; // Optional for private repos
    
    WiFiClientSecure secureClient;
    HTTPClient http;
    
    std::function<void(int)> progressCallback;
    std::function<void(const std::string&)> statusCallback;
    std::function<void(bool, const std::string&)> completeCallback;
    
    bool updateInProgress;
    size_t totalSize;
    size_t downloadedSize;
    
    // GitHub API endpoints
    static const char* GITHUB_API_BASE;
    static const char* GITHUB_RELEASES_ENDPOINT;
    
public:
    OTAUpdateManager(const std::string& repo, const std::string& version);
    ~OTAUpdateManager();
    
    // Configuration
    void setGitHubToken(const std::string& token);
    void setProgressCallback(std::function<void(int)> callback);
    void setStatusCallback(std::function<void(const std::string&)> callback);
    void setCompleteCallback(std::function<void(bool, const std::string&)> callback);
    
    // Update operations
    bool checkForUpdates(GitHubRelease& latestRelease);
    bool downloadAndInstall(const GitHubRelease& release);
    bool isUpdateAvailable(const GitHubRelease& release);
    
    // Utility functions
    std::string getCurrentVersion() const;
    bool isUpdateInProgress() const;
    void cancelUpdate();
    
private:
    bool makeGitHubRequest(const std::string& endpoint, std::string& response);
    bool parseLatestRelease(const std::string& jsonResponse, GitHubRelease& release);
    bool downloadFirmware(const std::string& url, size_t expectedSize);
    bool installFirmware(const uint8_t* data, size_t size);
    int compareVersions(const std::string& v1, const std::string& v2);
    std::string extractAssetDownloadUrl(const std::string& jsonResponse);
    size_t extractAssetSize(const std::string& jsonResponse);
    void updateProgress(size_t current, size_t total);
    void updateStatus(const std::string& status);
    void updateComplete(bool success, const std::string& message);
    
    // GitHub API certificate (for HTTPS)
    static const char* GITHUB_ROOT_CA;
};

#endif // OTA_UPDATE_MANAGER_H
