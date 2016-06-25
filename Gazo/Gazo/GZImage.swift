//
//  GZImage.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//

import Cocoa
import AVFoundation
import AVKit

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
    
    /// The AVAsset at path, only applies when this item is a video. Set by loadPlayerAsset
    var playerAsset : AVAsset? = nil;
    
    /// Grabs the AVAsset for this image, and stores it in playerAsset. Also returns the asset that was loaded
    func getPlayerAsset() -> AVAsset {
        // If playerAsset is nil...
        if(playerAsset == nil) {
            // Load playerAsset
            loadPlayerAsset();
        }
        
        // Return playerAsset
        return playerAsset!;
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
    
    /// Returns the pixel size of this GZImage
    var size : NSSize {
        // If this item is an image...
        if(NSFileManager.defaultManager().fileIsImage(self.path)) {
            // Return the size of the image
            return self.getImage().pixelSize;
        }
        // If this item is a video...
        else if(NSFileManager.defaultManager().fileIsVideo(self.path)) {
            // Return the size of the video
            return self.getPlayerAsset().tracks[0].naturalSize;
        }
        
        // Default to zero size
        return NSSize.zero;
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
    
    /// Loads this GZImage's video at path into playerAsset
    func loadPlayerAsset() {
        // Load playerAsset
        playerAsset = AVAsset(URL: NSURL(fileURLWithPath: self.path));
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
            // If this file is a video...
        else if(NSFileManager.defaultManager().fileIsVideo(self.path)) {
            // Get the thumbnail image
            /// The AVAssetImageGenerator for getting the thumbnail image from playerAsset
            let thumbnailImageGenerator : AVAssetImageGenerator = AVAssetImageGenerator(asset: getPlayerAsset());
            
            /// The time to grab the thumbnail at
            let thumbnailGrabTime : CMTime = CMTime(value: 1, timescale: 60);
            
            do {
                /// The CGImage for the thumbnail image from thumbnailImageGenerator at thumbnailGrabTime
                let thumbnailImageRef : CGImageRef = try thumbnailImageGenerator.copyCGImageAtTime(thumbnailGrabTime, actualTime: nil);
                
                // Set thumbnailImage to an NSImage from thumbnailImageRef
                createdThumbnailImage = NSImage(CGImage: thumbnailImageRef, size: getPlayerAsset().tracks[0].naturalSize);
            }
            catch let error as NSError {
                // Print the error to the log
                print("GZImage: Error grabbing thumbnail for video from \"\(self.path)\", \(error.description)");
            }
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
