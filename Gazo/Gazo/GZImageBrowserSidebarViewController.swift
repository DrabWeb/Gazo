//
//  GZImageBrowserSidebarViewController.swift
//  Gazo
//
//  Created by Seth on 2016-06-20.
//  This implementation of sections in NSTableViews Copyright (c) 2015 Marcin Krzyzanowski. All rights reserved.
//  https://github.com/krzyzanowskim/NSTableView-Sections
//

import Cocoa

/// The view controller for the sidebar in a GZImageBrowserViewController
class GZImageBrowserSidebarViewController: NSViewController {
    
    /// The visual effect view for the background of this sidebar
    @IBOutlet var backgroundVisualEffectView: NSVisualEffectView!
    
    /// The table view that shows the sidebar items
    @IBOutlet var sidebarTableView: NSTableView!
    
    /// The scroll view for sidebarTableView
    @IBOutlet var sidebarTableViewScrollView: NSScrollView!
    
    /// The folders in the sidebar
    var folderSidebarItems : [GZImageBrowserSidebarItemData] = [];
    
    /// The albums in the sidebar
    var albumSidebarItems : [GZImageBrowserSidebarItemData] = [];
    
    /// The groups in the sidebar
    var groupSidebarItems : [GZImageBrowserSidebarItemData] = [];
    
    /// The object to perform sidebarSelectionChangedAction
    var sidebarSelectionChangedTarget : AnyObject? = nil;
    
    /// The selector to call when the selection changes in sidebarTableView
    var sidebarSelectionChangedAction : Selector = Selector("");
    
    /// The currently selected GZImageBrowserSidebarItemData in sidebarTableView
    var sidebarTableViewSelectedItem : GZImageBrowserSidebarItemData {
        // If the selected row is -1...
        if(sidebarTableView.selectedRow == -1) {
            // Set the selected row to 1(If this is called on load, sometimes it still has the "Folders" header selected, and results in giving back an NSString, crashing the application)
            sidebarTableView.selectRowIndexes(NSIndexSet(index: 1), byExtendingSelection: false);
        }
        
        // Return the selected item as a GZImageBrowserSidebarItemData
        return ((sidebarTableView.dataSource()!.tableView!(sidebarTableView, objectValueForTableColumn: nil, row: sidebarTableView.selectedRow)) as! GZImageBrowserSidebarItemData);
    }
    
    /// A private bool to make sure that a initial sidebarTableViewSelectionChanged is called
    private var calledInitialSidebarSelectionChanged : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style this view
        styleView();
        
        // Load the sidebar
        updateSidebar();
        
        // If we didnt make the initial sidebarTableViewSelectionChanged call...
        if(!calledInitialSidebarSelectionChanged) {
            // Call sidebarTableViewSelectionChanged
            sidebarTableViewSelectionChanged(sidebarTableViewSelectedItem);
            
            // Say we made the initial call
            calledInitialSidebarSelectionChanged = true;
        }
    }
    
    /// Updates the sidebar to reflect the current values
    func updateSidebar() {
        // Clear out all the current values
        folderSidebarItems.removeAll();
        albumSidebarItems.removeAll();
        groupSidebarItems.removeAll();
        
        // Get the folder items
        // For every picture folder the user added...
        for(_, currentPictureFolder) in GZPreferences.defaultPreferences().pictureFolders.enumerate() {
            /// The NSDirectoryEnumerator for currentPictureFolder
            let currentPictureFolderEnumerator : NSDirectoryEnumerator = NSFileManager.defaultManager().enumeratorAtPath(currentPictureFolder)!;
            
            // For every file in testFolderPath...
            for(_, currentFile) in currentPictureFolderEnumerator.enumerate() {
                /// The full path to the current file
                let currentFilePath : String = currentPictureFolder + (currentFile as! String);
                
                /// The name of currentFilePath
                let currentFileName : String = currentFilePath.ToNSString.lastPathComponent;
                
                // If the current file's extension is empty(This is a primary check so we dont load a million files to check if they are folders or not, though still does a isFolder in case the user has a file without a extension in their picture folders)
                if(currentFilePath.ToNSString.pathExtension == "") {
                    // If the current file is a folder...
                    if(NSFileManager.defaultManager().isFolder(currentFilePath)) {
                        // If the current file isnt supposed to be ignored...
                        if(!GZConstants.fileShouldBeIgnored(currentFilePath)) {
                            /// The amount of file in the current folder
                            let fileCount : Int =  NSFileManager.defaultManager().numberOfSupportedFilesInFolder(currentFilePath);
                            
                            // If fileCount is greater than 0...
                            if(fileCount > 0) {
                                // Add the current folder to the sidebar
                                folderSidebarItems.append(GZImageBrowserSidebarItemData(title: currentFileName, icon: NSImage(named: "NSFolder")!, imageCount: fileCount));
                                
                                // Set the path
                                folderSidebarItems.last!.path = currentFilePath + "/";
                                
                                // Set the section
                                folderSidebarItems.last!.section = .Folders;
                            }
                        }
                    }
                }
            }
        }
        
        // Reload the sidebar table view
        sidebarTableView.reloadData();
        
        // Scroll to the top of the sidebar
        sidebarTableViewScrollView.verticalScroller!.floatValue = Float(sidebarTableViewScrollView.documentView!.bounds.height * 5000000);
    }
    
    /// Called when the selection in sidebarTableView changes
    func sidebarTableViewSelectionChanged(selectedItem : GZImageBrowserSidebarItemData) {
        // Perform the sidebar selection changed action
        sidebarSelectionChangedTarget?.performSelector(sidebarSelectionChangedAction);
    }
    
    /// Styles this view
    func styleView() {
        // Style the visual effect views
        backgroundVisualEffectView.material = .Dark;
    }
}

extension GZImageBrowserSidebarViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(notification: NSNotification) {
        // If we didnt make the initial sidebarTableViewSelectionChanged call...
        if(!calledInitialSidebarSelectionChanged) {
            // Say we made the initial call
            calledInitialSidebarSelectionChanged = true;
        }
        
        // Call sidebarTableViewSelectionChanged
        sidebarTableViewSelectionChanged(sidebarTableViewSelectedItem);
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        /// The cell view for the table column
        let cellView : GZImageBrowserSidebarTableViewCell = tableView.makeViewWithIdentifier("Data Cell", owner: self) as! GZImageBrowserSidebarTableViewCell;
        
        /// If the table view's data source as a NSTableViewSectionDataSource isnt nil...
        if let dataSource = tableView.dataSource() as? NSTableViewSectionDataSource {
            /// The section and section row for the given row
            let (section, sectionRow) = dataSource.tableView(tableView, sectionForRow: row);
            
            // If the header view isnt nil...
            if let headerView = self.tableView(tableView, viewForHeaderInSection: section) as? NSTableCellView where sectionRow == 0 {
                // If the object value for the given column is a string and isnt nil...
                if let value = tableView.dataSource()?.tableView?(tableView, objectValueForTableColumn: tableColumn, row: row) as? String {
                    // Set the header view's label to be the object value for the given column
                    headerView.textField?.stringValue = value;
                }
                
                // Return the unmodified section header view
                return headerView;
            }
            
            // If the data at the given row is a GZImageBrowserSidebarItemData...
            if let cellData : GZImageBrowserSidebarItemData = tableView.dataSource()?.tableView?(tableView, objectValueForTableColumn: tableColumn, row: row) as? GZImageBrowserSidebarItemData {
                // Update the cell view to match the cell data
                cellView.imageView?.image = cellData.icon;
                cellView.textField?.stringValue = cellData.title;
                cellView.imageCountLabel.title = String(cellData.imageCount);
                
                // Set the tooltip
                cellView.toolTip = cellData.path;
            }
        }
        
        // Return the unmodified cell view
        return cellView;
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        // If the data source as a NSTableViewSectionDataSource isnt nil...
        if let dataSource = tableView.dataSource() as? NSTableViewSectionDataSource {
            /// The section and section row for the given row
            let (_, sectionRow) = dataSource.tableView(tableView, sectionForRow: row)
            
            // If the section row is 0...
            if(sectionRow == 0) {
                // Say we cant select this row
                return false;
            }
            
            // Say we can select this row
            return true;
        }
        
        // Say we cant select this row
        return false;
    }
}

/// The delegate protocol for table view sections
protocol NSTableViewSectionDelegate: NSTableViewDelegate {
    func tableView(tableView: NSTableView, viewForHeaderInSection section: Int) -> NSView?
}

extension GZImageBrowserSidebarViewController: NSTableViewSectionDelegate {
    func tableView(tableView: NSTableView, viewForHeaderInSection section: Int) -> NSView? {
        /// The header for this section
        let sectionHeaderCellView : NSTableCellView = tableView.makeViewWithIdentifier("Section Header Cell", owner: self) as! NSTableCellView;
        
        // Switch on the section, and return sectionView if it is a valid GZImageBrowserSidebarSection
        switch (section) {
            case GZImageBrowserSidebarSection.Folders.rawValue:
                return sectionHeaderCellView;
            case GZImageBrowserSidebarSection.Albums.rawValue:
                return sectionHeaderCellView;
            case GZImageBrowserSidebarSection.Groups.rawValue:
                return sectionHeaderCellView;
            default:
                break;
        }
        
        // Default to returning nil if the section is invalid
        return nil;
    }
}

/// The data source protocol for table view sections
protocol NSTableViewSectionDataSource: NSTableViewDataSource {
    func numberOfSectionsInTableView(tableView: NSTableView) -> Int
    func tableView(tableView: NSTableView, numberOfRowsInSection section: Int) -> Int
    func tableView(tableView: NSTableView, sectionForRow row: Int) -> (section: Int, row: Int)
}

