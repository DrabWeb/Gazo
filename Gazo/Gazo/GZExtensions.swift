//
//  GZExtensions.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//

import Cocoa

extension NSWindow {
    /// Returns the titlebar view for this window
    var titlebarView : NSView {
        return self.standardWindowButton(.CloseButton)!.superview!.superview!;
    }
    
    /// Is the window fullscreen?
    var fullscreen : Bool {
        // Return true/false depending on if the windows style mask contains NSFullScreenWindowMask
        return ((self.styleMask & NSFullScreenWindowMask) > 0);
    }
    
    /// Is the cursor hovering this window?
    var cursorIn : Bool {
        // Is the cursor in this window?
        var cursorIn : Bool = false;
        
        /// The CGEventRef for getting the cursor's location
        let mouseEvent : CGEventRef = CGEventCreate(nil)!;
        
        /// The location of the cursor
        var mousePosition : CGPoint = CGEventGetLocation(mouseEvent);
        
        // Invert the Y position so its in the same coordinate system as the window
        mousePosition = CGPoint(x: mousePosition.x, y: abs(mousePosition.y - NSScreen.mainScreen()!.frame.height));
        
        // If the mouse is within this window on the X...
        if(mousePosition.x > self.frame.origin.x && mousePosition.x < (self.frame.origin.x + self.frame.size.width)) {
            // If the mouse is within this window on the Y...
            if(mousePosition.y > self.frame.origin.y && mousePosition.y < (self.frame.origin.y + self.frame.size.height)) {
                // Set cursorIn to true
                cursorIn = true;
            }
        }
        
        // Return if the cursor is in this window
        return cursorIn;
    }
}

extension NSImage {
    /// The pixel size of this image
    var pixelSize : NSSize {
        /// The NSBitmapImageRep to the image
        let imageRep : NSBitmapImageRep = (NSBitmapImageRep(data: self.TIFFRepresentation!))!;
        
        /// The size of the iamge
        let imageSize : NSSize = NSSize(width: imageRep.pixelsWide, height: imageRep.pixelsHigh);
        
        // Return the image size
        return imageSize;
    }
}

extension NSArrayController {
    /// Removes all the objects from this array controller
    func removeAll() {
        // Remove all the objects in this array controller
        self.removeObjects(self.arrangedObjects as! [AnyObject]);
    }
}

extension String {
    /// This string as an NSString
    var ToNSString : NSString {
        /// Return this string as an NSString
        return NSString(string: self);
    }
}

extension SequenceType {
    /// Returns this array(assuming its an array of file paths) sorted by modification date
    func sortedByModificationDate() -> [String] {
        /// This array, sorted by modification date
        var sortedArray : [String] = self as! [String];
        
        // Sort the array
        sortedArray = sortedArray.sort({ (fileOne, fileTwo) in
            do {
                /// The modification date of fileOne
                let fileOneModificationDate : NSDate? = try NSFileManager.defaultManager().attributesOfItemAtPath(fileOne)["NSFileModificationDate"] as? NSDate;
                
                /// The modification date of fileTwo
                let fileTwoModificationDate : NSDate? = try NSFileManager.defaultManager().attributesOfItemAtPath(fileTwo)["NSFileModificationDate"] as? NSDate;
                
                // If file one's modification date is earlier than file two's modification date...
                if(fileOneModificationDate!.timeIntervalSince1970 < fileTwoModificationDate!.timeIntervalSince1970) {
                    // Say to sort descending
                    return false;
                }
                // If file one's modification date is later than file two's modification date...
                else {
                    // Say to sort ascending
                    return true;
                }
            }
            catch {
                // Do nothing with errors
            }
            
            // Default to descending in case there is an error
            return false;
        });
        
        // Return the sorted array
        return sortedArray;
    }
}

extension NSTokenField {
    /// All the tokens that are currently entered in this token field
    var tokens : [String] {
        // Return the tokens
        if(self.tokenStyle == .None) {
            return self.stringValue.componentsSeparatedByString(" ");
        }
        else {
            return self.stringValue.componentsSeparatedByString(",");
        }
    }
}

extension NSScrollView {
    /// Scrolls to the top of this scroll view
    func scrollToTop() {
        // Scroll to the top(doesnt go up to the content insets)
        self.verticalScroller?.floatValue = Float((self.documentView?.bounds.height)!);
        
        // Page up so it goes up to the content inset
        self.pageUp(self);
    }
}

extension NSFileManager {
    /// Is the given file a folder?
    func isFolder(path : String) -> Bool {
        // If the given file exists...
        if(NSFileManager.defaultManager().fileExistsAtPath(path)) {
            // Return if the file at the given path's contents are nil
            return NSFileManager.defaultManager().contentsAtPath(path) == nil;
        }
        // If the given file doesnt exist...
        else {
            // Say its not a folder
            return false;
        }
    }
    
    /// Return the number of supported files in a folder
    func numberOfSupportedFilesInFolder(folderPath : String) -> Int {
        // Return the count of items returned from supportedFilesInFolder
        return supportedFilesInFolder(folderPath).count;
    }
    
    /// Returns the list of files in a given folder that are supported by Gazo
    func supportedFilesInFolder(folderPath : String) -> [String] {
        /// The supported files in the given folder
        var supportedFiles : [String] = [];
        
        // If the given folder exists...
        if(NSFileManager.defaultManager().fileExistsAtPath(folderPath)) {
            do {
                // For every file in the given folder...
                for(_, currentFile) in try NSFileManager.defaultManager().contentsOfDirectoryAtPath(folderPath).enumerate() {
                    // If the current file is supported...
                    if(GZValues.fileIsSupported(folderPath + "/" + currentFile)) {
                        // Add the current file to supportedFiles
                        supportedFiles.append(folderPath + "/" + currentFile);
                    }
                }
            }
            catch let error as NSError {
                // Print the error to the log
                print("NSFileManager Extension: Failed to get the folder contents from \"\(folderPath)\", \(error.description)");
            }
        }
        
        // Return supportedFiles
        return supportedFiles;
    }
}