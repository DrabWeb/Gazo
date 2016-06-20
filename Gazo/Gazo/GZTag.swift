//
//  GZTag.swift
//  Gazo
//
//  Created by Seth on 2016-06-20.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// The object for a tag
struct GZTag {
    /// The name of this tag(E.g. "school swimsuit")
    var name : String = "";
    
    init(name : String) {
        self.name = name;
    }
    
    /// Return an array of GZTags with names from the given array of strings
    static func tagArrayFromStrings(stringArray : [String]) -> [GZTag] {
        /// The array of GZTags to return
        var tagsArray : [GZTag] = [];
        
        // For every string in the given strings...
        for(_, currentString) in stringArray.enumerate() {
            // Add a GZTag with the current string as it's name to tagsArray
            tagsArray.append(GZTag(name: currentString));
        }
        
        // Return the tags array
        return tagsArray;
    }
}
