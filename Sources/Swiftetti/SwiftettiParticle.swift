import SwiftUI

public struct SwiftettiParticle: Identifiable {
    public let id: UUID
    public let x: CGFloat
    public let y: CGFloat
    public let vx: Double
    public let vy: Double
    public let color: Color
    public let size: CGFloat
    public let shape: ParticleShape
    public let mass: Double
    public let dragCoefficient: Double
    public let wobbleAmplitude: Double
    public let wobbleFrequency: Double
    public let wobbleDecay: Double
    public let rotationSpeedX: Double
    public let rotationSpeedY: Double
    public let rotationSpeedZ: Double
    public let settings: SwiftettiSettings
    
    public enum ParticleShape {
        case circle
        case square
        case star
        case heart
        case custom(Path)
    }
    
    public init(
        id: UUID = UUID(),
        x: CGFloat,
        y: CGFloat,
        vx: Double,
        vy: Double,
        color: Color,
        size: CGFloat,
        shape: ParticleShape = .square,
        mass: Double,
        dragCoefficient: Double,
        wobbleAmplitude: Double,
        wobbleFrequency: Double,
        wobbleDecay: Double,
        rotationSpeedX: Double,
        rotationSpeedY: Double,
        rotationSpeedZ: Double,
        settings: SwiftettiSettings
    ) {
        self.id = id
        self.x = x
        self.y = y
        self.vx = vx
        self.vy = vy
        self.color = color
        self.size = size
        self.shape = shape
        self.mass = mass
        self.dragCoefficient = dragCoefficient
        self.wobbleAmplitude = wobbleAmplitude
        self.wobbleFrequency = wobbleFrequency
        self.wobbleDecay = wobbleDecay
        self.rotationSpeedX = rotationSpeedX
        self.rotationSpeedY = rotationSpeedY
        self.rotationSpeedZ = rotationSpeedZ
        self.settings = settings
    }
}