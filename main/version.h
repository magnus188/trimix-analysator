#pragma once

// Trimix Analyzer version information
#define TRIMIX_ANALYZER_VERSION_MAJOR 0
#define TRIMIX_ANALYZER_VERSION_MINOR 1
#define TRIMIX_ANALYZER_VERSION_PATCH 1
#define TRIMIX_ANALYZER_VERSION "0.1.1"

// Build information
#define BUILD_DATE "2025-12-29"
#define BUILD_TIME "CI"
#define GIT_COMMIT "8b76e54"

// GitHub repository information
#define GITHUB_OWNER "magnus188"
#define GITHUB_REPO "trimix-analysator"
#define GITHUB_API_URL "https://api.github.com/repos/" GITHUB_OWNER "/" GITHUB_REPO "/releases/latest"
#define GITHUB_RELEASES_URL "https://github.com/" GITHUB_OWNER "/" GITHUB_REPO "/releases"

// Function to get full version string
const char* get_version_string(void);
const char* get_build_info(void);
