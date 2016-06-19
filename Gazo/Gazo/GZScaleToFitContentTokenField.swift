//
//  GZScaleToFitContentTokenField.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class GZScaleToFitContentTokenField: NSTokenField {
    
    override var intrinsicContentSize : NSSize {
        /// The intrinsic size to return, set as the size of this token field fit to the super view's width
        let size : NSSize = self.sizeThatFits(NSSize(width: self.superview!.frame.width, height: self.superview!.frame.height));
        
        // Return the size
        return size;
    }
    
    /// Calls invalidateIntrinsicContentSize
    func updateToFitContent() {
        // Re-calculate the intrinsic content size
        self.invalidateIntrinsicContentSize();
    }
    
    override func textDidChange(notification: NSNotification) {
        super.textDidChange(notification);
        
        // Update the size of this token field
        updateToFitContent();
    }
    
    override func viewWillDraw() {
        super.viewWillDraw();
        
        // Update the size of this token field
        updateToFitContent();
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        // Update the size of this token field
        updateToFitContent();
    }
}