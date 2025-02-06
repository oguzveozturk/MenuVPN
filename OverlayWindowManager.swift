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
    
    private var overlayWindows: [NSWindow] = []
    
    func showOverlay() {
        if overlayWindows.isEmpty {
            createOverlayWindows()
        }
        overlayWindows.forEach { $0.orderFront(nil) }
    }
    
    func hideOverlay() {
        overlayWindows.forEach { $0.orderOut(nil) }
    }
    
    private func createOverlayWindows() {
        overlayWindows.removeAll()
        
        for screen in NSScreen.screens {
            let overlayWindow = NSWindow(
                contentRect: screen.frame,
                styleMask: .borderless,
                backing: .buffered,
                defer: false
            )
            
            overlayWindow.backgroundColor = NSColor.clear
            overlayWindow.isOpaque = false
            overlayWindow.hasShadow = false
            overlayWindow.level = .screenSaver
            overlayWindow.ignoresMouseEvents = true
            
            let overlayView = NSView(frame: screen.frame)
            overlayView.wantsLayer = true
            overlayView.layer?.borderWidth = 8
            overlayView.layer?.borderColor = NSColor.red.cgColor
            
            overlayWindow.contentView = overlayView
            overlayWindows.append(overlayWindow)
        }
    }
}
