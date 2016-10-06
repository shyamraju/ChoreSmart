//
//  AddChoreViewController.swift
//  ChoreSmart
//
//  Created by Shyam Raju on 4/1/16.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit

class AddChoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var text2: UITextField!
    @IBOutlet var text1: UITextField!
    var swiftBlogs = ["Ray Wenderlich"]
    var myarray = [String]()
    func dataFilePath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory = paths[0] as NSString
        
        return documentsDirectory.stringByAppendingPathComponent("data.sqlite") as String
        
    }
    
    @IBOutlet var AddMemberBtn: UIButton!
    @IBAction func DoneButton(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    @IBAction func saveChoreBtn(sender: AnyObject) {
        //Open db
        var database:COpaquePointer = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        var statement:COpaquePointer = nil
        let choreName=self.text1.text!
        let credits:Int! = Int(self.text2.text!)
        for name in myarray{
            var update9 = "INSERT INTO CHORES (CHORENAME, GROUP_ID, MEMBER_NAME,CREDITS, DONEBY,ENTRY_DATE)" +
            "VALUES (\"\(choreName)\",1,\"\(name)\",\(credits),\"\(name)\",\"\(dateSelected)\");"
            
            result = sqlite3_prepare_v2(database, update9, -1, &statement, nil)
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
        }

        
    }
    
    @IBAction func backgroundTap(sender:UIControl)
    {
        text1.resignFirstResponder()
        text2.resignFirstResponder()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        memberView.delegate = self
        memberView.dataSource = self
        self.memberView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.memberView.dataSource = self
        //Open db
        var database:COpaquePointer = nil
        var result = sqlite3_open(dataFilePath(), &database)
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
                swiftBlogs.insert(memName!, atIndex: swiftBlogs.count)
                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        swiftBlogs.removeFirst()
        
        //Persist data before being sent to background
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: app)
    }
    
    func applicationWillResignActive(notification:NSNotification){
        var database: COpaquePointer = nil
        var result = sqlite3_open(dataFilePath(), &database)
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
    
    
    @IBOutlet var memberView: UITableView!
    
    let textCellIdentifier = "Chores"
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.memberView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel!.text = self.swiftBlogs[indexPath.row]
        cell.imageView!.image = UIImage(named: swiftBlogs[indexPath.row])
       
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            print("Chore Deleted")
            self.swiftBlogs.removeAtIndex(indexPath.row)
            
            // Take this line off while using database
            self.memberView.reloadData()
        }
    }
    
    @IBOutlet var addedChores: UITextView!
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(swiftBlogs[row])
        
        //Adding members from table view to array
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        var currentCellName = String()
        currentCellName = ((currentCell.textLabel?.text!)!)
        let index=myarray.indexOf(currentCellName)
        if myarray.contains(currentCellName){
            currentCell.accessoryType=UITableViewCellAccessoryType.None
            //Disabling Cell
            //currentCell.selectionStyle = UITableViewCellSelectionStyle.None
            //print("Already there")
            myarray.removeAtIndex(index!)
        }
        else
        {
            currentCell.accessoryType=UITableViewCellAccessoryType.Checkmark
            myarray.append(currentCellName)
            //print("Added")
        }
        
        let stringRepresentation = myarray.joinWithSeparator(",")
        //addedChores.text = stringRepresentation

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
