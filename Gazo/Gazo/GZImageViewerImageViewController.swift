//
//  GZImageViewerImageViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// The view controller for the image view in a GZImageViewerViewController
class GZImageViewerImageViewController: NSViewController {

    /// The image view for displaying images in this view
    @IBOutlet var imageView: NSImageView!
    
    /// The GZImage that is currently being displayed in this view
    var currentDisplayingImage : GZImage? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the view
        styleView();
    }
    
    /// Displays the given GZImage in this view
    func displayImage(image : GZImage) {
        // Set currentDisplayingImage
        currentDisplayingImage = image;
        
        // Display the image
        self.imageView.image = currentDisplayingImage!.getImage();
    }
    
    /// Styles this view
    func styleView() {
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear();
        
        // Set the background color
        self.view.layer?.backgroundColor = GZValues.imageViewerViewControllerImageViewBackgroundColor.CGColor;
    }
}
