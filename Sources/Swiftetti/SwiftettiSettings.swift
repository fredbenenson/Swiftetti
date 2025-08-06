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
    
    // Colors
    public var colorPalette: [Color] = [
        .white,
        Color(hex: "C0C0C0"),  // Silver
        Color(hex: "B2B0B0"),  // Light gray
        .accentColor
    ]
    
    // Hex strings for JSON serialization
    private var colorHexStrings: [String]?
    
    // Custom Codable implementation to handle colors
    private enum CodingKeys: String, CodingKey {
        case particleCount, maxTotalParticles
        case burstSpeedMin, burstSpeedMax, upwardBias, burstDirection, burstX, burstY
        case gravity, massMin, massMax, dragMin, dragMax, fallDurationBase
        case wobbleAmplitudeMin, wobbleAmplitudeMax, wobbleFrequencyMin, wobbleFrequencyMax, wobbleDecay
        case sizeMin, sizeMax, fadeStartPercent, fadeDuration
        case metallicEnabled, metallicIntensity, shimmerIntensity
        case colorHexStrings = "colors"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        particleCount = try container.decodeIfPresent(Int.self, forKey: .particleCount) ?? 150
        maxTotalParticles = try container.decodeIfPresent(Int.self, forKey: .maxTotalParticles) ?? 500
        burstSpeedMin = try container.decodeIfPresent(Double.self, forKey: .burstSpeedMin) ?? 2000
        burstSpeedMax = try container.decodeIfPresent(Double.self, forKey: .burstSpeedMax) ?? 10000
        upwardBias = try container.decodeIfPresent(Double.self, forKey: .upwardBias) ?? 120
        burstDirection = try container.decodeIfPresent(Double.self, forKey: .burstDirection) ?? 270
        burstX = try container.decodeIfPresent(Double.self, forKey: .burstX) ?? 0.5
        burstY = try container.decodeIfPresent(Double.self, forKey: .burstY) ?? 400
        gravity = try container.decodeIfPresent(Double.self, forKey: .gravity) ?? 1000
        massMin = try container.decodeIfPresent(Double.self, forKey: .massMin) ?? 0.5
        massMax = try container.decodeIfPresent(Double.self, forKey: .massMax) ?? 1.5
        dragMin = try container.decodeIfPresent(Double.self, forKey: .dragMin) ?? 0.8
        dragMax = try container.decodeIfPresent(Double.self, forKey: .dragMax) ?? 1.2
        fallDurationBase = try container.decodeIfPresent(Double.self, forKey: .fallDurationBase) ?? 2.0
        wobbleAmplitudeMin = try container.decodeIfPresent(Double.self, forKey: .wobbleAmplitudeMin) ?? 5
        wobbleAmplitudeMax = try container.decodeIfPresent(Double.self, forKey: .wobbleAmplitudeMax) ?? 15
        wobbleFrequencyMin = try container.decodeIfPresent(Double.self, forKey: .wobbleFrequencyMin) ?? 2
        wobbleFrequencyMax = try container.decodeIfPresent(Double.self, forKey: .wobbleFrequencyMax) ?? 5
        wobbleDecay = try container.decodeIfPresent(Double.self, forKey: .wobbleDecay) ?? 1.0
        sizeMin = try container.decodeIfPresent(CGFloat.self, forKey: .sizeMin) ?? 2
        sizeMax = try container.decodeIfPresent(CGFloat.self, forKey: .sizeMax) ?? 20
        fadeStartPercent = try container.decodeIfPresent(Double.self, forKey: .fadeStartPercent) ?? 0.8
        fadeDuration = try container.decodeIfPresent(Double.self, forKey: .fadeDuration) ?? 0.2
        metallicEnabled = try container.decodeIfPresent(Bool.self, forKey: .metallicEnabled) ?? false
        metallicIntensity = try container.decodeIfPresent(Double.self, forKey: .metallicIntensity) ?? 0.1
        shimmerIntensity = try container.decodeIfPresent(Double.self, forKey: .shimmerIntensity) ?? 1.0
        
        // Handle colors
        if let hexStrings = try container.decodeIfPresent([String].self, forKey: .colorHexStrings) {
            colorHexStrings = hexStrings
            colorPalette = hexStrings.map { Color(hex: $0) }
        } else {
            // Default colors if not specified
            colorPalette = [
                .white,
                Color(hex: "C0C0C0"),  // Silver
                Color(hex: "B2B0B0"),  // Light gray
                .accentColor
            ]
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(particleCount, forKey: .particleCount)
        try container.encode(maxTotalParticles, forKey: .maxTotalParticles)
        try container.encode(burstSpeedMin, forKey: .burstSpeedMin)
        try container.encode(burstSpeedMax, forKey: .burstSpeedMax)
        try container.encode(upwardBias, forKey: .upwardBias)
        try container.encode(burstDirection, forKey: .burstDirection)
        try container.encode(burstX, forKey: .burstX)
        try container.encode(burstY, forKey: .burstY)
        try container.encode(gravity, forKey: .gravity)
        try container.encode(massMin, forKey: .massMin)
        try container.encode(massMax, forKey: .massMax)
        try container.encode(dragMin, forKey: .dragMin)
        try container.encode(dragMax, forKey: .dragMax)
        try container.encode(fallDurationBase, forKey: .fallDurationBase)
        try container.encode(wobbleAmplitudeMin, forKey: .wobbleAmplitudeMin)
        try container.encode(wobbleAmplitudeMax, forKey: .wobbleAmplitudeMax)
        try container.encode(wobbleFrequencyMin, forKey: .wobbleFrequencyMin)
        try container.encode(wobbleFrequencyMax, forKey: .wobbleFrequencyMax)
        try container.encode(wobbleDecay, forKey: .wobbleDecay)
        try container.encode(sizeMin, forKey: .sizeMin)
        try container.encode(sizeMax, forKey: .sizeMax)
        try container.encode(fadeStartPercent, forKey: .fadeStartPercent)
        try container.encode(fadeDuration, forKey: .fadeDuration)
        try container.encode(metallicEnabled, forKey: .metallicEnabled)
        try container.encode(metallicIntensity, forKey: .metallicIntensity)
        try container.encode(shimmerIntensity, forKey: .shimmerIntensity)
        
        // Only encode colors if they were set via hex strings (to preserve JSON roundtrip)
        if let hexStrings = colorHexStrings {
            try container.encode(hexStrings, forKey: .colorHexStrings)
        }
    }
    
    public init() {}
    
    // MARK: - Preset Configurations
    
    /// Load settings from JSON file in bundle or filesystem
    public static func loadFromJSON(filename: String, bundle: Bundle? = nil, customPaths: [String] = []) -> SwiftettiSettings? {
        #if DEBUG
        // In debug mode, try to load from file system first for hot reloading
        let fileManager = FileManager.default
        
        // Check custom paths first
        for path in customPaths {
            let fullPath = path.hasSuffix(".json") ? path : "\(path)/\(filename).json"
            if fileManager.fileExists(atPath: fullPath) {
                do {
                    let url = URL(fileURLWithPath: fullPath)
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let settings = try decoder.decode(SwiftettiSettings.self, from: data)
                    print("✅ Loaded \(filename).json from filesystem (hot reload): \(fullPath)")
                    return settings
                } catch {
                    print("⚠️ Failed to decode \(filename).json from filesystem: \(error)")
                }
            }
        }
        #endif
        
        // Fall back to bundle for release builds or if file not found
        // Use the provided bundle or default to Bundle.module for SPM packages
        let targetBundle = bundle ?? Bundle.module
        
        // Try both path formats for compatibility
        let possiblePaths = [
            targetBundle.url(forResource: filename, withExtension: "json", subdirectory: "Resources/SwiftettiSettings"),
            targetBundle.url(forResource: "SwiftettiSettings/\(filename)", withExtension: "json"),
            targetBundle.url(forResource: filename, withExtension: "json", subdirectory: "SwiftettiSettings"),
            targetBundle.url(forResource: filename, withExtension: "json")
        ]
        
        guard let url = possiblePaths.compactMap({ $0 }).first else {
            print("⚠️ Could not find \(filename).json in bundle")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let settings = try decoder.decode(SwiftettiSettings.self, from: data)
            print("✅ Loaded \(filename).json from bundle")
            return settings
        } catch {
            print("⚠️ Failed to decode \(filename).json: \(error)")
            return nil
        }
    }
    
    // Cached settings to avoid reloading JSON on every access
    private static var cachedDefault: SwiftettiSettings?
    private static var cachedFromTheTop: SwiftettiSettings?
    
    /// Default settings for standard confetti
    public static func `default`() -> SwiftettiSettings {
        // Return cached version if available
        if let cached = cachedDefault {
            return cached
        }
        
        // Try to load from JSON, fall back to defaults if not found
        if let settings = loadFromJSON(filename: "default") {
            cachedDefault = settings
            return settings
        }
        
        let settings = SwiftettiSettings()
        cachedDefault = settings
        return settings
    }
    
    /// From the Top preset with lots of particles
    public static func fromTheTop() -> SwiftettiSettings {
        // Return cached version if available
        if let cached = cachedFromTheTop {
            return cached
        }
        
        // Try to load from JSON, fall back to hardcoded preset if not found
        if let settings = loadFromJSON(filename: "fromTheTop") {
            cachedFromTheTop = settings
            return settings
        }
        
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
        
        cachedFromTheTop = settings
        return settings
    }
    
    /// Subtle preset with fewer particles
    public static func subtle() -> SwiftettiSettings {
        // Try to load from JSON, fall back to hardcoded preset if not found
        if let settings = loadFromJSON(filename: "subtle") {
            return settings
        }
        
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
        // Try to load from JSON, fall back to hardcoded preset if not found
        if let settings = loadFromJSON(filename: "gold") {
            return settings
        }
        
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
        // Try to load from JSON, fall back to hardcoded preset if not found
        if let settings = loadFromJSON(filename: "rainbow") {
            return settings
        }
        
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