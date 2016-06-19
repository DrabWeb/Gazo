//
//  GZImageViewerViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// The view controller for image viewer views
class GZImageViewerViewController: NSViewController, NSWindowDelegate {
    
    /// The main window of this view controller
    var window : NSWindow = NSWindow();
    
    /// The split view controller for the content of this window
    var contentSplitViewController : GZImageViewerSplitViewController? = nil;
    
    /// The controller for the sidebar view of this image viewer view
    var contentSidebarViewController : GZImageViewerSidebarViewController? = nil;
    
    /// The controller for the image view of this image viewer view
    var contentImageViewController : GZImageViewerImageViewController? = nil;
    
    // Is contentSidebarViewController collapsed?
    var sidebarCollapsedState : Bool = false;
    
    func windowDidEnterFullScreen(notification: NSNotification) {
        // If the sidebar is collapsed...
        if(sidebarCollapsedState) {
            // Show the traffic lights
            window.standardWindowButton(.CloseButton)?.superview?.superview?.hidden = false;
        }
    }
    
    func windowWillExitFullScreen(notification: NSNotification) {
        // If the sidebar is collapsed...
        if(sidebarCollapsedState) {
            // Hide the traffic lights
            window.standardWindowButton(.CloseButton)?.superview?.superview?.hidden = true;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the window
        styleWindow();
    }
    
    /// Styles the window
    func styleWindow() {
        // Get the window
        window = NSApplication.sharedApplication().windows.last!;
        
        // Set the window's delegate
        window.delegate = self;
        
        // Style the window
        window.styleMask |= NSFullSizeContentViewWindowMask;
        window.titlebarAppearsTransparent = true;
        window.titleVisibility = .Hidden;
    }
    
    /// Called when the collapsed state changes for contentSplitViewController
    func contentSplitViewControllerCollapsedStateChanged(splitView : GZImageViewerSidebarViewController) {
        // If we arent in fullscreen...
        if(!((window.styleMask & NSFullScreenWindowMask) > 0)) {
            // Set sidebarCollapsedState
            sidebarCollapsedState = contentSplitViewController!.splitViewItems[0].collapsed;
            
            // If the sidebar is now collapsed...
            if(sidebarCollapsedState) {
                // Hide the traffic lights
                window.standardWindowButton(.CloseButton)?.superview?.superview?.hidden = true;
            }
                // If the sidebar is now expanded...
            else {
                // Show the traffic lights
                window.standardWindowButton(.CloseButton)?.superview?.superview?.hidden = false;
            }
        }
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender);
        
        // If the segue is for the container view linking to the content split view controller...
        if(segue.identifier == "imageViewerContentSplitViewControllerSegue") {
            // Set contentSplitViewController to the destination view controller
            contentSplitViewController = (segue.destinationController as! GZImageViewerSplitViewController);
            
            // Set contentSplitViewController's collapsed state changed action and selector
            contentSplitViewController!.collapseStateChangedTarget = self;
            contentSplitViewController!.collapseStateChangedAction = Selector("contentSplitViewControllerCollapsedStateChanged:");
            
            // Set contentSidebarViewController and contentImageViewController
            contentSidebarViewController = (contentSplitViewController!.splitViewItems[0].viewController as! GZImageViewerSidebarViewController);
            contentImageViewController = (contentSplitViewController!.splitViewItems[1].viewController as! GZImageViewerImageViewController);
        }
    }
}