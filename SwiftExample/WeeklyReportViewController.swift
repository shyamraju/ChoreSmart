//
//  WeeklyReportViewController.swift
//  ChoreSmart
//
//  Created by Shyam Raju on 4/6/16.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit

class WeeklyReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var groups = ["Group 1"]
    
    @IBOutlet var groupsTableView: UITableView!
    
    @IBAction func popover(sender: AnyObject) {
        self.performSegueWithIdentifier("addGrp", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addGrp"
        {
            let popoverViewController = segue.destinationViewController
            popoverViewController.popoverPresentationController?.delegate=self
            //pass currentdate
            
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    @IBOutlet var addNew: UIView!
    
    func dataFilePath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory = paths[0] as NSString
        
        return documentsDirectory.stringByAppendingPathComponent("data.sqlite") as String
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return groups.count
    }
    
    
    //////NAVIGATE
    
    var valueToPass = String()
    var identities = ["memView","memView"]
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //print("GOGOOGOG")
        //let row = indexPath.row
        //print(swiftBlogs[row])
        
        // cells to view
        print("You selected cell #\(indexPath.row)!")
        
        valueToPass=self.groups[indexPath.row]
        
        print(valueToPass)
        
        //var storyboard = UIStoryboard(name: "IDEInterface", bundle: nil)
        groupID = indexPath.row+1
        
        let vcName = identities[indexPath.row]
        let viewController = storyboard?.instantiateViewControllerWithIdentifier(vcName)
        self.navigationController?.pushViewController(viewController!, animated: true)
        //self.navigationController!.navigationBar.translucent = false
    }
    
    
    
    
    //@available(iOS 2.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UITableViewCell = self.groupsTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel!.text = self.groups[indexPath.row]
        cell.imageView!.image = UIImage(named: "food_icon")
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            print("Delete Group")
            //self.groups.removeAtIndex(indexPath.row)
            //Open db
            var database:COpaquePointer = nil
            var result = sqlite3_open(dataFilePath(), &database)
            if result != SQLITE_OK{
                sqlite3_close(database)
                print("Failed to open database")
                return
            }
            
            //delete
            let val = indexPath.row+1
            let update = "DELETE FROM BILL WHERE BILL_DESCRIPTION=\"\(groups[indexPath.row])\" AND GROUP_ID=\(groupID);"
            var errMsg:UnsafeMutablePointer<Int8> = nil
            var statement:COpaquePointer = nil
            result = sqlite3_prepare_v2(database, update, -1, &statement, nil)
            print(result)
            NSLog("Database returned error %d: %s",sqlite3_errcode(database), sqlite3_errmsg(database));
            if result == SQLITE_OK {
            }
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error updating table")
                sqlite3_close(database)
                return
            }
            sqlite3_finalize(statement)
            
            
            self.groups.removeAtIndex(indexPath.row)
            
            // Take this line off while using database
            self.groupsTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        self.groupsTableView.delegate = self
        self.groupsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.groupsTableView.dataSource = self
        
        
        //Edit button
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //Open db
        var database:COpaquePointer = nil
        let result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        
        var statement:COpaquePointer = nil
        //Query the table
        //var statement:COpaquePointer = nil
        let query = "SELECT BILL_DESCRIPTION FROM BILL WHERE CURRENT_DATE > (SELECT DATETIME('now', '-7 day')) AND GROUP_ID=\(groupID);"
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let rowData = sqlite3_column_text(statement, 0)
                let grpName = String.fromCString(UnsafePointer<CChar>(rowData))
                //groups![grpId] = grpName!
                groups.insert(grpName!, atIndex: groups.count)
                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        groups.removeFirst()
        
        //Persist data before being sent to background
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: app)
    }
    
    func applicationWillResignActive(notification:NSNotification){
        var database: COpaquePointer = nil
        let result = sqlite3_open(dataFilePath(), &database)
        print(result)
        if result != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        sqlite3_close(database)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
