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
    
    /// The views to fade out/in based on mouse activity
    var mouseActivityFadeViews : [NSView] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the window
        styleWindow();
    }
    
    /// Called when the user presses CMD+SHIFT+L(View/Toggle Sidebar)
    func toggleSidebar() {
        // Toggle the sidebar
        contentSplitViewController!.splitViewItems[0].collapsed = !contentSplitViewController!.splitViewItems[0].collapsed;
        
        // If the cursor is outside of this window...
        if(!window.cursorIn) {
            // Fade out the mouse activity views
            fadeOutMouseActivityFadeViews();
        }
    }
    
    /// Fades out all the views in mouseActivityFadeViews and the titlebar
    func fadeOutMouseActivityFadeViews() {
        // Set the animation duration
        NSAnimationContext.currentContext().duration = NSTimeInterval(GZValues.mouseActivityFadeDuration);
        
        // For every view in mouseActivityFadeViews...
        for(_, currentFadeView) in mouseActivityFadeViews.enumerate() {
            // Fade out the current view
            currentFadeView.animator().alphaValue = 0;
        }
        
        // If the sidebar is collapsed and we arent in fullscreen...
        if(contentSplitViewController!.splitViewItems[0].collapsed && !window.fullscreen) {
            // Fade out the titlebar
            window.titlebarView.animator().alphaValue = 0;
        }
    }
    
    /// Fades in all the views in mouseActivityFadeViews and the titlebar
    func fadeInMouseActivityFadeViews() {
        // Set the animation duration
        NSAnimationContext.currentContext().duration = NSTimeInterval(GZValues.mouseActivityFadeDuration);
        
        // For every view in mouseActivityFadeViews...
        for(_, currentFadeView) in mouseActivityFadeViews.enumerate() {
            // Fade in the current view
            currentFadeView.animator().alphaValue = 1;
        }
        
        // Fade in the titlebar
        window.titlebarView.animator().alphaValue = 1;
    }
    
    func windowWillEnterFullScreen(notification: NSNotification) {
        // Set the animation duration
        NSAnimationContext.currentContext().duration = NSTimeInterval(GZValues.mouseActivityFadeDuration);
        
        // Fade in the titlebar
        window.titlebarView.animator().alphaValue = 1;
        
        // Set the window's appearance to vibrant dark so the fullscreen toolbar is dark
        window.appearance = NSAppearance(named: NSAppearanceNameVibrantDark);
    }
    
    func windowDidExitFullScreen(notification: NSNotification) {
        // Set back the window's appearance
        window.appearance = NSAppearance(named: NSAppearanceNameAqua);
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
        
        // Load an example image
        contentImageViewController!.displayImage(GZImage(path: NSHomeDirectory() + "/Pictures/Cute/1466125139266.jpg"));
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender);
        
        // If the segue is for the container view linking to the content split view controller...
        if(segue.identifier == "imageViewerContentSplitViewControllerSegue") {
            // Set contentSplitViewController to the destination view controller
            contentSplitViewController = (segue.destinationController as! GZImageViewerSplitViewController);
            
            // Set contentSidebarViewController and contentImageViewController
            contentSidebarViewController = (contentSplitViewController!.splitViewItems[0].viewController as! GZImageViewerSidebarViewController);
            contentImageViewController = (contentSplitViewController!.splitViewItems[1].viewController as! GZImageViewerImageViewController);
        }
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        super.mouseEntered(theEvent);
        
        // Fade in the mouse activity fade views and the titlebar
        fadeInMouseActivityFadeViews();
    }
    
    override func mouseExited(theEvent: NSEvent) {
        super.mouseExited(theEvent);
        
        // Fade out the mouse activity fade views and the titlebar
        fadeOutMouseActivityFadeViews();
    }
    
    /// The tracking area for this view controller
    private var trackingArea : NSTrackingArea? = nil;
    
    override func viewWillLayout() {
        super.viewWillLayout();
        
        // Update the tracking areas
        updateTrackingAreas();
    }
    
    func updateTrackingAreas() {
        // Remove alll the tracking areas
        for(_, currentTrackingArea) in self.view.trackingAreas.enumerate() {
            self.view.removeTrackingArea(currentTrackingArea);
        }
        
        /// The same as the original tracking area, but updated to match the frame of this view
        trackingArea = NSTrackingArea(rect: self.view.frame, options: [NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.ActiveInKeyWindow, NSTrackingAreaOptions.AssumeInside], owner: self, userInfo: nil);
        
        // Add the tracking area
        self.view.addTrackingArea(trackingArea!);
    }
    
    override func awakeFromNib() {
        /// The tracking are we will use for getting mouse entered and exited events
        trackingArea = NSTrackingArea(rect: self.view.frame, options: [NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.ActiveInKeyWindow, NSTrackingAreaOptions.AssumeInside], owner: self, userInfo: nil);
        
        // Add the tracking area
        self.view.addTrackingArea(trackingArea!);
    }
}