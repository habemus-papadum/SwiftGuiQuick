//
//  Tests.swift
//  Tests
//
//  Created by Nehal Patel on 4/20/18.
//  Copyright © 2018 LIL. All rights reserved.
//

import Cocoa
import XCTest

class Tests: XCTestCase {
    class AppDel: NSObject, NSApplicationDelegate {
        var mainWindow: NSWindow? //need to retain window to avoid collection
        func applicationDidFinishLaunching(_ aNotification: Notification) {
            let window = NSWindow(contentRect: NSMakeRect(800, 600, 320, 200),
                    styleMask: [.titled, .closable, .resizable],
                    backing: .buffered,
                    defer: true)

            let view = NSView(frame: NSMakeRect(0, 0, 320, 200))
            let layer = CALayer.init();

            layer.backgroundColor = NSColor.red.cgColor;
            layer.autoresizingMask = [.layerHeightSizable, .layerWidthSizable]
            view.layer = layer;
            view.wantsLayer = true


            window.contentView!.addSubview(view);
            window.orderFrontRegardless()
            mainWindow = window
            NSApp.activate(ignoringOtherApps: true)
        }
        //if you like
        func applicationShouldTerminateAfterLastWindowClosed(_ app: NSApplication) -> Bool {
            return true
        }
    }

    override func setUp() {
        super.setUp()
        _ = NSApplication.shared
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        NSApp.setActivationPolicy(.regular)
        NSApp.delegate = AppDel()
        NSApp.run()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
