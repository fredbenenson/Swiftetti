import SwiftUI

struct SwiftettiParticleView: View {
    let particle: SwiftettiParticle
    let screenSize: CGSize
    
    @State private var phase: Double = 0
    
    private var finalY: CGFloat {
        screenSize.height + 100
    }
    
    private var fallDuration: Double {
        particle.settings.fallDurationBase + (1.0 / particle.mass) + (particle.dragCoefficient * 0.5)
    }
    
    private func calculateOpacity(progress: Double, fadeStart: Double, fadeDuration: Double) -> Double {
        if progress < fadeStart {
            return 1.0
        } else if fadeDuration > 0 {
            let fadeProgress = (progress - fadeStart) / fadeDuration
            return max(0, 1.0 - fadeProgress)
        } else {
            return 0
        }
    }
    
    private func createMetallicGradient(for baseColor: Color, brightness: Double, intensity: Double) -> LinearGradient {
        if intensity == 0 {
            return LinearGradient(
                colors: [baseColor.opacity(brightness)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        let baseOpacity = brightness
        let lightOpacity = min(1.0, brightness * (1 + 0.2 * intensity))
        let darkOpacity = max(0.3, brightness * (1 - 0.3 * intensity))
        
        return LinearGradient(
            colors: [
                baseColor.opacity(lightOpacity),
                baseColor.opacity(baseOpacity),
                baseColor.opacity(darkOpacity)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    @ViewBuilder
    private func particleShape(gradient: LinearGradient) -> some View {
        switch particle.shape {
        case .circle:
            Circle()
                .fill(gradient)
                .frame(width: particle.size, height: particle.size)
        case .square:
            Rectangle()
                .fill(gradient)
                .frame(width: particle.size, height: particle.size)
        case .star:
            Star(corners: 5, smoothness: 0.45)
                .fill(gradient)
                .frame(width: particle.size, height: particle.size)
        case .heart:
            Heart()
                .fill(gradient)
                .frame(width: particle.size, height: particle.size)
        case .custom(let path):
            path
                .fill(gradient)
                .frame(width: particle.size, height: particle.size)
        }
    }
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1/60)) { timeline in
            let elapsed = timeline.date.timeIntervalSinceReferenceDate - phase
            let progress = min(elapsed / fallDuration, 1.0)
            
            let t = progress * fallDuration
            
            let xDecel = 1.0 - progress * 0.9
            let wobbleDecayFactor = 1.0 - (progress * particle.wobbleDecay)
            let wobble = sin(t * particle.wobbleFrequency) * particle.wobbleAmplitude * wobbleDecayFactor
            let xPos = particle.x + (particle.vx * t * xDecel * 0.15) + wobble
            
            let gravity = particle.settings.gravity
            let yVel = particle.vy + gravity * t
            let yPos = particle.y + (particle.vy * t * 0.3) + (0.5 * gravity * t * t * particle.mass * 0.8)
            
            let rotationDecay = 1.0 - (progress * 0.3)
            let rotationX = particle.rotationSpeedX * t * rotationDecay
            let rotationY = particle.rotationSpeedY * t * rotationDecay
            let rotationZ = particle.rotationSpeedZ * t * rotationDecay
            
            let fadeStart = particle.settings.fadeStartPercent
            let fadeDuration = particle.settings.fadeDuration
            let opacity = calculateOpacity(progress: progress, fadeStart: fadeStart, fadeDuration: fadeDuration)
            
            let useMetallic = particle.settings.metallicEnabled
            
            let rotationFactor = useMetallic ? abs(cos(rotationY * .pi / 180)) * abs(cos(rotationX * .pi / 180)) : 1.0
            let brightness = useMetallic ? (0.7 + (rotationFactor * 0.3)) : 1.0
            
            let glintAngle = fmod(abs(rotationY), 360)
            let showGlint = useMetallic && ((glintAngle > 85 && glintAngle < 95) || (glintAngle > 265 && glintAngle < 275))
            
            let effectiveIntensity = useMetallic ? particle.settings.metallicIntensity : 0
            let gradient = createMetallicGradient(for: particle.color, brightness: brightness, intensity: effectiveIntensity)
            
            ZStack {
                particleShape(gradient: gradient)
                
                if showGlint && particle.settings.shimmerIntensity > 0 {
                    particleShape(gradient: LinearGradient(
                        colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(particle.settings.shimmerIntensity * 0.6),
                            Color.white.opacity(0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .blur(radius: 1)
                }
            }
            .rotation3DEffect(
                .degrees(rotationX),
                axis: (x: 1, y: 0, z: 0),
                perspective: 0.5
            )
            .rotation3DEffect(
                .degrees(rotationY),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.5
            )
            .rotation3DEffect(
                .degrees(rotationZ),
                axis: (x: 0, y: 0, z: 1),
                perspective: 0.5
            )
            .shadow(
                color: .black.opacity(useMetallic ? (0.3 * (1 - rotationFactor)) : 0.2),
                radius: useMetallic ? (2 + (2 * (1 - rotationFactor))) : 1,
                x: useMetallic ? (sin(rotationY * .pi / 180) * 2) : 0,
                y: useMetallic ? (2 - cos(rotationX * .pi / 180) * 2) : 1
            )
            .position(x: xPos, y: min(yPos, screenSize.height + 100))
            .opacity(max(0, opacity))
        }
        .onAppear {
            phase = Date.timeIntervalSinceReferenceDate
        }
    }
}

// MARK: - Custom Shapes

struct Star: Shape {
    let corners: Int
    let smoothness: Double
    
    func path(in rect: CGRect) -> Path {
        guard corners >= 2 else { return Path() }
        
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        var currentAngle = -CGFloat.pi / 2
        let angleAdjustment = .pi * 2 / CGFloat(corners * 2)
        let innerRadius = rect.width / 4 * smoothness
        let outerRadius = rect.width / 2
        
        var path = Path()
        
        for corner in 0..<corners * 2 {
            let radius = (corner % 2 == 0) ? outerRadius : innerRadius
            let x = center.x + CGFloat(cos(currentAngle)) * radius
            let y = center.y + CGFloat(sin(currentAngle)) * radius
            
            if corner == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            currentAngle += angleAdjustment
        }
        
        path.closeSubpath()
        return path
    }
}

struct Heart: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width / 2, y: height / 4))
        
        path.addCurve(to: CGPoint(x: 0, y: height / 2.5),
                      control1: CGPoint(x: width / 2, y: 0),
                      control2: CGPoint(x: 0, y: height / 5))
        
        path.addCurve(to: CGPoint(x: width / 2, y: height),
                      control1: CGPoint(x: 0, y: height * 0.6),
                      control2: CGPoint(x: width / 2, y: height * 0.8))
        
        path.addCurve(to: CGPoint(x: width, y: height / 2.5),
                      control1: CGPoint(x: width / 2, y: height * 0.8),
                      control2: CGPoint(x: width, y: height * 0.6))
        
        path.addCurve(to: CGPoint(x: width / 2, y: height / 4),
                      control1: CGPoint(x: width, y: height / 5),
                      control2: CGPoint(x: width / 2, y: 0))
        
        path.closeSubpath()
        return path
    }
}