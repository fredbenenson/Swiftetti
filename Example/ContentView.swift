import SwiftUI
import Swiftetti

struct ContentView: View {
    @State private var showDefaultConfetti = false
    @State private var showFromTheTopConfetti = false
    @State private var showCustomConfetti = false
    @State private var selectedPreset: PresetType = .default
    @State private var showSettings = false  
    @State private var defaultSettings = SwiftettiSettings.default()
    @State private var fromTheTopSettings = SwiftettiSettings.fromTheTop()
    @State private var customSettings: SwiftettiSettings? = nil
    @State private var jsonLoadStatus = ""
    
    enum PresetType: String, CaseIterable {
        case `default` = "Default"
        case fromTheTop = "From the Top"
        case custom = "Custom JSON"
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
                    // Preset Buttons
                    VStack(spacing: 15) {
                        Text("Tap to trigger confetti")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                            .textCase(.uppercase)
                            .tracking(2)
                        
                        VStack(spacing: 12) {
                            ForEach(PresetType.allCases, id: \.self) { preset in
                                Button(action: {
                                    selectedPreset = preset
                                    switch preset {
                                    case .default:
                                        showDefaultConfetti = true
                                    case .fromTheTop:
                                        showFromTheTopConfetti = true
                                    case .custom:
                                        showCustomConfetti = true
                                    }
                                }) {
                                    Text(preset.rawValue)
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 20)
                                        .background(
                                            LinearGradient(
                                                colors: selectedPreset == preset ? 
                                                    [Color(hex: "667eea"), Color(hex: "764ba2")] :
                                                    [Color.white.opacity(0.2), Color.white.opacity(0.15)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .cornerRadius(20)
                                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                }
                            }
                        }
                        .frame(maxWidth: 280)
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
            
            // Confetti Overlays
            SwiftettiView(
                trigger: $showDefaultConfetti,
                settings: defaultSettings
            )
            SwiftettiView(
                trigger: $showFromTheTopConfetti,
                settings: fromTheTopSettings
            )
            SwiftettiView(
                trigger: $showCustomConfetti,
                settings: customSettings ?? SwiftettiSettings.default()
            )
        }
        .sheet(isPresented: $showSettings) {
            SwiftettiSettingsAccordion(
                regularCardSettings: $defaultSettings,
                fromTheTopSettings: $fromTheTopSettings,
                isPresented: $showSettings
            )
        }
        .onAppear {
            // Try to load custom JSON on app launch
            loadCustomJSON()
        }
    }
    
    func loadCustomJSON() {
        // First try to load from the Swiftetti package bundle (where it's actually located)
        if let settings = SwiftettiSettings.loadFromJSON(filename: "custom") {
            customSettings = settings
            jsonLoadStatus = "✅ Loaded custom.json"
            print("Successfully loaded custom JSON from Swiftetti bundle")
            return
        }
        
        // Fallback: try to load from filesystem for development
        let examplePath = #file
            .components(separatedBy: "/")
            .dropLast() // Remove ContentView.swift
            .joined(separator: "/")
        
        let customPath = "\(examplePath)/SwiftettiSettings"
        
        if let settings = SwiftettiSettings.loadFromJSON(
            filename: "custom",
            bundle: .main,
            customPaths: [customPath]
        ) {
            customSettings = settings
            jsonLoadStatus = "✅ Loaded custom.json (dev)"
            print("Successfully loaded custom JSON from filesystem: \(customPath)")
        } else {
            // Create a custom preset programmatically as fallback
            var settings = SwiftettiSettings()
            settings.particleCount = 75
            settings.maxTotalParticles = 300
            settings.burstSpeedMin = 1500
            settings.burstSpeedMax = 4000
            settings.metallicEnabled = true
            settings.metallicIntensity = 0.6
            settings.shimmerIntensity = 0.8
            customSettings = settings
            jsonLoadStatus = "📝 Using fallback custom"
            print("Using fallback custom settings")
        }
    }
}

#Preview {
    ContentView()
}