import SwiftUI
import Swiftetti

struct ContentView: View {
    @State private var showConfetti = false
    @State private var selectedPreset: PresetType = .default
    @State private var showSettings = false  
    @State private var defaultSettings = SwiftettiSettings.default()
    @State private var celebrationSettings = SwiftettiSettings.celebration()
    
    enum PresetType: String, CaseIterable {
        case `default` = "Default"
        case celebration = "Celebration" 
        
        var emoji: String {
            switch self {
            case .default: return "✨"
            case .celebration: return "🎉"
            }
        }
    }
    
    var currentSettings: SwiftettiSettings {
        switch selectedPreset {
        case .default: return defaultSettings
        case .celebration: return celebrationSettings
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Swiftetti")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                VStack(spacing: 20) {
                    // Big Confetti Button
                    Button(action: {
                        showConfetti = true
                    }) {
                        HStack(spacing: 15) {
                            Text("🎊")
                                .font(.system(size: 60))
                            Text("CONFETTI")
                                .font(.system(size: 36, weight: .heavy, design: .rounded))
                            Text("🎊")
                                .font(.system(size: 60))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 30)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(30)
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                    }
                    .scaleEffect(showConfetti ? 0.95 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showConfetti)
                    
                    // Preset Selector
                    VStack(alignment: .leading, spacing: 10) {
                        Text("PRESET")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal)
                        
                        HStack(spacing: 20) {
                            ForEach(PresetType.allCases, id: \.self) { preset in
                                PresetButton(
                                    preset: preset,
                                    isSelected: selectedPreset == preset,
                                    action: {
                                        selectedPreset = preset
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Settings Button
                    Button(action: {
                        showSettings.toggle()
                    }) {
                        Label("Settings", systemImage: "slider.horizontal.3")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(15)
                    }
                }
            }
            .padding()
            
            // Confetti Overlay
            SwiftettiView(
                trigger: $showConfetti,
                settings: currentSettings
            )
        }
        .sheet(isPresented: $showSettings) {
            SwiftettiSettingsAccordion(
                regularCardSettings: $defaultSettings,
                roundOverSettings: $celebrationSettings,
                isPresented: $showSettings
            )
        }
    }
}

struct PresetButton: View {
    let preset: ContentView.PresetType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(preset.emoji)
                    .font(.system(size: 30))
                Text(preset.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color(hex: "667eea") : Color.white.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.white.opacity(0.3) : Color.clear, lineWidth: 2)
            )
        }
    }
}

#Preview {
    ContentView()
}