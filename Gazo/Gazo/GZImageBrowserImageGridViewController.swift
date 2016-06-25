//
//  GZImageBrowserImageGridViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-20.
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
    
    /// Returns all the selected GZImages in imageGridCollectionView
    var imageGridCollectionViewSelectedImages : [GZImage] {
        /// The selected images
        var selectedImages : [GZImage] = [];
        
        // For every item in imageGridCollectionViewSelectedItems...
        for(_, currentItem) in imageGridCollectionViewSelectedItems.enumerate() {
            // Add the current item's image to selectedImages
            selectedImages.append(currentItem.image!);
        }
        
        // Return selected images
        return selectedImages;
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
        imageGridCollectionView.openTarget = self;
        imageGridCollectionView.openAction = Selector("openSelectedImages");
        
        imageGridCollectionView.setTagsForSelectedImagesTarget = self;
        imageGridCollectionView.setTagsForSelectedImagesAction = Selector("promptToSetTagsForSelectedImages");
        
        imageGridCollectionView.addTagsToSelectedImagesTarget = self;
        imageGridCollectionView.addTagsToSelectedImagesAction = Selector("promptToAddTagsToSelectedImages");
    }
    
    /// Displays the images from the given folder in this image grid. If deepSearch is true it uses a file enumerator and goes into subfolders. folderPath should have a trailing slash
    func displayImagesFromFolder(folderPath : String, deepSearch : Bool) {
        // A simple hack to fix a bug where if this function is called before the view loads, than imageGridCollectionViewScrollView would be nil
        let _ = self.view;
        
        // Print what folder we are displaying files from
        if(deepSearch) {
            print("GZImageBrowserImageGridViewController: Displaying images from \"\(folderPath)\", and using a deep search");
        }
        else {
            print("GZImageBrowserImageGridViewController: Displaying images from \"\(folderPath)\"");
        }
        
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
                        if(GZConstants.fileIsSupported(folderPath + currentFile)) {
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
                        if(GZConstants.fileIsSupported(folderPath + (currentFile as! String))) {
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
            
            // Set the image
            newImageGridObject.image = GZImage();
            
            // Set the image path
            newImageGridObject.image!.path = currentFile;
            
            // Get the thumbnail image, and set the display thumbnail image
            newImageGridObject.thumbnailImage = newImageGridObject.image!.getThumbnailImage();
            
            // Add the item to the image grid
            imageGridCollectionViewArrayController.addObject(newImageGridObject);
        }
        
        // Scroll to the top of imageGridCollectionViewScrollView
        imageGridCollectionViewScrollView.scrollToTop();
    }
    
    /// Opens all the selected GZImages in the image grid
    func openSelectedImages() {
        // For every selection index...
        for(_, currentSelectionIndex) in imageGridCollectionView.selectionIndexes.enumerate() {
            // Tell the current GZImageBrowserCollectionViewItem to open
            (imageGridCollectionView.itemAtIndex(currentSelectionIndex) as! GZImageBrowserCollectionViewItem).open();
        }
    }
    
    /// Called when the user right clicks image(s) and selects "Set Tags For Selected Image(s)" in the image grid
    func promptToSetTagsForSelectedImages() {
        // Show the tag editor
        showTagEditorForSelectedImages(.Set);
    }
    
    /// Called when the user right clicks image(s) and selects "Add Tags To Selected Image(s)" in the image grid
    func promptToAddTagsToSelectedImages() {
        // Show the tag editor
        showTagEditorForSelectedImages(.Add);
    }
    
    /// Shows a GZTagEditorViewController as a sheet editing the current selected images in the given mode
    func showTagEditorForSelectedImages(mode : GZTagEditorMode) {
        // If we have any images selected in the image grid...
        if(imageGridCollectionView.selectionIndexes.count > 0) {
            /// The new tag editor view controller for editing the selected images
            let newTagEditorViewController : GZTagEditorViewController = storyboard!.instantiateControllerWithIdentifier("tagEditorViewController") as! GZTagEditorViewController;
            
            // Load newTagEditorViewController
            newTagEditorViewController.loadView();
            
            // Tell the tag editor to edit the selected images with the given mode
            newTagEditorViewController.editImages(imageGridCollectionViewSelectedImages, mode: mode);
            
            // Present the view controller as a sheet
            self.presentViewControllerAsSheet(newTagEditorViewController);
        }
        // If we dont have any images selected in the image grid...
        else {
            // Print that we cant edit nothing
            print("GZImageBrowserImageGridViewController: Cant open tag editor for selected images when there are none selected");
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear();
        
        // Set the background color
        self.view.layer?.backgroundColor = GZConstants.imageBrowserImageGridBackgroundColor.CGColor;
    }
    
    /// Styles this view
    func styleView() {
        
    }
}