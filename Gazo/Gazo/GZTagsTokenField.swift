//
//  GZTagsTokenField.swift
//  Gazo
//
//  Created by Seth on 2016-06-20.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class GZTagsTokenField: GZScaleToFitContentTokenField {
    func tokenField(tokenField: NSTokenField, readFromPasteboard pboard: NSPasteboard) -> [AnyObject]? {
        // Return the text from pboard split at every space
        return (pboard.stringForType(NSStringPboardType)?.componentsSeparatedByString(" "));
    }
    
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
}
