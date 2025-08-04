# Swiftetti 🎊

A customizable, high-performance confetti animation library for SwiftUI with realistic physics and metallic effects.

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS%2017.0%2B-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Features

✨ **Realistic Physics** - Gravity, drag, mass, and wobble effects  
🎨 **Customizable** - Colors, sizes, shapes, and particle counts  
⚡ **High Performance** - Optimized rendering with automatic particle cleanup  
🎭 **Multiple Presets** - Default, Celebration, Subtle, Gold, and Rainbow  
✨ **Metallic Effects** - Optional shimmer and gradient effects  
🎯 **Easy Integration** - Simple SwiftUI API with sensible defaults

## Installation

### Swift Package Manager

Add Swiftetti to your project through Xcode:

1. File → Add Package Dependencies
2. Enter: `https://github.com/yourusername/Swiftetti`
3. Click Add Package

Or add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/Swiftetti", from: "1.0.0")
]
```

## Quick Start

### Basic Usage

```swift
import SwiftUI
import Swiftetti

struct ContentView: View {
    @State private var showConfetti = false
    
    var body: some View {
        Button("Celebrate! 🎉") {
            showConfetti = true
        }
        .overlay {
            SwiftettiView(trigger: $showConfetti)
        }
    }
}
```

### Using Presets

```swift
SwiftettiView(trigger: $showConfetti, preset: .celebration)
```

Available presets:
- `.default` - Standard confetti
- `.celebration` - Lots of colorful particles
- `.subtle` - Fewer, smaller particles
- `.gold` - Metallic gold theme
- `.rainbow` - Rainbow colors

### Custom Colors

```swift
SwiftettiView(
    trigger: $showConfetti,
    colors: [.red, .blue, .green, .yellow]
)
```

### Advanced Customization

```swift
var customSettings = SwiftettiSettings()
customSettings.particleCount = 200
customSettings.gravity = 500
customSettings.metallicEnabled = true
customSettings.colorPalette = [.purple, .pink, .indigo]

SwiftettiView(
    trigger: $showConfetti,
    settings: customSettings
)
```

## Customization Options

### SwiftettiSettings Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `particleCount` | Int | 150 | Number of particles per burst |
| `maxTotalParticles` | Int | 500 | Performance limit for concurrent particles |
| `gravity` | Double | 1000 | Downward acceleration |
| `burstSpeedMin/Max` | Double | 2000/10000 | Initial velocity range |
| `sizeMin/Max` | CGFloat | 2/20 | Particle size range |
| `metallicEnabled` | Bool | false | Enable metallic effects |
| `colorPalette` | [Color] | White/Silver | Colors to use |

### Physics Properties

- **Mass** (`massMin/Max`) - Affects fall speed
- **Drag** (`dragMin/Max`) - Air resistance
- **Wobble** (`wobbleAmplitudeMin/Max`) - Side-to-side movement
- **Rotation** - 3D tumbling effects

## Examples

### Triggered from Multiple Actions

```swift
struct GameView: View {
    @State private var confettiTrigger = false
    
    var body: some View {
        VStack {
            Button("Win!") { confettiTrigger = true }
            Button("Bonus!") { confettiTrigger = true }
            Button("Achievement!") { confettiTrigger = true }
        }
        .overlay {
            SwiftettiView(trigger: $confettiTrigger, preset: .celebration)
        }
    }
}
```

### Custom Burst Position

```swift
var settings = SwiftettiSettings()
settings.burstX = 0.5  // Center horizontally
settings.burstY = 100  // 100 pixels from top

SwiftettiView(trigger: $trigger, settings: settings)
```

### Subtle Background Effect

```swift
var settings = SwiftettiSettings.subtle()
settings.fadeStartPercent = 0.5  // Fade earlier
settings.colorPalette = [.white.opacity(0.8)]

SwiftettiView(trigger: $trigger, settings: settings)
```

## Performance Tips

- Limit `maxTotalParticles` for older devices
- Disable metallic effects if not needed
- Use smaller particle counts for frequent triggers
- Consider using `.subtle()` preset for background effects

## Requirements

- iOS 17.0+
- Swift 5.9+
- SwiftUI

## License

MIT License - see [LICENSE](LICENSE) file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Credits

Created by [Your Name]  
Inspired by celebration moments everywhere 🎊