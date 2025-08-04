import SwiftUI

public struct SwiftettiSettings: Codable {
    // Particle emission
    public var particleCount: Int = 150
    public var maxTotalParticles: Int = 500
    
    // Burst physics
    public var burstSpeedMin: Double = 2000
    public var burstSpeedMax: Double = 10000
    public var upwardBias: Double = 120
    public var burstDirection: Double = 270
    public var burstX: Double = 0.5
    public var burstY: Double = 400
    
    // Physics
    public var gravity: Double = 1000
    public var massMin: Double = 0.5
    public var massMax: Double = 1.5
    public var dragMin: Double = 0.8
    public var dragMax: Double = 1.2
    public var fallDurationBase: Double = 2.0
    
    // Wobble
    public var wobbleAmplitudeMin: Double = 5
    public var wobbleAmplitudeMax: Double = 15
    public var wobbleFrequencyMin: Double = 2
    public var wobbleFrequencyMax: Double = 5
    public var wobbleDecay: Double = 1.0
    
    // Appearance
    public var sizeMin: CGFloat = 2
    public var sizeMax: CGFloat = 20
    public var fadeStartPercent: Double = 0.8
    public var fadeDuration: Double = 0.2
    
    // Metallic effects
    public var metallicEnabled: Bool = false
    public var metallicIntensity: Double = 0.1
    public var shimmerIntensity: Double = 1.0
    
    // Colors - not included in Codable
    public var colorPalette: [Color] = [
        .white,
        Color(hex: "C0C0C0"),  // Silver
        Color(hex: "B2B0B0"),  // Light gray
        .accentColor
    ]
    
    // Custom Codable implementation to exclude colorPalette
    private enum CodingKeys: String, CodingKey {
        case particleCount, maxTotalParticles
        case burstSpeedMin, burstSpeedMax, upwardBias, burstDirection, burstX, burstY
        case gravity, massMin, massMax, dragMin, dragMax, fallDurationBase
        case wobbleAmplitudeMin, wobbleAmplitudeMax, wobbleFrequencyMin, wobbleFrequencyMax, wobbleDecay
        case sizeMin, sizeMax, fadeStartPercent, fadeDuration
        case metallicEnabled, metallicIntensity, shimmerIntensity
    }
    
    public init() {}
    
    // MARK: - Preset Configurations
    
    /// Default settings for standard confetti
    public static func `default`() -> SwiftettiSettings {
        SwiftettiSettings()
    }
    
    /// Celebration preset with lots of particles
    public static func celebration() -> SwiftettiSettings {
        var settings = SwiftettiSettings()
        
        settings.particleCount = 200
        settings.maxTotalParticles = 500
        
        settings.burstX = 0.5
        settings.burstY = -100
        
        settings.burstSpeedMin = 300
        settings.burstSpeedMax = 600
        settings.upwardBias = 270
        settings.burstDirection = 90
        
        settings.sizeMin = 12
        settings.sizeMax = 20
        
        settings.fallDurationBase = 4.0
        settings.gravity = 150
        
        settings.massMin = 0.8
        settings.massMax = 1.5
        settings.dragMin = 0.5
        settings.dragMax = 1.5
        
        settings.wobbleAmplitudeMin = 15
        settings.wobbleAmplitudeMax = 35
        settings.wobbleFrequencyMin = 2
        settings.wobbleFrequencyMax = 5
        settings.wobbleDecay = 0.7
        
        settings.fadeStartPercent = 0.8
        settings.fadeDuration = 0.2
        
        settings.metallicEnabled = false
        settings.metallicIntensity = 0.8
        settings.shimmerIntensity = 0.4
        
        settings.colorPalette = [
            Color(hex: "FFD700"),  // Gold
            Color(hex: "FF1493"),  // Deep Pink
            Color(hex: "00CED1"),  // Dark Turquoise
            Color(hex: "FF6347"),  // Tomato
            Color(hex: "9370DB"),  // Medium Purple
            .white
        ]
        
        return settings
    }
    
    /// Subtle preset with fewer particles
    public static func subtle() -> SwiftettiSettings {
        var settings = SwiftettiSettings()
        
        settings.particleCount = 50
        settings.maxTotalParticles = 100
        
        settings.burstSpeedMin = 1000
        settings.burstSpeedMax = 3000
        settings.upwardBias = 60
        
        settings.sizeMin = 4
        settings.sizeMax = 10
        
        settings.gravity = 800
        settings.fallDurationBase = 1.5
        
        settings.wobbleAmplitudeMin = 2
        settings.wobbleAmplitudeMax = 8
        
        settings.colorPalette = [
            .white.opacity(0.9),
            Color(hex: "E0E0E0"),
            Color(hex: "D0D0D0")
        ]
        
        return settings
    }
    
    /// Gold theme preset
    public static func gold() -> SwiftettiSettings {
        var settings = SwiftettiSettings()
        
        settings.particleCount = 100
        
        settings.metallicEnabled = true
        settings.metallicIntensity = 0.9
        settings.shimmerIntensity = 0.8
        
        settings.colorPalette = [
            Color(hex: "FFD700"),  // Gold
            Color(hex: "FFA500"),  // Orange
            Color(hex: "FFE5B4"),  // Peach
            Color(hex: "FFDF00"),  // Golden yellow
        ]
        
        return settings
    }
    
    /// Rainbow preset with many colors
    public static func rainbow() -> SwiftettiSettings {
        var settings = SwiftettiSettings()
        
        settings.particleCount = 120
        
        settings.colorPalette = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple,
            .pink
        ]
        
        return settings
    }
}