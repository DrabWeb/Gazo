//
//  GZImageBrowserCollectionViewObject.swift
//  Gazo
//
//  Created by Seth on 2016-06-20.
//

import Cocoa

/// The object for an item in the image browser collection view in a GZImageBrowserViewController
class GZImageBrowserCollectionViewObject: NSObject {
    /// The GZImage this object represents
    var image : GZImage? = nil;
    
    /// The image that is displayed for the image grid item this object is binded to
    var thumbnailImage : NSImage? = nil;
}
