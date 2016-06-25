//
//  GZImageViewerImageViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//

import Cocoa
import AVKit
import AVFoundation

/// The view controller for the image view in a GZImageViewerViewController
class GZImageViewerImageViewController: NSViewController {

    /// The image view for displaying images in this view
    @IBOutlet var imageView: NSImageView!
    
    /// The player view for video files that can be opened internally
    @IBOutlet var playerView: AVPlayerView!
    
    /// The GZImage that is currently being displayed in this view
    var currentDisplayingImage : GZImage? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the view
        styleView();
    }
    
    override func viewWillDisappear() {
        super.viewDidDisappear();
        
        // Pause the player view, if its playing
        playerView.player?.pause();
    }
    
    /// Displays the given GZImage in this view
    func displayImage(image : GZImage) {
        // Set currentDisplayingImage
        currentDisplayingImage = image;
        
        // If the given GZImage's file is an image...
        if(NSFileManager.defaultManager().fileIsImage(image.path)) {
            // Display the image
            self.imageView.image = currentDisplayingImage!.getImage();
            
            // Hide the player view
            playerView.hidden = true;
        }
        // If the given GZImage's file is a video...
        else if(NSFileManager.defaultManager().fileIsVideo(image.path)) {
            // Hide the image view
            imageView.hidden = true;
            
            // Show the player view
            playerView.hidden = false;
            
            /// The AVPlayerItem for playerView to play
            let playerItem : AVPlayerItem = AVPlayerItem(URL: NSURL(fileURLWithPath: image.path));
            
            /// The AVPlayer for playerItem that will be displayed by playerView
            let player : AVPlayer = AVPlayer(playerItem: playerItem);
            
            /// Set the player view's player
            playerView.player = player;
            
            // If the user said to autoplay videos...
            if(GZPreferences.defaultPreferences().autoplayVideos) {
                // Play the video
                player.play();
            }
        }
        
        // Make this view's window frontmost
        self.view.window?.makeFirstResponder(nil);
    }
    
    /// Styles this view
    func styleView() {
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear();
        
        // Set the background color
        self.view.layer?.backgroundColor = GZConstants.imageViewerViewControllerImageViewBackgroundColor.CGColor;
    }
}
