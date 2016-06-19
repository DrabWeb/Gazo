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
}