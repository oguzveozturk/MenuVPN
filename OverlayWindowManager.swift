//
//  OverlayWindowManager.swift
//  MenuVPN
//
//  Created by Oğuz Öztürk on 5.02.2025.
//

import AppKit

@MainActor
protocol OverlayWindowManageable {
    func showOverlay()
    func hideOverlay()
}

final class OverlayWindowManager: OverlayWindowManageable {
    
    private var overlayWindow: NSWindow?
    
    func showOverlay() {
        if overlayWindow == nil {
            createOverlayWindow()
        }
        overlayWindow?.orderFront(nil)
    }
    
    func hideOverlay() {
        overlayWindow?.orderOut(nil)
    }
    
    private func createOverlayWindow() {
        let screenFrame = NSScreen.main?.frame ?? .zero
        overlayWindow = NSWindow(
            contentRect: screenFrame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        
        overlayWindow?.backgroundColor = NSColor.clear
        overlayWindow?.isOpaque = false
        overlayWindow?.hasShadow = false
        overlayWindow?.level = .screenSaver
        overlayWindow?.ignoresMouseEvents = true
        
        let overlayView = NSView(frame: screenFrame)
        overlayView.wantsLayer = true
        overlayView.layer?.borderWidth = 8
        overlayView.layer?.borderColor = NSColor.red.cgColor
        
        overlayWindow?.contentView = overlayView
    }
}
