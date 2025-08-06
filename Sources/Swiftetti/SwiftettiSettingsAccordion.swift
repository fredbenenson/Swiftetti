import SwiftUI
#if os(iOS)
import UIKit
#endif

public struct SwiftettiSettingsAccordion: View {
    @Binding public var regularCardSettings: SwiftettiSettings
    @Binding public var fromTheTopSettings: SwiftettiSettings
    @Binding public var isPresented: Bool
    @State private var testTrigger = false
    @State private var expandedSections: Set<String> = []
    @State private var selectedMode: ConfettiMode = .default
    @State private var currentSettings = SwiftettiSettings.default()
    @State private var showCopiedAlert = false
    
    public init(regularCardSettings: Binding<SwiftettiSettings>, fromTheTopSettings: Binding<SwiftettiSettings>, isPresented: Binding<Bool>) {
        self._regularCardSettings = regularCardSettings
        self._fromTheTopSettings = fromTheTopSettings
        self._isPresented = isPresented
    }
    
    enum ConfettiMode: String, CaseIterable {
        case `default` = "Default"
        case fromTheTop = "From the Top"
    }
    
    public var body: some View {
        NavigationView {
            Form {
                // Mode Selector
                Section {
                    Picker("Confetti Type", selection: $selectedMode) {
                        ForEach(ConfettiMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedMode) { newMode in
                        switch newMode {
                        case .default:
                            currentSettings = regularCardSettings
                        case .fromTheTop:
                            currentSettings = fromTheTopSettings
                        }
                    }
                }
                
                // Burst Parameters Accordion
                Section {
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedSections.contains("burst") },
                            set: { if $0 { expandedSections.insert("burst") } else { expandedSections.remove("burst") } }
                        )
                    ) {
                        burstParametersContent
                    } label: {
                        Label("Burst Parameters", systemImage: "burst")
                            .font(.headline)
                    }
                }
                
                // Physics Accordion
                Section {
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedSections.contains("physics") },
                            set: { if $0 { expandedSections.insert("physics") } else { expandedSections.remove("physics") } }
                        )
                    ) {
                        physicsContent
                    } label: {
                        Label("Physics", systemImage: "atom")
                            .font(.headline)
                    }
                }
                
                // Wobble Accordion
                Section {
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedSections.contains("wobble") },
                            set: { if $0 { expandedSections.insert("wobble") } else { expandedSections.remove("wobble") } }
                        )
                    ) {
                        wobbleContent
                    } label: {
                        Label("Wobble", systemImage: "wind")
                            .font(.headline)
                    }
                }
                
                // Metallic Effects Accordion
                Section {
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedSections.contains("metallic") },
                            set: { if $0 { expandedSections.insert("metallic") } else { expandedSections.remove("metallic") } }
                        )
                    ) {
                        metallicContent
                    } label: {
                        Label("Metallic Effects", systemImage: "sparkle")
                            .font(.headline)
                    }
                }
                
                // Appearance Accordion
                Section {
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedSections.contains("appearance") },
                            set: { if $0 { expandedSections.insert("appearance") } else { expandedSections.remove("appearance") } }
                        )
                    ) {
                        appearanceContent
                    } label: {
                        Label("Appearance", systemImage: "paintbrush")
                            .font(.headline)
                    }
                }
                
                // Actions Section
                Section {
                    HStack(spacing: 10) {
                        Button("Copy JSON") {
                            copySettingsAsJSON()
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        
                        Button("Reset") {
                            switch selectedMode {
                            case .default:
                                currentSettings = SwiftettiSettings.default()
                            case .fromTheTop:
                                currentSettings = SwiftettiSettings.fromTheTop()
                            }
                            updateBindings()
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Confetti Settings")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        updateBindings()
                        isPresented = false
                    }
                }
                #else
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        updateBindings()
                        isPresented = false
                    }
                }
                #endif
            }
        }
        .overlay(alignment: .bottom) {
            // Floating Test Confetti button
            VStack {
                Spacer()
                Button(action: {
                    testTrigger = true
                }) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Test Confetti")
                        Image(systemName: "sparkles")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.purple)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    )
                }
                .padding(.bottom, 30)
            }
        }
        .overlay {
            // Test confetti overlay
            SwiftettiView(trigger: $testTrigger, settings: currentSettings)
                .allowsHitTesting(false)
        }
        .onAppear {
            onAppear()
        }
        .overlay(alignment: .top) {
            if showCopiedAlert {
                Text("Copied!")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.green)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
                    .padding(.top, 50)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeOut(duration: 0.3)) {
                                showCopiedAlert = false
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: - Content Views for Each Section
    
    private var burstParametersContent: some View {
        Group {
            VStack(alignment: .leading, spacing: 8) {
                Text("Particles Per Burst")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Text("\(currentSettings.particleCount)")
                        .font(.system(.body, design: .monospaced))
                        .frame(width: 50, alignment: .trailing)
                    Slider(value: Binding(
                        get: { Double(currentSettings.particleCount) },
                        set: { 
                            currentSettings.particleCount = Int($0)
                            updateBindings()
                        }
                    ), in: 10...500, step: 10)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Max Total Particles")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Performance limit for multiple bursts")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
                HStack {
                    Text("\(currentSettings.maxTotalParticles)")
                        .font(.system(.body, design: .monospaced))
                        .frame(width: 60, alignment: .trailing)
                    Slider(value: Binding(
                        get: { Double(currentSettings.maxTotalParticles) },
                        set: { 
                            currentSettings.maxTotalParticles = Int($0)
                            updateBindings()
                        }
                    ), in: 200...2000, step: 100)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Burst Speed Range")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Text("Min: \(Int(currentSettings.burstSpeedMin))")
                        .font(.system(.caption, design: .monospaced))
                        .frame(width: 80, alignment: .leading)
                    Spacer()
                    Text("Max: \(Int(currentSettings.burstSpeedMax))")
                        .font(.system(.caption, design: .monospaced))
                        .frame(width: 80, alignment: .trailing)
                }
                Slider(value: Binding(
                    get: { currentSettings.burstSpeedMin },
                    set: { newValue in 
                        currentSettings.burstSpeedMin = min(newValue, currentSettings.burstSpeedMax - 1)
                        updateBindings()
                    }
                ), in: 100...9999)
                Slider(value: Binding(
                    get: { currentSettings.burstSpeedMax },
                    set: { newValue in
                        currentSettings.burstSpeedMax = max(newValue, currentSettings.burstSpeedMin + 1)
                        updateBindings()
                    }
                ), in: 101...10000)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Burst Direction")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("0° = →, 90° = ↓, 180° = ←, 270° = ↑")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
                HStack {
                    Text("\(Int(currentSettings.burstDirection))°")
                        .font(.system(.body, design: .monospaced))
                        .frame(width: 50, alignment: .trailing)
                    Slider(value: $currentSettings.burstDirection, in: 0...360)
                        .onChange(of: currentSettings.burstDirection) { _ in updateBindings() }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Burst Cone Spread")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("How wide the burst spreads from direction")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
                HStack {
                    Text("\(Int(currentSettings.upwardBias))°")
                        .font(.system(.body, design: .monospaced))
                        .frame(width: 50, alignment: .trailing)
                    Slider(value: $currentSettings.upwardBias, in: 0...180)
                        .onChange(of: currentSettings.upwardBias) { _ in updateBindings() }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Burst Origin X")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Horizontal position (0 = left, 0.5 = center, 1 = right)")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
                HStack {
                    Text("\(String(format: "%.2f", currentSettings.burstX))")
                        .font(.system(.body, design: .monospaced))
                        .frame(width: 50, alignment: .trailing)
                    Slider(value: $currentSettings.burstX, in: 0...1)
                        .onChange(of: currentSettings.burstX) { _ in updateBindings() }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Burst Origin Y")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Vertical position in pixels from top")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
                HStack {
                    Text("\(Int(currentSettings.burstY))")
                        .font(.system(.body, design: .monospaced))
                        .frame(width: 50, alignment: .trailing)
                    Slider(value: $currentSettings.burstY, in: -200...500)
                        .onChange(of: currentSettings.burstY) { _ in updateBindings() }
                }
            }
        }
    }
    
    private var physicsContent: some View {
        Group {
            VStack(alignment: .leading, spacing: 8) {
                Text("Gravity")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Text("\(Int(currentSettings.gravity))")
                        .font(.system(.body, design: .monospaced))
                        .frame(width: 50, alignment: .trailing)
                    Slider(value: $currentSettings.gravity, in: 10...5000)
                        .onChange(of: currentSettings.gravity) { _ in updateBindings() }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Mass Range")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Text("Min: \(String(format: "%.1f", currentSettings.massMin))")
                        .font(.system(.caption, design: .monospaced))
                        .frame(width: 80, alignment: .leading)
                    Spacer()
                    Text("Max: \(String(format: "%.1f", currentSettings.massMax))")
                        .font(.system(.caption, design: .monospaced))
                        .frame(width: 80, alignment: .trailing)
                }
                Slider(value: Binding(
                    get: { currentSettings.massMin },
                    set: { newValue in
                        currentSettings.massMin = min(newValue, currentSettings.massMax - 0.1)
                        updateBindings()
                    }
                ), in: 0.1...2.9)
                Slider(value: Binding(
                    get: { currentSettings.massMax },
                    set: { newValue in
                        currentSettings.massMax = max(newValue, currentSettings.massMin + 0.1)
                        updateBindings()
                    }
                ), in: 0.2...3.0)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Drag Coefficient Range")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Text("Min: \(String(format: "%.1f", currentSettings.dragMin))")
                        .font(.system(.caption, design: .monospaced))
                        .frame(width: 80, alignment: .leading)
                    Spacer()
                    Text("Max: \(String(format: "%.1f", currentSettings.dragMax))")
                        .font(.system(.caption, design: .monospaced))
                        .frame(width: 80, alignment: .trailing)
                }
                Slider(value: Binding(
                    get: { currentSettings.dragMin },
                    set: { newValue in
                        currentSettings.dragMin = min(newValue, currentSettings.dragMax - 0.1)
                        updateBindings()
                    }
                ), in: 0.1...1.9)
                Slider(value: Binding(
                    get: { currentSettings.dragMax },
                    set: { newValue in
                        currentSettings.dragMax = max(newValue, currentSettings.dragMin + 0.1)
                        updateBindings()
                    }
                ), in: 0.2...2.0)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Fall Duration Base")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Text("\(String(format: "%.1f", currentSettings.fallDurationBase))s")
                        .font(.system(.body, design: .monospaced))
                        .frame(width: 50, alignment: .trailing)
                    Slider(value: $currentSettings.fallDurationBase, in: 0.2...3.0)
                        .onChange(of: currentSettings.fallDurationBase) { _ in updateBindings() }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Fade Out Timing")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Start fade at \(Int(currentSettings.fadeStartPercent * 100))% of fall")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
                Slider(value: $currentSettings.fadeStartPercent, in: 0.5...1.0)
                    .onChange(of: currentSettings.fadeStartPercent) { _ in updateBindings() }
                
                Text("Fade over \(Int(currentSettings.fadeDuration * 100))% of fall time")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
                Slider(value: $currentSettings.fadeDuration, in: 0.05...0.5)
                    .onChange(of: currentSettings.fadeDuration) { _ in updateBindings() }
            }
        }
    }
    
    private var wobbleContent: some View {
        Group {
            VStack(alignment: .leading, spacing: 8) {
                Text("Amplitude Range")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Text("Min: \(Int(currentSettings.wobbleAmplitudeMin))")
                        .font(.system(.caption, design: .monospaced))
                        .frame(width: 80, alignment: .leading)
                    Spacer()
                    Text("Max: \(Int(currentSettings.wobbleAmplitudeMax))")
                        .font(.system(.caption, design: .monospaced))
                        .frame(width: 80, alignment: .trailing)
                }
                Slider(value: Binding(
                    get: { currentSettings.wobbleAmplitudeMin },
                    set: { newValue in
                        currentSettings.wobbleAmplitudeMin = min(newValue, currentSettings.wobbleAmplitudeMax - 1)
                        updateBindings()
                    }
                ), in: 0...29)
                Slider(value: Binding(
                    get: { currentSettings.wobbleAmplitudeMax },
                    set: { newValue in
                        currentSettings.wobbleAmplitudeMax = max(newValue, currentSettings.wobbleAmplitudeMin + 1)
                        updateBindings()
                    }
                ), in: 1...30)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Frequency Range")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Text("Min: \(String(format: "%.1f", currentSettings.wobbleFrequencyMin))")
                        .font(.system(.caption, design: .monospaced))
                        .frame(width: 80, alignment: .leading)
                    Spacer()
                    Text("Max: \(String(format: "%.1f", currentSettings.wobbleFrequencyMax))")
                        .font(.system(.caption, design: .monospaced))
                        .frame(width: 80, alignment: .trailing)
                }
                Slider(value: Binding(
                    get: { currentSettings.wobbleFrequencyMin },
                    set: { newValue in
                        currentSettings.wobbleFrequencyMin = min(newValue, currentSettings.wobbleFrequencyMax - 0.1)
                        updateBindings()
                    }
                ), in: 0...9.9)
                Slider(value: Binding(
                    get: { currentSettings.wobbleFrequencyMax },
                    set: { newValue in
                        currentSettings.wobbleFrequencyMax = max(newValue, currentSettings.wobbleFrequencyMin + 0.1)
                        updateBindings()
                    }
                ), in: 0.1...10)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Wobble Decay")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("How much wobble decreases as particles fall")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
                HStack {
                    Text("None")
                        .font(.caption)
                    Slider(value: $currentSettings.wobbleDecay, in: 0...1)
                        .onChange(of: currentSettings.wobbleDecay) { _ in updateBindings() }
                    Text("Full")
                        .font(.caption)
                }
                Text("\(String(format: "%.0f", currentSettings.wobbleDecay * 100))% decay")
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var metallicContent: some View {
        Group {
            Toggle("Enable Metallic Effects", isOn: $currentSettings.metallicEnabled)
                .padding(.vertical, 4)
                .onChange(of: currentSettings.metallicEnabled) { _ in updateBindings() }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Metallic Gradient Intensity")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("How strong the metallic gradient is (0 = flat color)")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
                HStack {
                    Text("Flat")
                        .font(.caption)
                    Slider(value: $currentSettings.metallicIntensity, in: 0...1)
                        .onChange(of: currentSettings.metallicIntensity) { _ in updateBindings() }
                    Text("Full")
                        .font(.caption)
                }
                Text("\(Int(currentSettings.metallicIntensity * 100))%")
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.secondary)
            }
            .disabled(!currentSettings.metallicEnabled)
            .opacity(currentSettings.metallicEnabled ? 1.0 : 0.5)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Shimmer Intensity")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Brightness of the glint effect when catching light")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
                HStack {
                    Text("None")
                        .font(.caption)
                    Slider(value: $currentSettings.shimmerIntensity, in: 0...1)
                        .onChange(of: currentSettings.shimmerIntensity) { _ in updateBindings() }
                    Text("Bright")
                        .font(.caption)
                }
                Text("\(Int(currentSettings.shimmerIntensity * 100))%")
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.secondary)
            }
            .disabled(!currentSettings.metallicEnabled)
            .opacity(currentSettings.metallicEnabled ? 1.0 : 0.5)
        }
    }
    
    private var appearanceContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Size Range (pixels)")
                .font(.caption)
                .foregroundColor(.secondary)
            HStack {
                Text("Min: \(Int(currentSettings.sizeMin))")
                    .font(.system(.caption, design: .monospaced))
                    .frame(width: 80, alignment: .leading)
                Spacer()
                Text("Max: \(Int(currentSettings.sizeMax))")
                    .font(.system(.caption, design: .monospaced))
                    .frame(width: 80, alignment: .trailing)
            }
            Slider(value: Binding(
                get: { currentSettings.sizeMin },
                set: { newValue in
                    currentSettings.sizeMin = min(newValue, currentSettings.sizeMax - 1)
                    updateBindings()
                }
            ), in: 2...29)
            Slider(value: Binding(
                get: { currentSettings.sizeMax },
                set: { newValue in
                    currentSettings.sizeMax = max(newValue, currentSettings.sizeMin + 1)
                    updateBindings()
                }
            ), in: 3...30)
        }
    }
    
    // MARK: - Helper Methods
    
    private func updateBindings() {
        switch selectedMode {
        case .default:
            regularCardSettings = currentSettings
        case .fromTheTop:
            fromTheTopSettings = currentSettings
        }
    }
    
    private func copySettingsAsJSON() {
        // Create a copy with hex colors for JSON export
        var settingsWithColors = currentSettings
        
        // Convert current color palette to hex strings for JSON export
        let hexColors = currentSettings.colorPalette.map { color -> String in
            // Convert Color to hex string
            #if os(iOS)
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            let r = Int(red * 255)
            let g = Int(green * 255)
            let b = Int(blue * 255)
            
            return String(format: "#%02X%02X%02X", r, g, b)
            #else
            // For macOS or other platforms, return a default hex color
            // In a real implementation, you'd convert NSColor
            return "#FFFFFF"
            #endif
        }
        
        // Use reflection to set the private colorHexStrings property for encoding
        let mirror = Mirror(reflecting: settingsWithColors)
        if let child = mirror.children.first(where: { $0.label == "colorHexStrings" }) {
            // This is a workaround since we can't directly set private properties
            // Instead, we'll create a new settings object from JSON
            var jsonDict: [String: Any] = [
                "particleCount": settingsWithColors.particleCount,
                "maxTotalParticles": settingsWithColors.maxTotalParticles,
                "burstSpeedMin": settingsWithColors.burstSpeedMin,
                "burstSpeedMax": settingsWithColors.burstSpeedMax,
                "upwardBias": settingsWithColors.upwardBias,
                "burstDirection": settingsWithColors.burstDirection,
                "burstX": settingsWithColors.burstX,
                "burstY": settingsWithColors.burstY,
                "gravity": settingsWithColors.gravity,
                "massMin": settingsWithColors.massMin,
                "massMax": settingsWithColors.massMax,
                "dragMin": settingsWithColors.dragMin,
                "dragMax": settingsWithColors.dragMax,
                "fallDurationBase": settingsWithColors.fallDurationBase,
                "wobbleAmplitudeMin": settingsWithColors.wobbleAmplitudeMin,
                "wobbleAmplitudeMax": settingsWithColors.wobbleAmplitudeMax,
                "wobbleFrequencyMin": settingsWithColors.wobbleFrequencyMin,
                "wobbleFrequencyMax": settingsWithColors.wobbleFrequencyMax,
                "wobbleDecay": settingsWithColors.wobbleDecay,
                "sizeMin": settingsWithColors.sizeMin,
                "sizeMax": settingsWithColors.sizeMax,
                "fadeStartPercent": settingsWithColors.fadeStartPercent,
                "fadeDuration": settingsWithColors.fadeDuration,
                "metallicEnabled": settingsWithColors.metallicEnabled,
                "metallicIntensity": settingsWithColors.metallicIntensity,
                "shimmerIntensity": settingsWithColors.shimmerIntensity,
                "colors": hexColors
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [.prettyPrinted, .sortedKeys])
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    #if os(iOS)
                    UIPasteboard.general.string = jsonString
                    let modeName = selectedMode == .default ? "default" : "fromTheTop"
                    print("📋 Copied \(modeName) settings as JSON to clipboard (with colors)")
                    withAnimation(.easeIn(duration: 0.3)) {
                        showCopiedAlert = true
                    }
                    #endif
                }
            } catch {
                print("Failed to encode settings: \(error)")
            }
        }
    }
    
    func onAppear() {
        switch selectedMode {
        case .default:
            currentSettings = regularCardSettings
        case .fromTheTop:
            currentSettings = fromTheTopSettings
        }
    }
}