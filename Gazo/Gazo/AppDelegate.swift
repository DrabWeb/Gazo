//
//  AppDelegate.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    /// File/Open (⌘O) (open)
    @IBOutlet weak var menuItemOpen: NSMenuItem!
    
    /// File/Get Info (⌘I) (getInfo)
    @IBOutlet weak var menuItemGetInfo: NSMenuItem!
    
    /// Browser/Set Tags For Selected Images (⌥⌘T) (setTagsForSelectedImages)
    @IBOutlet weak var menuItemSetTagsForSelectedImages: NSMenuItem!
    
    /// Browser/Add Tags To Selected Images (⌃⌘T) (addTagsToSelectedImages)
    @IBOutlet weak var menuItemAddTagsToSelectedImages: NSMenuItem!
    
    /// View/Toggle Sidebar (⇧⌘L) (toggleSidebar)
    @IBOutlet weak var menuItemToggleSidebar: NSMenuItem!

    /// Window/Fit Window to Image (⌘1) (scaleWindowToFitImage)
    @IBOutlet weak var menuItemFitWindowToImage: NSMenuItem!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        // Setup the menu items
        setupMenuItems();
        
        // Create the application support folders
        createApplicationSupportFolders();
    }
    
    // Sets up the menu items actions
    func setupMenuItems() {
        // Set the actions
        // File
        menuItemOpen.action = Selector("open");
        menuItemGetInfo.action = Selector("getInfo");
        
        // Browser
        menuItemSetTagsForSelectedImages.action = Selector("setTagsForSelectedImages");
        menuItemAddTagsToSelectedImages.action = Selector("addTagsToSelectedImages");
        
        // View
        menuItemToggleSidebar.action = Selector("toggleSidebar");
        menuItemFitWindowToImage.action = Selector("scaleWindowToFitImage");
    }
    
    /// Creates the application support folder for Gazo if it doesnt already exist(And the other folders Gazo need inside of it)
    func createApplicationSupportFolders() {
        // If the application support folder doesnt exist...
        if(!NSFileManager.defaultManager().fileExistsAtPath(NSHomeDirectory() + "/Library/Application Support/Gazo/")) {
            do {
                // Create the application support folder
                try NSFileManager.defaultManager().createDirectoryAtPath(NSHomeDirectory() + "/Library/Application Support/Gazo/", withIntermediateDirectories: false, attributes: nil);
            }
            catch _ as NSError {
                // Do nothing
            }
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

