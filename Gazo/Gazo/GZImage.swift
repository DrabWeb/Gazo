//
//  GZImage.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// The class for holding info about a users image, such as the path and metadata
class GZImage: NSObject {
    /// The path to this image
    var path : String = "";
    
    // Init with a path
    init(path : String) {
        super.init();
        
        self.path = path;
    }
}
