//
//  GZImageViewerSplitViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class GZImageViewerSplitViewController: NSSplitViewController {

    /// The object to perform sidebarCollapseStateChangedAction
    var collapseStateChangedTarget : AnyObject? = nil;
    
    /// The selector to call when the collapsed state of the sidebar changes, passed this split view
    var collapseStateChangedAction : Selector = Selector("");
    
    override func splitViewDidResizeSubviews(notification: NSNotification) {
        // Call the sidebar collapse state changed action, with this split view
        collapseStateChangedTarget?.performSelector(collapseStateChangedAction, withObject: self);
    }
}
