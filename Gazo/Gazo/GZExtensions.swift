//
//  GZExtensions.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

extension NSWindow {
    /// Returns the titlebar view for this window
    var titlebarView : NSView {
        return self.standardWindowButton(.CloseButton)!.superview!.superview!;
    }
    
    /// Is the window fullscreen?
    var fullscreen : Bool {
        // Return true/false depending on if the windows style mask contains NSFullScreenWindowMask
        return ((self.styleMask & NSFullScreenWindowMask) > 0);
    }
    
    /// Is the cursor hovering this window?
    var cursorIn : Bool {
        // Is the cursor in this window?
        var cursorIn : Bool = false;
        
        /// The CGEventRef for getting the cursor's location
        let mouseEvent : CGEventRef = CGEventCreate(nil)!;
        
        /// The location of the cursor
        var mousePosition : CGPoint = CGEventGetLocation(mouseEvent);
        
        // Invert the Y position so its in the same coordinate system as the window
        mousePosition = CGPoint(x: mousePosition.x, y: abs(mousePosition.y - NSScreen.mainScreen()!.frame.height));
        
        // If the mouse is within this window on the X...
        if(mousePosition.x > self.frame.origin.x && mousePosition.x < (self.frame.origin.x + self.frame.size.width)) {
            // If the mouse is within this window on the Y...
            if(mousePosition.y > self.frame.origin.y && mousePosition.y < (self.frame.origin.y + self.frame.size.height)) {
                // Set cursorIn to true
                cursorIn = true;
            }
        }
        
        // Return if the cursor is in this window
        return cursorIn;
    }
}