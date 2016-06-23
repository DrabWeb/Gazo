//
//  GZImageBrowserViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-20.
//

import Cocoa

/// The view controller for image browsers, which let you browse all your images, folders, ETC.
class GZImageBrowserViewController: NSViewController, NSWindowDelegate {
    
    /// The main window of this view controller
    var window : NSWindow = NSWindow();
    
    /// The visual effect view for the titlebar of the window
    @IBOutlet var titlebarVisualEffectView: NSVisualEffectView!
    
    /// The split view controller for the content of this window
    var contentSplitViewController : NSSplitViewController? = nil;
    
    /// The controller for the sidebar view of this image browser
    var contentSidebarViewController : GZImageBrowserSidebarViewController? = nil;
    
    /// The controller for the image grid of this image browser
    var contentImageGridViewController : GZImageBrowserImageGridViewController? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the window
        styleWindow();
    }
    
    /// Called when the selection in the sidebar changes
    func sidebarSelectionChanged() {
        // I have to grab sidebarTableViewSelectedItem manually instead of passing it because for some reason GZImageBrowserSidebarViewControllers dont want to call selectors properly
        
        contentImageGridViewController!.displayImagesFromFolder(contentSidebarViewController!.sidebarTableViewSelectedItem.path, deepSearch: false);
    }
    
    /// Called when the user presses CMD+O(File/Open)
    func open() {
        // Open all the selected images in the image grid
        contentImageGridViewController!.openSelectedImages();
    }
    
    /// Called when the user presses CMD+ALT+T(Browser/Set Tags For Selected Images)
    func setTagsForSelectedImages() {
        // Tell the image grid to prompt to set tags for the selected images
        contentImageGridViewController!.promptToSetTagsForSelectedImages();
    }
    
    /// Called when the user presses CMD+CTRL+T(Browser/Add Tags To Selected Images)
    func addTagsToSelectedImages() {
        // Tell the image grid to prompt to add tags to the selected images
        contentImageGridViewController!.promptToAddTagsToSelectedImages();
    }
    
    /// Called when the user presses CMD+SHIFT+L(View/Toggle Sidebar)
    func toggleSidebar() {
        // Toggle the sidebar
        contentSplitViewController!.splitViewItems[0].collapsed = !contentSplitViewController!.splitViewItems[0].collapsed;
    }
    
    func windowWillEnterFullScreen(notification: NSNotification) {
        // Hide the toolbar
        window.toolbar?.visible = false;
        
        // Set the window's appearance to vibrant dark so the fullscreen toolbar is dark
        window.appearance = NSAppearance(named: NSAppearanceNameVibrantDark);
    }
    
    func windowDidExitFullScreen(notification: NSNotification) {
        // Show the toolbar
        window.toolbar?.visible = true;
        
        // Set back the window's appearance
        window.appearance = NSAppearance(named: NSAppearanceNameAqua);
    }
    
    /// Styles the window
    func styleWindow() {
        // Get the window
        window = NSApplication.sharedApplication().windows.last!;
        
        // Set the window's delegate
        window.delegate = self;
        
        // Style the visual effect views
        titlebarVisualEffectView.material = .Dark;
        
        // Style the window's titlebar
        window.titleVisibility = .Hidden;
        window.styleMask |= NSFullSizeContentViewWindowMask;
        window.titlebarAppearsTransparent = true;
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender);
        
        // If the segue is for the container view linking to the content split view controller...
        if(segue.identifier == "imageBrowserContentSplitViewControllerSegue") {
            // Set contentSplitViewController to the destination view controller
            contentSplitViewController = (segue.destinationController as! NSSplitViewController);
            
            // Set contentSidebarViewController and contentImageGridViewController
            contentSidebarViewController = (contentSplitViewController!.splitViewItems[0].viewController as! GZImageBrowserSidebarViewController);
            contentImageGridViewController = (contentSplitViewController!.splitViewItems[1].viewController as! GZImageBrowserImageGridViewController);
            
            // Setup the sidebar selection changed target and action
            contentSidebarViewController!.sidebarSelectionChangedTarget = self;
            contentSidebarViewController!.sidebarSelectionChangedAction = Selector("sidebarSelectionChanged");
        }
    }
}