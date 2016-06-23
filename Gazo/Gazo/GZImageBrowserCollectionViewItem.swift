//
//  GZImageBrowserCollectionViewItem.swift
//  Gazo
//
//  Created by Seth on 2016-06-20.
//

import Cocoa

/// A collection view item in the image browser collection view in a GZImageBrowserViewController
class GZImageBrowserCollectionViewItem: NSCollectionViewItem {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear();
        
        // Set the tooltip to the image's path
        self.view.toolTip = (self.representedObject as! GZImageBrowserCollectionViewObject).image?.path;
    }
    
    override func rightMouseDown(theEvent: NSEvent) {
        // If this item isnt selected...
        if(!self.selected) {
            // Deselect all the other items
            self.collectionView.deselectAll(self);
            
            // Select this item
            self.selected = true;
        }
        
        super.rightMouseDown(theEvent);
    }
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent);
        
        // If we double clicked...
        if(theEvent.clickCount == 2) {
            // Open this item's image
            open();
        }
    }
    
    /// Opens this item's image in a new GZImageViewerViewController
    func open() {
        /// The window controller for the new GZImageViewerViewController
        let newImageViewerWindowController : NSWindowController = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateControllerWithIdentifier("imageViewerWindowController") as! NSWindowController;
        
        // Display this item's image in newImageViewerWindowController's GZImageViewerViewController
        (newImageViewerWindowController.contentViewController as! GZImageViewerViewController).displayImage((self.representedObject as! GZImageBrowserCollectionViewObject).image!);
        
        // Display newImageViewerWindowController's window
        newImageViewerWindowController.showWindow(self);
    }
}
