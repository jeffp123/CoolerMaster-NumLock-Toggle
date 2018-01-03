//
//  AppDelegate.swift
//  CoolerMasterNumLockToggle
//
//  Created by Jeff Peck - Home on 1/2/18.
//  Copyright © 2018 Jeff Peck. All rights reserved.
//

// Notes:
// http://eon.codes/blog/2017/11/09/mac-status-bar-app/

import Cocoa

let kNameMatch = "MasterKeys*"
let kNumLockKeyCode = 71

private func toggleNumLock() {
    toggle("num", kNameMatch)
}

private func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    if [.keyDown].contains(type) {
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        
        if keyCode == kNumLockKeyCode {
            toggleNumLock()
        }
    }
    return Unmanaged.passRetained(event)
}

private func captureKeyPresses() {
    let eventMask = (1 << CGEventType.keyDown.rawValue)
    guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                           place: .headInsertEventTap,
                                           options: .defaultTap,
                                           eventsOfInterest: CGEventMask(eventMask),
                                           callback: myCGEventCallback,
                                           userInfo: nil)
        else {
            print("failed to create event tap")
            exit(1)
    }
    
    let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
    CGEvent.tapEnable(tap: eventTap, enable: true)
    CFRunLoopRun()
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    var statusBar = NSStatusBar.system
    var statusBarItem : NSStatusItem = NSStatusItem()
    var menu: NSMenu = NSMenu()


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            print("Access Not Enabled")
        }
        
        captureKeyPresses()
        
        
        statusBarItem = statusBar.statusItem(withLength: -1)
        statusBarItem.menu = menu
        statusBarItem.title = "CM NumLockToggle"
        statusBarItem.highlightMode = true
        
        let toggleMenuItem = NSMenuItem(title: "Toggle", action: #selector(toggle), keyEquivalent: "")
        menu.addItem(toggleMenuItem)
        
        let seperatorMenuItem = NSMenuItem.separator()
        menu.addItem(seperatorMenuItem)
        
        let aboutMenuItem = NSMenuItem(title: "About", action: #selector(about), keyEquivalent: "")
        menu.addItem(aboutMenuItem)
        
        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "")
        menu.addItem(quitMenuItem)
    }
    
    @objc func toggle(sender: AnyObject){
        toggleNumLock()
    }
    
    @objc func about(sender: AnyObject){
        Swift.print("about")
        // TODO
    }
    
    @objc func quitApp(){
        exit(0)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func referesDarkMode() {
        // TODO
    }


}

