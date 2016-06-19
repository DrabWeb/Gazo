//
//  GZImageViewerSidebarViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// The view controller for sidebar view in a GZImageViewerViewController
class GZImageViewerSidebarViewController: NSViewController {

    /// The visual effect view for the background of this sidebar
    @IBOutlet var backgroundVisualEffectView: NSVisualEffectView!
    
    /// The stack view that holds all the sidebar items for this sidebar view
    @IBOutlet var sidebarStackView: NSStackView!
    
    /// The scroll view for sidebarStackView
    @IBOutlet var sidebarStackViewScrollView: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the view
        styleView();
    }
    
    /// Styles this view
    func styleView() {
        // Style the visual effect views
        backgroundVisualEffectView.material = .Dark;
        
        // Set the sidebar stack view's appearance(For some reason it doesnt inherit the appearance)
        sidebarStackView.appearance = backgroundVisualEffectView.appearance;
    }
}
