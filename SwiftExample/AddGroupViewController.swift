//
//  AddGroupViewController.swift
//  ChoreSmart
//
//  Created by Jelly Vora on 4/7/16.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController {
    
    var grpId:Int!
    @IBOutlet var groName: UITextField!
    @IBAction func addGrp(sender: AnyObject) {
        
        //Open db
        var database:COpaquePointer = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        var statement:COpaquePointer = nil
        
        
        // Do any additional setup after loading the view.
        let update1 = "INSERT INTO GROUPS (GROUP_ID,GROUP_NAME)" +
        "VALUES (\(grpId+1),\"\(groName.text!)\");"
        result = sqlite3_prepare_v2(database, update1, -1, &statement, nil)
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
        
        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    func dataFilePath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory = paths[0] as NSString
        
        return documentsDirectory.stringByAppendingPathComponent("data.sqlite") as String
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
