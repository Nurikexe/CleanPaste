import ServiceManagement
import SwiftUI

enum LaunchAtLoginSettings {
    static var isEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    static func setEnabled(_ isEnabled: Bool) throws {
        if isEnabled {
            if SMAppService.mainApp.status != .enabled {
                try SMAppService.mainApp.register()
            }
        } else {
            if SMAppService.mainApp.status == .enabled {
                try SMAppService.mainApp.unregister()
            }
        }
    }
}

struct SettingsView: View {
    @State private var launchAtLogin = LaunchAtLoginSettings.isEnabled
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section("Settings") {
                Toggle("Launch when starting", isOn: Binding(
                    get: { launchAtLogin },
                    set: updateLaunchAtLogin
                ))

                if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
        .formStyle(.grouped)
        .padding(20)
        .frame(width: 360)
        .onAppear {
            launchAtLogin = LaunchAtLoginSettings.isEnabled
        }
    }

    private func updateLaunchAtLogin(_ isEnabled: Bool) {
        do {
            try LaunchAtLoginSettings.setEnabled(isEnabled)
            launchAtLogin = LaunchAtLoginSettings.isEnabled
            errorMessage = nil
        } catch {
            launchAtLogin = LaunchAtLoginSettings.isEnabled
            errorMessage = "Could not update launch setting."
        }
    }
}
