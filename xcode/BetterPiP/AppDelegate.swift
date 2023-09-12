//
//  AppDelegate.swift
//  BetterPiP
//
//  Created by Lukas on 22.09.17.
//  Copyright © 2017 Lukas von Mateffy. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var main: PiPControlWindowController!
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let menu = NSMenu()
    var launchedWithUrl = false
    
    func application(_ application: NSApplication) {
        print("launched with url")
        
        let urls = [URL(string:"blob:https://www.youtube.com/0c91a655-dc4c-4425-a7c6-9def5bf72c9f")]
        
        launchedWithUrl = true
        
        let appleEventManager = NSAppleEventManager.shared()
        appleEventManager.setEventHandler(self, andSelector: #selector(handleURL), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        }
        
        //let menu = NSMenu()
        
        //        menu.addItem(NSMenuItem(title: "Install Chrome Extension", action: #selector(openChromeExtensionPage), keyEquivalent: ""))
        //        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit BetterPiP", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
        
        if urls.count == 0 { return }
        
        let url = urls[0]
        print("url")
        guard let queryUrl = url?.absoluteString else { return }
        

        // guard let queryUrl: String = ((url?.queryParameters?["url"]!)!).removingPercentEncoding else { return }
        // guard let startTimeString: String = (url?.queryParameters?["time"]) else { return }
        
        var startTime: Float = 0.0;
        
        guard let window = NSStoryboard(name : NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("mainWindow")) as? PiPControlWindowController else { return }
        
        //print("Received URL: \(queryUrl)")
        //print("Start at: \(startTime)")
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        print("launched")
        guard let window = NSStoryboard(name : NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("mainWindow")) as? PiPControlWindowController else { return }
        window.showVideo(url: URL(string: "blob:https://www.youtube.com/0c91a655-dc4c-4425-a7c6-9def5bf72c9f")!, seconds: 0.0)
    }
    
    @objc func handleURL(event: NSAppleEventDescriptor, reply: NSAppleEventDescriptor) {
        
        let window = NSStoryboard(name : NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("mainWindow")) as! PiPControlWindowController

        let url = URL(string: (event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue)!)
        NSLog(url?.absoluteString ?? "handle url")
        let queryUrl: String = ((url?.queryParameters?["url"]!)!).removingPercentEncoding!
        let startTime: Float = 0.0;

        //print("Received URL: \(queryUrl)")
        //print("Start at: \(startTime)")

        window.showVideo(url: URL(string: queryUrl)!, seconds: startTime)
    }

    
//    func notify(message: String) {
//        let notification = NSUserNotification()
//        notification.title = "BetterPiP"
//        notification.informativeText = message
//        notification.soundName = NSUserNotificationDefaultSoundName
//        NSUserNotificationCenter.default.deliver(notification)
//    }
    
//    func openChromeExtensionPage() {
//        if let url = URL(string: "https://www.google.com"), NSWorkspace.shared().open(url) {
//            print("default browser was successfully opened")
//        }
//
//    }
    
}

extension URL {
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}
