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
    
    /// The tags for the source material of this image
    var sourceTags : [GZTag] = [];
    
    /// The tags for the characters in this image
    var characterTags : [GZTag] = [];
    
    /// The tags for the artist(s) of this image
    var artistTags : [GZTag] = [];
    
    /// Any other tags for this image that dont fit into a previous category
    var generalTags : [GZTag] = [];
    
    // Init with a path
    init(path : String) {
        super.init();
        
        self.path = path;
    }
}
