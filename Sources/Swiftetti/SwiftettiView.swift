import SwiftUI

public struct SwiftettiView: View {
    @State private var particles: [SwiftettiParticle] = []
    @Binding var trigger: Bool
    public var settings: SwiftettiSettings
    public var colors: [Color]?
    
    public init(trigger: Binding<Bool>, settings: SwiftettiSettings = .default(), colors: [Color]? = nil) {
        self._trigger = trigger
        self.settings = settings
        self.colors = colors
    }
    
    public init(trigger: Binding<Bool>, preset: SwiftettiPreset) {
        self._trigger = trigger
        self.settings = preset.settings
        self.colors = nil
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    SwiftettiParticleView(particle: particle, screenSize: geometry.size)
                }
            }
            .onChange(of: trigger) { newValue in
                if newValue {
                    addConfettiBurst(in: geometry.size)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        trigger = false
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    private func addConfettiBurst(in size: CGSize) {
        if particles.count + settings.particleCount > settings.maxTotalParticles {
            let toRemove = (particles.count + settings.particleCount) - settings.maxTotalParticles
            if toRemove > 0 && toRemove < particles.count {
                particles.removeFirst(toRemove)
            }
        }
        
        let burstX = size.width * settings.burstX
        let burstY = CGFloat(settings.burstY)
        
        let colorPalette = colors ?? settings.colorPalette
        
        for _ in 0..<settings.particleCount {
            let directionRad = settings.burstDirection * .pi / 180
            let coneAngleRad = settings.upwardBias * .pi / 180
            
            let angleWithinCone = Double.random(in: -coneAngleRad/2...coneAngleRad/2)
            let finalAngle = directionRad + angleWithinCone
            
            let minSpeed = min(settings.burstSpeedMin, settings.burstSpeedMax - 1)
            let maxSpeed = max(settings.burstSpeedMax, settings.burstSpeedMin + 1)
            let burstSpeed = Double.random(in: minSpeed...maxSpeed)
            
            let vx = cos(finalAngle) * burstSpeed
            let vy = sin(finalAngle) * burstSpeed
            
            let particle = SwiftettiParticle(
                id: UUID(),
                x: burstX + CGFloat.random(in: -20...20),
                y: burstY,
                vx: vx,
                vy: vy,
                color: colorPalette.randomElement() ?? .white,
                size: CGFloat.random(in: min(settings.sizeMin, settings.sizeMax)...max(settings.sizeMin, settings.sizeMax)),
                shape: .square,
                mass: Double.random(in: min(settings.massMin, settings.massMax)...max(settings.massMin, settings.massMax)),
                dragCoefficient: Double.random(in: min(settings.dragMin, settings.dragMax)...max(settings.dragMin, settings.dragMax)),
                wobbleAmplitude: Double.random(in: min(settings.wobbleAmplitudeMin, settings.wobbleAmplitudeMax)...max(settings.wobbleAmplitudeMin, settings.wobbleAmplitudeMax)),
                wobbleFrequency: Double.random(in: min(settings.wobbleFrequencyMin, settings.wobbleFrequencyMax)...max(settings.wobbleFrequencyMin, settings.wobbleFrequencyMax)),
                wobbleDecay: settings.wobbleDecay,
                rotationSpeedX: Double.random(in: -360...360),
                rotationSpeedY: Double.random(in: -360...360),
                rotationSpeedZ: Double.random(in: -180...180),
                settings: settings
            )
            particles.append(particle)
        }
        
        let maxFallTime = settings.fallDurationBase + (1.0 / settings.massMin) + (settings.dragMax * 0.5) + 2.0
        let particlesToRemove = particles.suffix(settings.particleCount)
        let idsToRemove = particlesToRemove.map { $0.id }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + maxFallTime) {
            particles.removeAll { idsToRemove.contains($0.id) }
        }
    }
}

// MARK: - Presets

public enum SwiftettiPreset {
    case `default`
    case celebration
    case subtle
    case gold
    case rainbow
    
    var settings: SwiftettiSettings {
        switch self {
        case .default:
            return .default()
        case .celebration:
            return .celebration()
        case .subtle:
            return .subtle()
        case .gold:
            return .gold()
        case .rainbow:
            return .rainbow()
        }
    }
}