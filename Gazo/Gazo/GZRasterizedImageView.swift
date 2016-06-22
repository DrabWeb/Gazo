//
//  GZRasterizedImageView.swift
//  Gazo
//
//  Created by Seth on 2016-06-20.
//

import Cocoa

class GZRasterizedImageView: NSImageView {
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
        // Rasterize the layer
        self.layer?.shouldRasterize = true;
    }
}