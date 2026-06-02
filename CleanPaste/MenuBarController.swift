import AppKit
import SwiftUI

final class MenuBarController: NSObject {
    private let statusItem: NSStatusItem
    private let clipboardManager: ClipboardManager
    private let textCleaner: TextCleaner
    private var messageWindow: NSWindow?
    private var settingsWindow: NSWindow?

    init(
        clipboardManager: ClipboardManager = ClipboardManager(),
        textCleaner: TextCleaner = TextCleaner()
    ) {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.clipboardManager = clipboardManager
        self.textCleaner = textCleaner

        super.init()
        configureStatusItem()
        configureMenu()
    }

    private func configureStatusItem() {
        guard let button = statusItem.button else {
            return
        }

        button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "CleanPaste")
        button.image?.isTemplate = true
        button.toolTip = "CleanPaste"
    }

    private func configureMenu() {
        let menu = NSMenu()

        let cleanItem = NSMenuItem(title: "Clean Clipboard", action: #selector(cleanClipboard), keyEquivalent: "")
        cleanItem.target = self
        menu.addItem(cleanItem)

        menu.addItem(NSMenuItem.separator())

        let settingsItem = NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    @objc private func cleanClipboard() {
        guard let clipboardText = clipboardManager.readText(), !clipboardText.isEmpty else {
            showMessage("No text on clipboard")
            return
        }

        let cleanedText = textCleaner.clean(clipboardText)
        clipboardManager.writeText(cleanedText)
        showMessage("Clipboard cleaned")
    }

    @objc private func openSettings() {
        let window = settingsWindow ?? makeSettingsWindow()
        settingsWindow = window

        NSApp.activate(ignoringOtherApps: true)
        window.center()
        window.makeKeyAndOrderFront(nil)
    }

    private func makeSettingsWindow() -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 360, height: 150),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "CleanPaste Settings"
        window.contentView = NSHostingView(rootView: SettingsView())
        window.isReleasedWhenClosed = false
        return window
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }

    private func showMessage(_ message: String) {
        messageWindow?.close()

        let label = NSTextField(labelWithString: message)
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .labelColor
        label.alignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        let container = NSVisualEffectView()
        container.material = .hudWindow
        container.blendingMode = .behindWindow
        container.state = .active
        container.wantsLayer = true
        container.layer?.cornerRadius = 8
        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])

        let window = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 180, height: 40),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        window.contentView = container
        window.isFloatingPanel = true
        window.level = .floating
        window.backgroundColor = .clear
        window.hasShadow = true
        window.collectionBehavior = [.canJoinAllSpaces, .transient]

        if let button = statusItem.button,
           let buttonWindow = button.window {
            let buttonFrameOnScreen = buttonWindow.convertToScreen(button.frame)
            let windowX = buttonFrameOnScreen.midX - window.frame.width / 2
            let windowY = buttonFrameOnScreen.minY - window.frame.height - 8
            window.setFrameOrigin(NSPoint(x: windowX, y: windowY))
        }

        messageWindow = window
        window.orderFrontRegardless()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { [weak self, weak window] in
            window?.close()
            if self?.messageWindow === window {
                self?.messageWindow = nil
            }
        }
    }
}
