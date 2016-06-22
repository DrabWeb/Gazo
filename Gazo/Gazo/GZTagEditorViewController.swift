//
//  GZTagEditorViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-22.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// The view controller for the tag editor view that lets you prompt to edit/add tags to single or multiple images. Usually used in a sheet layout, and completely separate from GZImageViewerSidebarViewController's tag editor
class GZTagEditorViewController: NSViewController {
    
    /// The visual effect view for the background of this view
    @IBOutlet var backgroundVisualEffectView: NSVisualEffectView!
    
    /// The label for telling the user what edit mode we are in and how many images will be affected
    @IBOutlet var editingLabel: NSTextField!
    
    /// The scroll view for tagFieldsStackView
    @IBOutlet var tagFieldsStackViewScrollView: NSScrollView!
    
    /// The stack vie that holds all the tag fields
    @IBOutlet var tagFieldsStackView: NSStackView!
    
    /// The token field in the tag fields stack view for tags about the source material of this image
    @IBOutlet var tagFieldsStackViewSourceTagsTokenField: GZTagsTokenField!
    
    /// The token field in the tag fields stack view for tags about the characters in this mage
    @IBOutlet var tagFieldsStackViewCharacterTagsTokenField: GZTagsTokenField!
    
    /// The token field in the tag fields stack view for tags about the artist(s) of this image
    @IBOutlet var tagFieldsStackViewArtistsTagsTokenField: GZTagsTokenField!
    
    /// The token field in the tag fields stack view for tags on this image that dont fit into another category
    @IBOutlet var tagFieldsStackViewGeneralTagsTokenField: GZTagsTokenField!
    
    /// When the user presses the cancel button...
    @IBAction func cancelButtonPressed(sender: NSButton) {
        // Dismiss this view controller
        self.dismissController(self);
    }
    
    /// When the user presses the apply button...
    @IBAction func applyButtonPressed(sender: NSButton) {
        // Apply the entered info and dismiss the view
        apply();
    }
    
    /// The tag editing mode this tag editor is currently in. Defaults to add
    var mode : GZTagEditorMode = .Add;
    
    /// The current images this tag editor is editing
    var currentEditingImages : [GZImage] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style this view
        styleView();
    }
    
    override func viewDidAppear() {
        super.viewDidAppear();
        
        // Fix a wierd graphical issue that happens with tagFieldsStackViewScrollView when this is presented as a sheet
        self.view.window?.makeFirstResponder(tagFieldsStackViewCharacterTagsTokenField);
        self.view.window?.makeFirstResponder(tagFieldsStackViewSourceTagsTokenField);
    }
    
    /// Sets this tag editor to edit the given images with the given mode
    func editImages(images : [GZImage], mode : GZTagEditorMode) {
        // Set mode to the given tag editing mode
        self.mode = mode;
        
        // Set currentEditingImages
        currentEditingImages = images;
        
        // Set editingLabel's string value
        editingLabel.stringValue = GZValues.tagEditorEditingLabel(mode, amountEditing: currentEditingImages.count);
    }
    
    /// Applies the current entered info the the editing images and dismisses this view controller
    func apply() {
        // If we are adding tags...
        if(mode == .Add) {
            // For every editing image...
            for(_, currentEditingImage) in currentEditingImages.enumerate() {
                // Add all the entered tags to the current image
                currentEditingImage.sourceTags.appendContentsOf(tagFieldsStackViewSourceTagsTokenField.tags);
                currentEditingImage.characterTags.appendContentsOf(tagFieldsStackViewCharacterTagsTokenField.tags);
                currentEditingImage.artistTags.appendContentsOf(tagFieldsStackViewArtistsTagsTokenField.tags);
                currentEditingImage.generalTags.appendContentsOf(tagFieldsStackViewGeneralTagsTokenField.tags);
            }
        }
        // If we are setting tags...
        else if(mode == .Set) {
            // For every editing image...
            for(_, currentEditingImage) in currentEditingImages.enumerate() {
                // Set all the tags for the current image to the entered tags
                currentEditingImage.sourceTags = tagFieldsStackViewSourceTagsTokenField.tags;
                currentEditingImage.characterTags = tagFieldsStackViewCharacterTagsTokenField.tags;
                currentEditingImage.artistTags = tagFieldsStackViewArtistsTagsTokenField.tags;
                currentEditingImage.generalTags = tagFieldsStackViewGeneralTagsTokenField.tags;
            }
        }
        
        // Dismiss this view controller
        self.dismissController(self);
    }
    
    /// Styles this view
    func styleView() {
        // Style the visual effect views
        backgroundVisualEffectView.material = .Dark;
    }
}

/// The different modes GZTagEditorViewController can do
enum GZTagEditorMode {
    /// Adds tags to the editing image(s)
    case Add
    
    /// Sets the tags for the editing image(s)
    case Set
}