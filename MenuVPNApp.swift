//
//  MenuVPNApp.swift
//  MenuVPN
//
//  Created by Oğuz Öztürk on 5.02.2025.
//

import SwiftUI

@main
struct MenuVPNApp: App {
    private var vpnController = VPNController(overlayManager: OverlayWindowManager())
    
    var body: some Scene {
        MenuBarExtra("", systemImage: vpnController.isActive ? "circle.fill" : "circle") {
            Button(vpnController.isActive ? "Stop VPN" : "Start VPN", action: toggleVPN)
            Divider()
            Button("Quit", action: quit)
        }
    }
    
    func toggleVPN() {
        Task {
            await vpnController.toggleVPN()
        }
    }
    
    func quit() {
        NSApplication.shared.terminate(nil)
    }
}
