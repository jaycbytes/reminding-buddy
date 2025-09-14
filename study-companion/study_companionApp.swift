//
//  study_companionApp.swift
//  study-companion
//
//  Created by Jay Castro on 9/14/25.
//

import SwiftUI
import AppKit

@main
struct study_companionApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var floatingPanel: FloatingPanel?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide the main app from dock and cmd+tab
        NSApp.setActivationPolicy(.accessory)
        
        // Create floating panel
        floatingPanel = FloatingPanel()
        floatingPanel?.makeKeyAndOrderFront(nil)
    }
}

class FloatingPanel: NSPanel {
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 520, height: 140), // Wider to fit character + dialogue
            styleMask: [.nonactivatingPanel, .titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        // Panel properties
        self.level = .floating
        self.isFloatingPanel = true
        self.hidesOnDeactivate = false
        self.hasShadow = false
        self.backgroundColor = NSColor.clear
        self.isOpaque = false
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        
        // Position in top-right corner
        self.positionInTopRight()
        
        // Set up SwiftUI content
        let contentView = CharacterView()
        self.contentView = NSHostingView(rootView: contentView)
    }
    
    private func positionInTopRight() {
        guard let screen = NSScreen.main else { return }
        let screenRect = screen.visibleFrame
        let panelRect = self.frame
        
        let x = screenRect.maxX - panelRect.width - 20  // 20px margin from right
        let y = screenRect.maxY - panelRect.height - 20 // 20px margin from top
        
        self.setFrameOrigin(NSPoint(x: x, y: y))
    }
    
    // Allow the panel to become key when needed for text input
    override var canBecomeKey: Bool {
        return true
    }
}
