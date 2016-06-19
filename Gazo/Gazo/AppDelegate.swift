//
//  AppDelegate.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    /// View/Toggle Sidebar (⇧⌘L)
    @IBOutlet weak var menuItemToggleSidebar: NSMenuItem!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        // Setup the menu item
        setupMenuItems();
    }
    
    // Sets up the menu items actions
    func setupMenuItems() {
        // Set the action
        menuItemToggleSidebar.action = Selector("toggleSidebar");
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

