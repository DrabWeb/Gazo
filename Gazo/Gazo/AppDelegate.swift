//
//  AppDelegate.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    /// File/Open (⌘O)
    @IBOutlet weak var menuItemOpen: NSMenuItem!
    
    /// Browser/Set Tags For Selected Images (⌥⌘T)
    @IBOutlet weak var menuItemSetTagsForSelectedImages: NSMenuItem!
    
    /// Browser/Add Tags To Selected Images (⌃⌘T)
    @IBOutlet weak var menuItemAddTagsToSelectedImages: NSMenuItem!
    
    /// View/Toggle Sidebar (⇧⌘L)
    @IBOutlet weak var menuItemToggleSidebar: NSMenuItem!

    /// Window/Fit Window to Image (⌘1)
    @IBOutlet weak var menuItemFitWindowToImage: NSMenuItem!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        // Setup the menu item
        setupMenuItems();
    }
    
    // Sets up the menu items actions
    func setupMenuItems() {
        // Set the actions
        // File
        menuItemOpen.action = Selector("open");
        
        // Browser
        menuItemSetTagsForSelectedImages.action = Selector("setTagsForSelectedImages");
        menuItemAddTagsToSelectedImages.action = Selector("addTagsToSelectedImages");
        
        // View
        menuItemToggleSidebar.action = Selector("toggleSidebar");
        menuItemFitWindowToImage.action = Selector("scaleWindowToFitImage");
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

