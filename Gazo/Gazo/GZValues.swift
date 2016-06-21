//
//  GZValues.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// Constant values used through out the application, such as display strings, colors and more
class GZValues {
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
}
