//
//  GZImageInfoViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-23.
//

import Cocoa

/// The view controller for image info panels
class GZImageInfoViewController: NSViewController {
    
    /// The main window of this view controller
    var window : NSWindow = NSWindow();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the window
        styleWindow();
    }
    
    /// Displays the info from the given GZImage in this image info view
    func showInfoForImage(image : GZImage) {
        // Set the window title
        window.title = image.path.ToNSString.lastPathComponent;
    }
    
    /// Styles the window
    func styleWindow() {
        // Get the window
        window = NSApplication.sharedApplication().windows.last!;
    }
}