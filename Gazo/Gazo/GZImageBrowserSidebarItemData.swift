//
//  GZImageBrowserSidebarItemData.swift
//  Gazo
//
//  Created by Seth on 2016-06-22.
//

import Cocoa

/// The data for an item in the sidebar of an image browser
class GZImageBrowserSidebarItemData {
    /// The title of the item
    var title : String = "";
    
    /// The icon of the item
    var icon : NSImage? = nil;
    
    /// Init with a title
    init(title : String) {
        self.title = title;
    }
    
    // Init with a title and icon
    init(title : String, icon : NSImage) {
        self.title = title;
        self.icon = icon;
        
        // Make the icon a template
        self.icon!.template = true;
    }
}
