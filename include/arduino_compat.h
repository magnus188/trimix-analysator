#ifndef ARDUINO_COMPAT_H
#define ARDUINO_COMPAT_H

#ifdef NATIVE_BUILD
// Native build compatibility layer
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <string>
#include <iostream>
#include <cstdarg>
#include <algorithm>
#include <cctype>

// Arduino types
typedef uint8_t byte;
typedef bool boolean;

// Enhanced String class for Arduino compatibility
class String : public std::string {
public:
    String() : std::string() {}
    String(const char* s) : std::string(s ? s : "") {}
    String(const std::string& s) : std::string(s) {}
    String(int val) : std::string(std::to_string(val)) {}
    String(float val) : std::string(std::to_string(val)) {}
    
    String toString() const { return *this; }
    const char* c_str() const { return std::string::c_str(); }
    
    // Arduino String methods
    String substring(int start, int end = -1) const {
        if (end == -1) end = length();
        return substr(start, end - start);
    }
    
    int indexOf(char c, int start = 0) const {
        size_t pos = find(c, start);
        return pos == npos ? -1 : (int)pos;
    }
    
    int indexOf(const char* str, int start = 0) const {
        size_t pos = find(str, start);
        return pos == npos ? -1 : (int)pos;
    }
    
    void replace(char find, char replace) {
        std::replace(begin(), end(), find, replace);
    }
    
    void toUpperCase() {
        std::transform(begin(), end(), begin(), ::toupper);
    }
    
    void toLowerCase() {
        std::transform(begin(), end(), begin(), ::tolower);
    }
    
    int toInt() const {
        try { return std::stoi(*this); }
        catch (...) { return 0; }
    }
    
    float toFloat() const {
        try { return std::stof(*this); }
        catch (...) { return 0.0f; }
    }
};

// Arduino constants
#define HIGH 1
#define LOW 0
#define INPUT 0
#define OUTPUT 1
#define INPUT_PULLUP 2

// Arduino functions (stub implementations for native build)
inline void delay(unsigned long ms) { 
    // Stub implementation for native build
}

inline unsigned long millis() {
    return 0; // Stub implementation
}

inline void pinMode(int pin, int mode) {
    // Stub implementation
}

inline void digitalWrite(int pin, int value) {
    // Stub implementation
}

inline int digitalRead(int pin) {
    return LOW; // Stub implementation
}

// Serial stub for native build
class SerialClass {
public:
    void begin(unsigned long baud) {}
    void print(const char* str) { printf("%s", str); }
    void print(const std::string& str) { printf("%s", str.c_str()); }
    void print(int val) { printf("%d", val); }
    void print(float val) { printf("%.2f", val); }
    void println(const char* str) { printf("%s\n", str); }
    void println(const std::string& str) { printf("%s\n", str.c_str()); }
    void println(int val) { printf("%d\n", val); }
    void println(float val) { printf("%.2f\n", val); }
    void println() { printf("\n"); }
    
    // Add printf method
    void printf(const char* format, ...) {
        va_list args;
        va_start(args, format);
        vprintf(format, args);
        va_end(args);
    }
};

extern SerialClass Serial;

// SPIFFS stub for native build
class SPIFFSClass {
public:
    bool begin() { return true; }
    bool exists(const char* path) { return false; }
    // Add other SPIFFS methods as needed
};

extern SPIFFSClass SPIFFS;

#else
// Arduino build - include the real Arduino.h
#include <Arduino.h>
#endif

#endif // ARDUINO_COMPAT_H
