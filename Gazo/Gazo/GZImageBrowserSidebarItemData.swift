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
    
    /// The amount of images in this item
    var imageCount : Int = 0;
    
    /// The path to the folder this item represents, only applies if this is a folder sidebar item
    var path : String = "";
    
    /// The sidebar section this item is in
    var section : GZImageBrowserSidebarSection = .Folders;
    
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
    
    // Init with a title, icon and image count
    init(title : String, icon : NSImage, imageCount : Int) {
        self.title = title;
        self.icon = icon;
        
        // Make the icon a template
        self.icon!.template = true;
        
        self.imageCount = imageCount;
    }
    
    // Init with a title, icon, image count and path
    init(title : String, icon : NSImage, imageCount : Int, path : String) {
        self.title = title;
        self.icon = icon;
        
        // Make the icon a template
        self.icon!.template = true;
        
        self.imageCount = imageCount;
        
        self.path = path;
    }
}
