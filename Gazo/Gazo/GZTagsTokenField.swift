//
//  GZTagsTokenField.swift
//  Gazo
//
//  Created by Seth on 2016-06-20.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// A token field subclass for tags
class GZTagsTokenField: GZScaleToFitContentTokenField {
    func tokenField(tokenField: NSTokenField, writeRepresentedObjects objects: [AnyObject], toPasteboard pboard: NSPasteboard) -> Bool {
        // Add the string type to the pasteboard
        pboard.declareTypes([NSStringPboardType], owner: nil);
        
        /// The string to paste to the pasteboard
        var pasteString : String = "";
        
        // For every string in objects...
        for(_, currentString) in (objects as! [String]).enumerate() {
            // Add the current string with a trailing space to pasteString
            pasteString += currentString + " ";
        }
        
        // If pasteString isnt empty...
        if(pasteString != "") {
            // Remove the final trailing space from pasteString
            pasteString = pasteString.substringToIndex(pasteString.endIndex.predecessor());
        }
        
        // Paste pasteString to the pasteboard
        pboard.setString(pasteString, forType: NSStringPboardType);
        
        // Always allow copying tokens
        return true;
    }
    
    /// Adds the tags from the given array of GZTags to this token field
    func addTagsFromArray(tagArray : [GZTag]) {
        // For every given tag...
        for(_, currentTag) in tagArray.enumerate() {
            // Add the current tag's name to this token field's string value
            self.stringValue = self.stringValue + "," + currentTag.name;
        }
    }
}
