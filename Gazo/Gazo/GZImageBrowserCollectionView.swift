//
//  GZImageBrowserCollectionView.swift
//  Gazo
//
//  Created by Seth on 2016-06-21.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class GZImageBrowserCollectionView: NSCollectionView {
    /// The object to perform setTagsForSelectedImagesAction
    var setTagsForSelectedImagesTarget : AnyObject? = nil;
    
    /// The selector to call when the user right clicks and selects "Set Tags For Selected Image(s)"
    var setTagsForSelectedImagesAction : Selector = Selector("");
    
    /// The object to perform addTagsToSelectedImagesAction
    var addTagsToSelectedImagesTarget : AnyObject? = nil;
    
    /// The selector to call when the user right clicks and selects "Add Tags To Selected Image(s)"
    var addTagsToSelectedImagesAction : Selector = Selector("");
    
    override func menuForEvent(event: NSEvent) -> NSMenu? {
        /// The menu to return
        let menu : NSMenu = NSMenu();
        
        /// The "Set Tags For Selected Image(s)" menu item
        let setTagsForSelectedImagesMenuItem : NSMenuItem = NSMenuItem(title: "Set Tags For Selected Images", action: setTagsForSelectedImagesAction, keyEquivalent: "");
        
        /// The "Add Tags To Selected Image(s)" menu item
        let addTagsToSelectedImagesMenuItem : NSMenuItem = NSMenuItem(title: "Add Tags To Selected Images", action: addTagsToSelectedImagesAction, keyEquivalent: "");
        
        // Set the targets
        setTagsForSelectedImagesMenuItem.target = setTagsForSelectedImagesTarget;
        addTagsToSelectedImagesMenuItem.target = addTagsToSelectedImagesTarget;
        
        // If we only have one image selected...
        if(self.selectionIndexes.count == 1) {
            // Set the menu titles to reflect only one image
            setTagsForSelectedImagesMenuItem.title = "Set Tags For Selected Image";
            addTagsToSelectedImagesMenuItem.title = "Add Tags To Selected Image";
        }
        
        // Add the menu items
        menu.addItem(setTagsForSelectedImagesMenuItem);
        menu.addItem(addTagsToSelectedImagesMenuItem);
        
        // Return the menu
        return menu;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        // Set the appearance of the view
        self.appearance = NSAppearance(named: NSAppearanceNameVibrantDark);
    }
}
