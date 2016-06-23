//
//  GZValues.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//

import Cocoa

/// Constant values used through out the application, such as display strings, colors and more
class GZValues {
    /// The folders and files ignored by Gazo
    static let ignoredFiles : [String] = [NSHomeDirectory() + "/Pictures/Photo Booth Library", NSHomeDirectory() + "/Pictures/Photos Library.photoslibrary"];
    
    /// Should the given folder or file be ignored by Gazo?
    static func fileShouldBeIgnored(filePath : String) -> Bool {
        // For every ignored file/folder in ignoredFiles...
        for(_, currentIgnoredFile) in ignoredFiles.enumerate() {
            // If the given file path is an ignored file or is in an ignored folder...
            if(filePath.hasPrefix(currentIgnoredFile)) {
                // Say to ignore this file/folder
                return true;
            }
        }
        
        // Say not to ignore this file/folder
        return false;
    }
    
    /// The file UTI types supported for viewing by Gazo
    static let supportedFileUtiTypes : [String] = ["public.png", "public.jpeg", "com.compuserve.gif"];
    
    /// Returns if the file at the given path is suppoorted for viewing by Gazo
    static func fileIsSupported(filePath : String) -> Bool {
        do {
            // Return if the supported file UTI types contains the given file's UTI type
            return supportedFileUtiTypes.contains(try NSWorkspace.sharedWorkspace().typeOfFile(filePath));
        }
        catch {
            // Do nothing, dont need to see errors here
        }
        
        // Return false, there was an error getting the file
        return false;
    }
    
    /// The color for the background of a GZImageViewerViewController's GZImageViewerImageViewController
    static let imageViewerViewControllerImageViewBackgroundColor : NSColor = NSColor(calibratedWhite: 0.1, alpha: 1);
    
    /// The duration for fade animations based on mouse activity
    static let mouseActivityFadeDuration : CGFloat = 0.1;
    
    /// The color for the background of a GZImageBrowserImageGridViewController
    static let imageBrowserImageGridBackgroundColor : NSColor = NSColor(calibratedWhite: 0.1, alpha: 1);
    
    /// Returns the label for a GZTagEditorViewController's editingLabel, says how many are being edited and in what mode
    static func tagEditorEditingLabel(mode : GZTagEditorMode, amountEditing : Int) -> String {
        /// The string for referring to the images. Sets to "Image" if there is only one editing image
        var imagesString : String = "Images";
        
        // If there is only one editing image...
        if(amountEditing == 1) {
            // Set imagesString to "Image"
            imagesString = "Image";
        }
        
        // If the mode is add...
        if(mode == .Add) {
            // Return the label
            return "Add Tags To \(amountEditing) \(imagesString)";
        }
        // If the mode is set...
        else if(mode == .Set) {
            // Return the label
            return "Set Tags For \(amountEditing) \(imagesString)";
        }
        
        // Return an error message if the mode was something else
        return "GZValues: Error getting tag editor editing label";
    }
}