extension GZImageBrowserSidebarViewController: NSTableViewSectionDataSource {
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        // If the data source is a NSTableViewSectionDataSource...
        if let dataSource = tableView.dataSource() as? NSTableViewSectionDataSource {
            /// The section and section row for the given row
            var (section, sectionRow) = dataSource.tableView(tableView, sectionForRow: row)
            
            // If the header view isnt nil...
            if let _ = self.tableView(tableView, viewForHeaderInSection: section) {
                // If the section row is 0...
                if(sectionRow == 0) {
                    // Return the section's name
                    return GZImageBrowserSidebarSection(rawValue: section)?.name;
                }
                // If the section row isnt 0...
                else {
                    // Subtract one from the section row
                    sectionRow -= 1
                }
            }
            
            // Switch on the section and return the appropriate object
            switch (section) {
                case GZImageBrowserSidebarSection.Folders.rawValue:
                    return folderSidebarItems[sectionRow];
                case GZImageBrowserSidebarSection.Albums.rawValue:
                    return albumSidebarItems[sectionRow]
                case GZImageBrowserSidebarSection.Groups.rawValue:
                    return groupSidebarItems[sectionRow];
                default:
                    break;
            }
        }
        
        // Default to nil
        return nil;
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        /// The total amount of rows in this table view
        var rowCount : Int = 0;
        
        // If the data source is a NSTableViewSectionDataSource...
        if let dataSource = tableView.dataSource() as? NSTableViewSectionDataSource {
            // For every section in the table view...
            for section in 0..<dataSource.numberOfSectionsInTableView(tableView) {
                // Add the number of rows in the current section to rowCount
                rowCount += dataSource.tableView(tableView, numberOfRowsInSection: section);
            }
        }
        
        // Return rowCount
        return rowCount;
    }
    
    func numberOfSectionsInTableView(tableView: NSTableView) -> Int {
        // Return the total number of values in GZImageBrowserSidebarSection
        return GZImageBrowserSidebarSection.totalSections;
    }
    
    func tableView(tableView: NSTableView, numberOfRowsInSection section: Int) -> Int {
        /// The amount of rows in the given section
        var sectionRowCount : Int = 0;
        
        // If the header view for the given section isnt nil...
        if let _ = self.tableView(tableView, viewForHeaderInSection: section) {
            // Add one to the section row count
            sectionRowCount += 1;
        }
        
        // Switch on the section and add the amount of items in the appropriate array to sectionRowCount
        switch (section) {
            case GZImageBrowserSidebarSection.Folders.rawValue:
                sectionRowCount += folderSidebarItems.count;
            case GZImageBrowserSidebarSection.Albums.rawValue:
                sectionRowCount += albumSidebarItems.count;
            case GZImageBrowserSidebarSection.Groups.rawValue:
                sectionRowCount += groupSidebarItems.count;
            default:
                break;
        }
        
        // Return sectionRowCount
        return sectionRowCount;
    }
    
    func tableView(tableView: NSTableView, sectionForRow row: Int) -> (section: Int, row: Int) {
        // If the data source is a NSTableViewSectionDataSource...
        if let dataSource = tableView.dataSource() as? NSTableViewSectionDataSource {
            /// The number of sections in the given table view
            let sectionCount : Int = dataSource.numberOfSectionsInTableView(tableView);
            
            /// How many rows are in each section
            var sectionRowCount : [Int] = [Int](count: sectionCount, repeatedValue: 0);
            
            /// For every section in the table view...
            for section in 0..<sectionCount {
                // Set the value at the current index in sectionRowCount to the number of rows in the current section
                sectionRowCount[section] = dataSource.tableView(tableView, numberOfRowsInSection: section);
            }
            
            /// The section for the given row
            let rowSection : (section: Int?, row : Int?) = self.sectionForRow(row, counts: sectionRowCount);
            
            // Return rowSection, with default values as 0 if any are nil
            return (section: rowSection.section ?? 0, row: rowSection.row ?? 0);
        }
        
        // Say that the data source is invalid
        assertionFailure("GZImageBrowserSidebarViewController: Invalid data source");
        
        // Return zeros for all values
        return (section: 0, row: 0);
    }
    
    private func sectionForRow(row: Int, counts: [Int]) -> (section: Int?, row: Int?) {
        // This looks like some fun stuff to comment, im not sure how it works.
        // So im leaving it as is
        
        var c = counts[0];
        
        for section in 0..<counts.count {
            if (section > 0) {
                c = c + counts[section];
            }
            if (row >= c - counts[section]) && row < c {
                return (section: section, row: row - (c - counts[section]));
            }
        }
        
        return (section: nil, row: nil);
    }
}

/// The different sections that an image browser sidebar can have
enum GZImageBrowserSidebarSection: Int {
    /// The folders section
    case Folders
    
    /// The albums section
    case Albums
    
    /// The groups section
    case Groups
    
    /// How many cases there are in this enum
    static var totalSections : Int {
        return 3;
    }
    
    /// Returns the name of this section
    var name : String {
        // Switch on the section and return the name
        switch (self) {
            case .Folders:
                return "Folders";
            case .Albums:
                return "Albums";
            case .Groups:
                return "Groups";
        }
    }
}