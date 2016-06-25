//
//  GZImageViewerViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
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
    
    /// The GZImage that is currently being displayed in this view
    var currentDisplayingImage : GZImage? = nil;
    
    /// Is this image viewer view embed? (Meaning it shouldnt do anything with the window)
    var embed : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the window
        styleWindow();
    }
    
    /// Called when the user does CMD+I(File/Get Info)
    func getInfo() {
        /// The window controller for the new image info view
        let newImageInfoWindowController : NSWindowController = storyboard!.instantiateControllerWithIdentifier("imageInfoWindowController") as! NSWindowController;
        
        // Load newImageInfoWindowController's view controller
        newImageInfoWindowController.contentViewController?.loadView();
        
        // Display this image's info in the image info view
        (newImageInfoWindowController.contentViewController as! GZImageInfoViewController).showInfoForImage(currentDisplayingImage!);
        
        // Display the window
        newImageInfoWindowController.showWindow(self);
    }
    
    /// Scales the window's height/width to fit the image(and sidebar if its open)
    func scaleWindowToFitImage() {
        // If this view isnt embed...
        if(!embed) {
            // If we arent in fullscreen...
            if(!window.fullscreen) {
                // If the current displaying image isnt nil...
                if(currentDisplayingImage != nil) {
                    /// The new size for the window
                    var newWindowSize : NSSize = window.frame.size;
                    
                    /// The size of the sidebar
                    var sidebarSize : CGFloat = contentSplitViewController!.splitViewItems[0].viewController.view.bounds.width;
                    
                    // If the sidebar is collapsed...
                    if(contentSplitViewController!.splitViewItems[0].collapsed) {
                        // Set sidebarSize to 0
                        sidebarSize = 0;
                    }
                    
                    // If the image is bigger horizontally...
                    if(currentDisplayingImage!.size.width > currentDisplayingImage!.size.height) {
                        /// The aspect ratio of currentDisplayingImage's image
                        let imageAspectRatio : CGFloat = currentDisplayingImage!.size.width / currentDisplayingImage!.size.height;
                        
                        /// The new width of the window
                        let newWindowWidth : CGFloat = (imageAspectRatio * window.frame.height) + sidebarSize;
                        
                        // Update newWindowSize
                        newWindowSize = NSSize(width: newWindowWidth, height: newWindowSize.height);
                    }
                        // If the image is bigger vertically...
                    else if(currentDisplayingImage!.size.height > currentDisplayingImage!.size.width) {
                        /// The aspect ratio of currentDisplayingImage's image
                        let imageAspectRatio : CGFloat = currentDisplayingImage!.size.height / currentDisplayingImage!.size.width;
                        
                        /// The new height of the window
                        let newWindowHeight : CGFloat = imageAspectRatio * (self.view.frame.width - sidebarSize);
                        
                        // Update newWindowSize
                        newWindowSize = NSSize(width: newWindowSize.width, height: newWindowHeight);
                    }
                    // If the image width and height are equal...
                    else {
                        /// The new width for the window.
                        let newWindowWidth : CGFloat = newWindowSize.height + sidebarSize;
                        
                        // Update newWindowSize
                        newWindowSize = NSSize(width: newWindowWidth, height: newWindowSize.height);
                    }
                    
                    // Resize the window
                    window.setFrame(NSRect(x: window.frame.origin.x, y: window.frame.origin.y, width: newWindowSize.width, height: newWindowSize.height), display: false);
                    
                    // Resize the sidebar
                    contentSplitViewController!.splitView.setPosition(sidebarSize, ofDividerAtIndex: 0);
                    contentSplitViewController!.splitView.adjustSubviews();
                }
            }
        }
    }
    
    /// Displays the given GZImage in this image viewer
    func displayImage(image : GZImage) {
        // Set currentDisplayingImage
        currentDisplayingImage = image;
        
        // If this view isnt embed...
        if(!embed) {
            // Set the window's title
            window.title = image.path.ToNSString.lastPathComponent;
        }
        
        // Display the image in the image view
        contentImageViewController!.displayImage(image);
        
        // Display the image in the sidebar
        contentSidebarViewController!.displayImage(image);
        
        // Scale the window to the image
        scaleWindowToFitImage();
    }
    
    /// Called when the user presses CMD+SHIFT+L(View/Toggle Sidebar)
    func toggleSidebar() {
        // Toggle the sidebar
        contentSplitViewController!.splitViewItems[0].collapsed = !contentSplitViewController!.splitViewItems[0].collapsed;
        
        // If this view isnt embed...
        if(!embed) {
            // If the cursor is outside the window...
            if(!window.cursorIn) {
                // Fade out the mouse activity views
                fadeOutMouseActivityFadeViews();
            }
            
            // If the sidebar is now expanded...
            if(!contentSplitViewController!.splitViewItems[0].collapsed) {
                // Fade in the mouse activity views
                fadeInMouseActivityFadeViews();
            }
        }
        
        // If the user enabled resizing image viewers to fit to their images when the sidebar is toggled...
        if(GZPreferences.defaultPreferences().resizeImageViewerWindowWhenSidebarToggled) {
            // Scale the window to fit the image
            scaleWindowToFitImage();
        }
    }
    
    /// Fades out all the views in mouseActivityFadeViews and the titlebar
    func fadeOutMouseActivityFadeViews() {
        // Set the animation duration
        NSAnimationContext.currentContext().duration = NSTimeInterval(GZConstants.mouseActivityFadeDuration);
        
        // For every view in mouseActivityFadeViews...
        for(_, currentFadeView) in mouseActivityFadeViews.enumerate() {
            // Fade out the current view
            currentFadeView.animator().alphaValue = 0;
        }
        
        // If this view isnt embed...
        if(!embed) {
            // If the sidebar is collapsed and we arent in fullscreen...
            if(contentSplitViewController!.splitViewItems[0].collapsed && !window.fullscreen) {
                // Fade out the titlebar
                window.titlebarView.animator().alphaValue = 0;
            }
        }
    }
    
    /// Fades in all the views in mouseActivityFadeViews and the titlebar
    func fadeInMouseActivityFadeViews() {
        // Set the animation duration
        NSAnimationContext.currentContext().duration = NSTimeInterval(GZConstants.mouseActivityFadeDuration);
        
        // For every view in mouseActivityFadeViews...
        for(_, currentFadeView) in mouseActivityFadeViews.enumerate() {
            // Fade in the current view
            currentFadeView.animator().alphaValue = 1;
        }
        
        // If this view isnt embed...
        if(!embed) {
            // Fade in the titlebar
            window.titlebarView.animator().alphaValue = 1;
        }
    }
    
    func windowWillEnterFullScreen(notification: NSNotification) {
        // Set the animation duration
        NSAnimationContext.currentContext().duration = NSTimeInterval(GZConstants.mouseActivityFadeDuration);
        
        // Fade in the titlebar
        window.titlebarView.animator().alphaValue = 1;
        
        // Set the window's appearance to vibrant dark so the fullscreen toolbar is dark
        window.appearance = NSAppearance(named: NSAppearanceNameVibrantDark);
        
        // Hide the titlebar visual effect view in the sidebar
        contentSidebarViewController!.hideTitlebarVisualEffectView();
    }
    
    func windowDidExitFullScreen(notification: NSNotification) {
        // Set back the window's appearance
        window.appearance = NSAppearance(named: NSAppearanceNameAqua);
        
        // Show the titlebar visual effect view in the sidebar
        contentSidebarViewController!.showTitlebarVisualEffectView();
    }
    
    /// Styles the window
    func styleWindow() {
        // If this view isnt embed...
        if(!embed) {
            // Get the window
            window = NSApplication.sharedApplication().windows.last!;
            
            // Set the window's delegate
            window.delegate = self;
            
            // Style the window
            window.styleMask |= NSFullSizeContentViewWindowMask;
            window.titlebarAppearsTransparent = true;
            window.titleVisibility = .Hidden;
        }
        // If this view is embed...
        else {
            // Hide the titlebar visual effect view in the sidebar
            contentSidebarViewController!.hideTitlebarVisualEffectView();
        }
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