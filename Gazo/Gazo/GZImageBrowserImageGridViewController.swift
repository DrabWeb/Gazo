//
//  GZImageBrowserImageGridViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-20.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// The view controller for the image grid in a GZImageBrowserViewController
class GZImageBrowserImageGridViewController: NSViewController {
    
    /// The collection view that shows the grid of images for browsing
    @IBOutlet var imageGridCollectionView: GZImageBrowserCollectionView!
    
    /// Returns the selected GZImageBrowserCollectionViewObjects in imageGridCollectionView
    var imageGridCollectionViewSelectedItems : [GZImageBrowserCollectionViewObject] {
        /// The selected items in imageGridCollectionView
        var selectedItems : [GZImageBrowserCollectionViewObject] = [];
        
        // For every selection index in imageGridCollectionView...
        for(_, currentSelectionIndex) in imageGridCollectionView.selectionIndexes.enumerate() {
            // Add the item at the given index to selectedItems
            selectedItems.append((imageGridCollectionViewArrayController.arrangedObjects as! [GZImageBrowserCollectionViewObject])[currentSelectionIndex])
        }
        
        // Return the selected items
        return selectedItems;
    }
    
    /// The scroll view for imageGridCollectionView
    @IBOutlet var imageGridCollectionViewScrollView: NSScrollView!
    
    /// The array controller for imageGridCollectionView
    @IBOutlet weak var imageGridCollectionViewArrayController: NSArrayController!
    
    /// The items in imageGridCollectionViewArrayController
    var imageGridCollectionViewViewArrayControllerObjects : NSMutableArray = NSMutableArray();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style this view
        styleView();
        
        // Set the image grid collection view's item prototype
        imageGridCollectionView.itemPrototype = storyboard?.instantiateControllerWithIdentifier("imageBrowserCollectionViewItem") as! GZImageBrowserCollectionViewItem;
        
        // Set the minimum and maximum item sizes
        imageGridCollectionView.minItemSize = NSSize(width: 150, height: 150);
        imageGridCollectionView.maxItemSize = NSSize(width: 250, height: 250);
        
        // Setup the image grid collection view right click actions
        imageGridCollectionView.setTagsForSelectedImagesTarget = self;
        imageGridCollectionView.setTagsForSelectedImagesAction = Selector("promptToSetTagsForSelectedImages");
        
        imageGridCollectionView.addTagsToSelectedImagesTarget = self;
        imageGridCollectionView.addTagsToSelectedImagesAction = Selector("promptToAddTagsToSelectedImages");
        
        // Prompt for a folder to display images from, for testing
        /// The open panel for getting the folder to display images from
        let imagesFolderOpenPanel : NSOpenPanel = NSOpenPanel();
        
        // Configure the open panel
        imagesFolderOpenPanel.allowsMultipleSelection = false;
        imagesFolderOpenPanel.canChooseFiles = false;
        imagesFolderOpenPanel.canChooseDirectories = true;
        
        /// If the user hits ok on the open panel...]
        if(Bool(imagesFolderOpenPanel.runModal())) {
            // Display the images from the selected folder in the image grid
            displayImagesFromFolder(imagesFolderOpenPanel.URL!.absoluteString.stringByRemovingPercentEncoding!.stringByReplacingOccurrencesOfString("file://", withString: ""), deepSearch: false);
        }
    }
    
    /// Displays the images from the given folder in this image grid. If deepSearch is true it uses a file enumerator and goes into subfolders
    func displayImagesFromFolder(folderPath : String, deepSearch : Bool) {
        // Clear out all the current items in the image grid
        imageGridCollectionViewArrayController.removeAll();
        
        /// The list of files that we will load into the image grid
        var fileList : [String] = [];
        
        // If we didnt say to do a deep search...
        if(!deepSearch) {
            do {
                // For every file in the given folder path...
                for(_, currentFile) in try NSFileManager.defaultManager().contentsOfDirectoryAtPath(folderPath).enumerate() {
                    // If the current file isnt a hidden system file(prepended with a .)...
                    if(!currentFile.hasPrefix(".")) {
                        // If the current file's extension is supported...
                        if(GZValues.fileIsSupported(folderPath + currentFile)) {
                            // Add the current file to fileList
                            fileList.append(folderPath + currentFile);
                        }
                    }
                }
            }
            catch let error as NSError {
                // Print the error
                print("GZImageBrowserImageGridViewController: Error getting files in folder \"\(folderPath)\", \(error.description)");
            }
        }
        // If we said to do a deep search...
        else {
            /// The file enumerator for the given folder path
            let folderEnumerator : NSDirectoryEnumerator? = NSFileManager.defaultManager().enumeratorAtPath(folderPath);
            
            // If the folder enumerator isnt nil...
            if(folderEnumerator != nil) {
                // For every file in the given folder path and it's subfolders...
                for(_, currentFile) in folderEnumerator!.enumerate() {
                    // If the current file isnt a hidden system file(prepended with a .)...
                    if(!(currentFile as! String).hasPrefix(".")) {
                        // If the current file's extension is supported...
                        if(GZValues.fileIsSupported(folderPath + (currentFile as! String))) {
                            // Add the current file to fileList
                            fileList.append(folderPath + (currentFile as! String));
                        }
                    }
                }
            }
            // If the folder enumerator is nil...
            else {
                // Say that there was an error creating the folder enumerator
                print("GZImageBrowserImageGridViewController: Error creating directory enumerator for folder \"\(folderPath)\"");
            }
        }
        
        // Sort fileList by modification date
        fileList = fileList.sortedByModificationDate();
        
        // For every file in fileList...
        for(_, currentFile) in fileList.enumerate() {
            // Add the current file to the image grid
            /// The GZImageBrowserCollectionViewObject for the new image grid item
            let newImageGridObject : GZImageBrowserCollectionViewObject = GZImageBrowserCollectionViewObject();
            
            // Set the thumbnail image
            newImageGridObject.thumbnailImage = NSImage(contentsOfFile: currentFile);
            
            // Set the image
            newImageGridObject.image = GZImage();
            newImageGridObject.image!.image = newImageGridObject.thumbnailImage;
            
            // Add the item to the image grid
            imageGridCollectionViewArrayController.addObject(newImageGridObject);
        }
        
        // Scroll to the top of imageGridCollectionViewScrollView
        imageGridCollectionViewScrollView.scrollToTop();
    }
    
    /// Called when the user right clicks image(s) and selects "Set Tags For Selected Image(s)" in the image grid
    func promptToSetTagsForSelectedImages() {
        
    }
    
    /// Called when the user right clicks image(s) and selects "Add Tags To Selected Image(s)" in the image grid
    func promptToAddTagsToSelectedImages() {
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear();
        
        // Set the background color
        self.view.layer?.backgroundColor = GZValues.imageBrowserImageGridBackgroundColor.CGColor;
    }
    
    /// Styles this view
    func styleView() {
        
    }
}