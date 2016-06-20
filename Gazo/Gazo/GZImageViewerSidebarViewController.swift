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
    
    /// The visual effect view for the top of the sidebar that goes where the titlebar would be
    @IBOutlet var titlebarVisualEffectView: NSVisualEffectView!
    
    /// The height constraint for titlebarVisualEffectView
    @IBOutlet var titlebarVisualEffectViewHeightConstraint: NSLayoutConstraint!
    
    /// The visual effect view for the bottom bar of this sidebar
    @IBOutlet var bottomBarVisualEffectView: NSVisualEffectView!
    
    /// The stack view that holds all the sidebar items for this sidebar view
    @IBOutlet var sidebarStackView: NSStackView!
    
    /// The scroll view for sidebarStackView
    @IBOutlet var sidebarStackViewScrollView: NSScrollView!
    
    /// The token field in the sidebar stack view for tags about the source material of this image
    @IBOutlet var sidebarStackViewSourceTagsTokenField: GZTagsTokenField!
    
    /// The token field in the sidebar stack view for tags about the characters in this mage
    @IBOutlet var sidebarStackViewCharacterTagsTokenField: GZTagsTokenField!
    
    /// The token field in the sidebar stack view for tags about the artist(s) of this image
    @IBOutlet var sidebarStackViewArtistsTagsTokenField: GZTagsTokenField!

    /// The token field in the sidebar stack view for tags on this image that dont fit into another category
    @IBOutlet var sidebarStackViewGeneralTagsTokenField: GZTagsTokenField!
    
    /// The stack view that holds the buttons in the bottom bar
    @IBOutlet var bottomBarButtonsStackView: NSStackView!
    
    /// When the user presses the sauce button in the bottom bar...
    @IBAction func bottomBarSauceButtonPressed(sender: NSButton) {
        
    }
    
    /// When the user presses the share button in the bottom bar...
    @IBAction func bottomBarShareButtonPressed(sender: NSButton) {
        
    }
    
    /// The GZImage that is currently being displayed in this view
    var currentDisplayingImage : GZImage? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the view
        styleView();
    }
    
    /// Displays the given GZImage's info in this sidebar
    func displayImage(image : GZImage) {
        // Set currentDisplayingImage
        currentDisplayingImage = image;
        
        // Display the image's info
        // Display the tags
        sidebarStackViewSourceTagsTokenField.stringValue = "";
        sidebarStackViewSourceTagsTokenField.addTagsFromArray(image.sourceTags);
        
        sidebarStackViewCharacterTagsTokenField.stringValue = "";
        sidebarStackViewCharacterTagsTokenField.addTagsFromArray(image.characterTags);
        
        sidebarStackViewArtistsTagsTokenField.stringValue = "";
        sidebarStackViewArtistsTagsTokenField.addTagsFromArray(image.artistTags);
        
        sidebarStackViewGeneralTagsTokenField.stringValue = "";
        sidebarStackViewGeneralTagsTokenField.addTagsFromArray(image.generalTags);
        
        // Scroll to the top of sidebarStackViewScrollView
        sidebarStackViewScrollView.verticalScroller!.floatValue = Float(sidebarStackViewScrollView.contentView.bounds.height);
    }
    
    /// Shows titlebarVisualEffectView
    func showTitlebarVisualEffectView() {
        // Update titlebarVisualEffectView's height constraint
        titlebarVisualEffectViewHeightConstraint.constant = 22;
    }
    
    /// Hides titlebarVisualEffectView
    func hideTitlebarVisualEffectView() {
        // Update titlebarVisualEffectView's height constraint
        titlebarVisualEffectViewHeightConstraint.constant = 0;
    }
    
    /// Styles this view
    func styleView() {
        // Style the visual effect views
        backgroundVisualEffectView.material = .Dark;
        bottomBarVisualEffectView.material = .Titlebar;
        
        // Set all the stack views' appearances(For some reason it doesnt inherit the appearance)
        sidebarStackView.appearance = backgroundVisualEffectView.appearance;
        bottomBarButtonsStackView.appearance = backgroundVisualEffectView.appearance;
        
        // Re-add all the buttons in bottomBarButtonsStackView so they are centered
        for(_, currentSubview) in bottomBarButtonsStackView.subviews.enumerate() {
            bottomBarButtonsStackView.addView(currentSubview, inGravity: .Center);
        }
    }
}
