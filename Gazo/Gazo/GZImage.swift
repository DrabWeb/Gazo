//
//  GZImage.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//

import Cocoa

/// The class for holding info about a users image, such as the path and metadata
class GZImage: NSObject {
    /// The path to this image
    var path : String = "";
    
    /// The image at path, only set when done manually or loadImage is called
    var image : NSImage? = nil;
    
    /// Returns image if it is already loaded, and if not calls loadImage first
    func getImage() -> NSImage {
        // If image is nil...
        if(image == nil) {
            // Load the image
            loadImage();
        }
        
        // Return the image
        return image!;
    }
    
    /// The thumbnail image for this image
    var thumbnailImage : NSImage? = nil;
    
    /// Grabs the thumbnail image for this image, and stores it in thumbnailImage. Also returns the image
    func getThumbnailImage() -> NSImage {
        // If thumbnailImage is nil...
        if(thumbnailImage == nil) {
            // Load the thumbnail image
            loadThumbnailImage();
        }
        
        // Return the thumbnail image
        return thumbnailImage!;
    }
    
    /// The tags for the source material of this image
    var sourceTags : [GZTag] = [];
    
    /// The tags for the characters in this image
    var characterTags : [GZTag] = [];
    
    /// The tags for the artist(s) of this image
    var artistTags : [GZTag] = [];
    
    /// Any other tags for this image that dont fit into a previous category
    var generalTags : [GZTag] = [];
    
    /// Loads this GZImage's image at path into image
    func loadImage() {
        // Load the image
        self.image = NSImage(contentsOfFile: path);
    }
    
    /// Loads this GZImage's thumbnail image into thumbnailImage
    func loadThumbnailImage() {
        // Load the thumbnail image
        /// The thumbnail image that will be grabbed based on path
        var createdThumbnailImage : NSImage = NSImage();
        
        // If this file is an image...
        if(NSFileManager.defaultManager().fileIsImage(self.path)) {
            // Get the thumbnail image
            createdThumbnailImage = NSImage(contentsOfFile: self.path)!;
        }
        // If this file isnt an image...
        else {
            // Set the thumbnail image to the file's icon
            createdThumbnailImage = NSWorkspace.sharedWorkspace().iconForFile(self.path);
        }
        
        // Set thumbnailImage
        self.thumbnailImage = createdThumbnailImage;
    }
    
    // Init with a path
    init(path : String) {
        super.init();
        
        self.path = path;
    }
    
    // Blank init
    override init() {
        super.init();
        
        path = "";
        sourceTags = [];
        characterTags = [];
        artistTags = [];
        generalTags = [];
    }
}
