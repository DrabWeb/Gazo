//
//  GZImageViewerViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class GZImageViewerViewController: NSViewController {
    
    /// The main window of this view controller
    var window : NSWindow = NSWindow();
    
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
        
        // Style the window
        window.styleMask |= NSFullSizeContentViewWindowMask;
        window.titlebarAppearsTransparent = true;
        window.titleVisibility = .Hidden;
    }
}