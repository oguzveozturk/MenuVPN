//
//  VPNController.swift
//  MenuVPN
//
//  Created by Oğuz Öztürk on 5.02.2025.
//

import SwiftUI

@Observable
final class VPNController {
    var isActive = false
    private var overlayManager: OverlayWindowManageable
    private let vpnName = "VPN"
    
    init(overlayManager: OverlayWindowManageable) {
        self.overlayManager = overlayManager
    }
    
    func toggleVPN() async {
        if isActive {
            await deactivateVPN()
        } else {
            await activateVPN()
        }
    }
    
    private func activateVPN() async {
        let success = await runSCUtilCommand(arguments: ["--nc", "start", vpnName])
        isActive = success
        if success {
             await overlayManager.showOverlay()
        }
    }
    
    private func deactivateVPN() async {
        let success = await runSCUtilCommand(arguments: ["--nc", "stop", vpnName])
        isActive = !success
        if success {
            await overlayManager.hideOverlay()
        }
    }
    
    private func runSCUtilCommand(arguments: [String]) async -> Bool {
        return await withCheckedContinuation { continuation in
            let task = Process()
            task.launchPath = "/usr/sbin/scutil"
            task.arguments = arguments
            
            let pipe = Pipe()
            task.standardOutput = pipe
            task.standardError = pipe
            
            task.terminationHandler = { process in
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8) {
                    print("Command Output: \(output)")
                }
                continuation.resume(returning: process.terminationStatus == 0)
            }
            
            do {
                try task.run()
            } catch {
                print("Command Error: \(error)")
                continuation.resume(returning: false)
            }
        }
    }
}
