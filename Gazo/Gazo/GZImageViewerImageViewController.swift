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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the view
        styleView();
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
