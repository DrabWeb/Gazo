//
//  GZImageBrowserSidebarViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-20.
//

import Cocoa

/// The view controller for the sidebar in a GZImageBrowserViewController
class GZImageBrowserSidebarViewController: NSViewController {
    
    /// The visual effect view for the background of this sidebar
    @IBOutlet var backgroundVisualEffectView: NSVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style this view
        styleView();
    }
    
    /// Styles this view
    func styleView() {
        // Style the visual effect views
        backgroundVisualEffectView.material = .Dark;
    }
}