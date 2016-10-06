//
//  MembersViewController.swift
//  ChoreSmart
//
//  Created by Jelly Vora on 4/6/16.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit

class MembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var members = ["Member 1"]
    
    @IBOutlet var membersTableView: UITableView!
    
    
    @IBAction func popover(sender: AnyObject) {
        self.performSegueWithIdentifier("addMem", sender: self)
    }
    @IBOutlet var addNew: UIView!
    
    func dataFilePath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory = paths[0] as NSString
        
        return documentsDirectory.stringByAppendingPathComponent("data.sqlite") as String
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addMem"
        {
            let popoverViewController = segue.destinationViewController as! AddMemberViewController
            popoverViewController.popoverPresentationController?.delegate=self
            //pass currentdate
            
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
     return .None
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return members.count
    }
    
    
    //////NAVIGATE
    
    var valueToPass = String()
    var identities = ["calView","calView","calView","calView","calView","calView","calView","calView","calView","calView","calView","calView","calView","calView"]
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //print("GOGOOGOG")
        //let row = indexPath.row
        //print(swiftBlogs[row])
        
        // cells to view
        print("You selected cell #\(indexPath.row)!")
        
        valueToPass=self.members[indexPath.row]
        
        print(valueToPass)
        
        //var storyboard = UIStoryboard(name: "IDEInterface", bundle: nil)
        groupID = indexPath.row+1
        
        let vcName = identities[indexPath.row]
        let viewController = storyboard?.instantiateViewControllerWithIdentifier(vcName)
        self.navigationController?.pushViewController(viewController!, animated: true)
        self.navigationController!.navigationBar.translucent = false
        //self.
    }
    
    
    
    
    //@available(iOS 2.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UITableViewCell = self.membersTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel!.text = self.members[indexPath.row]
        cell.imageView!.image = UIImage(named: "member")
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            print("Delete Member")
            //self.members.removeAtIndex(indexPath.row)
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
            let update = "DELETE FROM MEMBERS WHERE MEMBER_NAME=\"\(members[val])\" AND GROUP_ID=\(groupID);"
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
            
            
            self.members.removeAtIndex(indexPath.row)
            
            // Take this line off while using database
            self.membersTableView.reloadData()
        }
    }


    func loadList1(notification: NSNotification){
        //load data here
        print("refresh mem")
        viewDidLoad()
        viewDidLoad()
        print("ref done")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList1:",name:"reloadmem", object: nil)
        // Do any additional setup after loading the view.
        self.membersTableView.delegate = self
        self.membersTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.membersTableView.dataSource = self
        
        
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
        let query = "SELECT MEMBER_NAME FROM MEMBERS WHERE GROUP_ID=\(groupID);"
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let rowData = sqlite3_column_text(statement, 0)
                let memName = String.fromCString(UnsafePointer<CChar>(rowData))
                
                members.insert(memName!, atIndex: members.count)
                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        save()
        members.removeFirst()
        members=Array(Set(members))
        membersTableView.reloadData()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
