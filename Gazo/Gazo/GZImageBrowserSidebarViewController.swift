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
    var folderSidebarItems : [GZImageBrowserSidebarItemData] = [GZImageBrowserSidebarItemData(title: "Folder One", icon: NSImage(named: "NSFolder")!), GZImageBrowserSidebarItemData(title: "Folder Two", icon: NSImage(named: "NSFolder")!), GZImageBrowserSidebarItemData(title: "Folder Three", icon: NSImage(named: "NSFolder")!)];
    
    /// The albums in the sidebar
    var albumSidebarItems : [GZImageBrowserSidebarItemData] = [GZImageBrowserSidebarItemData(title: "Album One", icon: NSImage(named: "NSFolder")!)];
    
    /// The groups in the sidebar
    var groupSidebarItems : [GZImageBrowserSidebarItemData] = [GZImageBrowserSidebarItemData(title: "Group One", icon: NSImage(named: "NSFolder")!), GZImageBrowserSidebarItemData(title: "Group Two", icon: NSImage(named: "NSFolder")!)];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style this view
        styleView();
        
        // Reload the sidebar table view
        sidebarTableView.reloadData();
    }
    
    /// Called when the selection in sidebarTableView changes
    func sidebarSelectionChanged(selectedItem : GZImageBrowserSidebarItemData, selectedItemSection : GZImageBrowserSidebarSection) {
        print("Selected \"\(selectedItem.title)\" in \"\(selectedItemSection.name)\"");
    }
    
    /// Styles this view
    func styleView() {
        // Style the visual effect views
        backgroundVisualEffectView.material = .Dark;
    }
}

extension GZImageBrowserSidebarViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(notification: NSNotification) {
        /// The table view from the given notification
        let tableView : NSTableView = (notification.object as! NSTableView);
        
        /// The data source of tableView as a NSTableViewSectionDataSource
        let tableViewDataSource : NSTableViewSectionDataSource = (tableView.dataSource()! as! NSTableViewSectionDataSource);
        
        /// The GZImageBrowserSidebarItemData that was selected
        let selectedItem : GZImageBrowserSidebarItemData = ((tableView.dataSource()!.tableView!(tableView, objectValueForTableColumn: nil, row: tableView.selectedRow)) as! GZImageBrowserSidebarItemData);
        
        /// The GZImageBrowserSidebarSection selectedItem is in
        let selectedItemSection : GZImageBrowserSidebarSection = GZImageBrowserSidebarSection(rawValue: tableViewDataSource.tableView(tableView, sectionForRow: tableView.selectedRow).section)!;
        
        // Call sidebarSelectionChanged
        sidebarSelectionChanged(selectedItem, selectedItemSection: selectedItemSection);
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        /// The cell view for the table column
        let cellView : NSTableCellView = tableView.makeViewWithIdentifier("Data Cell", owner: self) as! NSTableCellView;
        
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