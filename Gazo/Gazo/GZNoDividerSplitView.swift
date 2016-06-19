//
//  GZNoDividerSplitView.swift
//  Gazo
//
//  Created by Seth on 2016-06-19.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class GZNoDividerSplitView: NSSplitView {

    // Override the divider thickness to be 0, so there is no divider
    override var dividerThickness : CGFloat {
        return 0;
    }
}
