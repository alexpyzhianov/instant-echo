//
//  AppDelegate.swift
//  Instant Recorder
//
//  Created by Alexey Pyzhianov on 31.05.2020.
//  Copyright © 2020 Alex Pyzhianov. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var popover: NSPopover?
    var statusBarItem: NSStatusItem?
    var soundRecorder = SoundRecorder()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView().padding()
        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 120)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem?.button {
            button.image = NSImage(named: "Record")
            button.action = #selector(onButtonClick(_:))
        }
    }
    
    @objc func onButtonClick(_ sender: AnyObject?) {
        if let button = self.statusBarItem?.button {
            if (popover?.isShown ?? false) {
                soundRecorder.clear()
                popover?.performClose(sender)
            } else if (soundRecorder.recorder?.isRecording ?? false) {
                soundRecorder.stop()
                button.image = NSImage(named: "Record")
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                popover?.contentViewController?.view.window?.becomeKey()
            } else {
                soundRecorder.start()
                button.image = NSImage(named: "Stop")
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

