# ESP32 Portrait Layout Preview

## Display Configuration Changed to Portrait

The ESP32 implementation has been converted from landscape (800x480) to portrait (480x800) orientation to match the original Kivy implementation.

## Screen Layouts

### Home Screen (Portrait 480x800)
```
┌─────────────────────────────────────────┐
│                                         │
│           Trimix Analyzer               │ ← Title (top)
│         ESP32 Version v1.0.0            │ ← Version info
│                                         │
│                                         │
│  ┌─────────────────────────────────┐    │ ← Menu container
│  │                                 │    │   (taller, 85% width)
│  │     Start Analysis              │    │ ← Large analyze button
│  │                                 │    │   (80px height)
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │                                 │    │
│  │  Settings & Calibration         │    │ ← Settings button 
│  │                                 │    │   (60px height)
│  └─────────────────────────────────┘    │
│                                         │
│                                         │
│                                         │
│                                         │
│              Status: Ready              │ ← Status (above navbar)
│                                         │
│  [Home]    [Analyze]    [Settings]     │ ← Navigation bar
└─────────────────────────────────────────┘
```

### Analyze Screen (Portrait 480x800)
```
┌─────────────────────────────────────────┐
│                                         │
│          Real-time Analysis             │ ← Title
│                                         │
│  ┌─────────────┐  ┌─────────────┐      │ ← Sensor grid
│  │   Oxygen    │  │    CO2      │      │   (2x3 layout)
│  │   20.9 %    │  │  400 ppm    │      │   200x120 cards
│  └─────────────┘  └─────────────┘      │
│                                         │
│  ┌─────────────┐  ┌─────────────┐      │
│  │Temperature  │  │  Pressure   │      │
│  │  22.5 °C    │  │  1.01 bar   │      │
│  └─────────────┘  └─────────────┘      │
│                                         │
│  ┌───────────────────────────────┐      │
│  │           Humidity            │      │ ← Full width card
│  │           45.2 %              │      │
│  └───────────────────────────────┘      │
│                                         │
│                                         │
│                                         │
│                                         │
│  [Home]    [Analyze]    [Settings]     │ ← Navigation bar
└─────────────────────────────────────────┘
```

### Settings Screen (Portrait 480x800)
```
┌─────────────────────────────────────────┐
│                                         │
│               Settings                  │ ← Title
│                                         │
│                                         │
│  ┌─────────────────────────────────┐    │ ← Settings menu
│  │                                 │    │   (taller, 450px)
│  │   O2 Sensor Calibration        │    │
│  │                                 │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │                                 │    │
│  │    System Information           │    │
│  │                                 │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │                                 │    │
│  │          About                  │    │
│  │                                 │    │
│  └─────────────────────────────────┘    │
│                                         │
│                                         │
│  [Home]    [Analyze]    [Settings]     │ ← Navigation bar
└─────────────────────────────────────────┘
```

## Key Changes Made

1. **Display Resolution**: Changed from 800x480 (landscape) to 480x800 (portrait)
2. **Touch Calibration**: Swapped X/Y calibration values for portrait orientation
3. **Layout Adjustments**:
   - Increased container heights to utilize vertical space
   - Maintained 2-column sensor grid but with more vertical spacing
   - Adjusted button sizes and spacing for portrait layout
   - Updated positioning offsets throughout

## Hardware Configuration Changes

In `hardware.h`:
- LCD_H_RES: 800 → 480
- LCD_V_RES: 480 → 800
- Touch calibration values swapped to match portrait orientation

## Benefits of Portrait Orientation

1. **Consistency**: Matches original Kivy implementation orientation
2. **Better Reading**: More natural for text-heavy screens like settings
3. **Sensor Layout**: 2x3 grid works well in portrait for sensor cards
4. **Navigation**: Bottom navigation bar feels more natural in portrait