//
//  GroupsViewController.swift
//  ChoreSmart
//
//  Created by Shyam Raju on 4/3/16.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var groups = ["G 1"]
    
    @IBOutlet var groupsTableView: UITableView!
    
    @IBAction func popover(sender: AnyObject) {
        self.performSegueWithIdentifier("addGrp", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addGrp"
        {
            let popoverViewController = segue.destinationViewController as! AddGroupViewController
            popoverViewController.grpId=groups.count
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
    var identities = ["memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView","memView"]
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
        self.navigationController!.navigationBar.translucent = false
        
    }
    
    
    
    
    //@available(iOS 2.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UITableViewCell = self.groupsTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel!.text = self.groups[indexPath.row]
        cell.imageView!.image = UIImage(named: "Group 1")
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
            let val = indexPath.row
            let name=groups[val]
            let update = "DELETE FROM GROUPS WHERE GROUP_NAME=\"\(name)\";"
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
    
    
    
       func loadList(notification: NSNotification){
        //load data here
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"reload", object: nil)
        
        
        
        // Do any additional setup after loading the view.
        self.groupsTableView.delegate = self
        self.groupsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.groupsTableView.dataSource = self
        
        //tint color
        UINavigationBar.appearance().tintColor = UIColor(red: 63.0/255.0, green: 179.0/255.0, blue: 130.0/255.0, alpha: 1.0)

       
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
        let query = "SELECT * FROM GROUPS;"
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let grpId = Int(sqlite3_column_int(statement, 0))
                let rowData = sqlite3_column_text(statement, 1)
                let grpName = String.fromCString(UnsafePointer<CChar>(rowData))
                //groups![grpId] = grpName!
                
                groups.insert(grpName!, atIndex: grpId)
                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        save()
        groups.removeFirst()
        groups = Array(Set(groups))
        groupsTableView.reloadData()
        //Persist data before being sent to background
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: app)
        
        
    }
    func save(){
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
