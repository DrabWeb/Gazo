//
//  GZPreferences.swift
//  Gazo
//
//  Created by Seth on 2016-06-21.
//

import Cocoa

/// Holds the user preferences for Gazo
class GZPreferences: NSObject {
    /// The folders to scan for pictures
    var pictureFolders : [String] = [NSHomeDirectory() + "/Pictures/"];
    
    /// Should an image viewer window resize itself to fit it's image when the sidebar is toggled?
    var resizeImageViewerWindowWhenSidebarToggled : Bool = true;
    
    /// Returns the global preferences object for Gazo
    static func defaultPreferences() -> GZPreferences {
        // Return realDefaultPreferences
        return self.realDefaultPreferences;
    }
    
    /// The default preferences object
    private static var realDefaultPreferences : GZPreferences = GZPreferences();
}
