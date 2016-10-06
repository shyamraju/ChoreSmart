//
//  AddChoreViewController.swift
//  ChoreSmart
//
//  Created by Shyam Raju on 4/1/16.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit

class ChoreDetailViewController: UIViewController {
    var choreName:String!
    func dataFilePath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory = paths[0] as NSString
        
        return documentsDirectory.stringByAppendingPathComponent("data.sqlite") as String
        
    }
    @IBAction func EDIT(sender: AnyObject) {
        
        text1.enabled = true
        text2.enabled = true
        mem1.enabled = true
        mem2.enabled = true
        mem3.enabled = true
        mem4.enabled = true
        mem5.enabled = true
        del1.hidden = false
        del2.hidden = false
        del3.hidden = false
        del4.hidden = false
        del5.hidden = false
        
        // Adding action to delete buttons
        del1.addTarget(self, action: "buttonPressed1", forControlEvents: UIControlEvents.TouchUpInside)
        del2.addTarget(self, action: "buttonPressed2", forControlEvents: UIControlEvents.TouchUpInside)
        del3.addTarget(self, action: "buttonPressed3", forControlEvents: UIControlEvents.TouchUpInside)
        del4.addTarget(self, action: "buttonPressed4", forControlEvents: UIControlEvents.TouchUpInside)
        del5.addTarget(self, action: "buttonPressed5", forControlEvents: UIControlEvents.TouchUpInside)
        
        }
    
        //delete buttonPressed function
    func buttonPressed1()
        {
            
            //Open db
            var database:COpaquePointer = nil
            var result = sqlite3_open(dataFilePath(), &database)
            if result != SQLITE_OK{
                sqlite3_close(database)
                print("Failed to open database")
                return
            }
            
            var statement:COpaquePointer = nil
            //delete
            let delete = "DELETE FROM CHORES WHERE GROUP_ID=\"\(groupID)\" AND CHORENAME=\"\(text1.text!)\" AND MEMBER_NAME=\"\(mem1.text!)\";"
            var errMsg:UnsafeMutablePointer<Int8> = nil
            result = sqlite3_prepare_v2(database, delete, -1, &statement, nil)
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
            mem1.text = ""

            
        }
    
    func buttonPressed2()
    {
        //Open db
        var database:COpaquePointer = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        
        var statement:COpaquePointer = nil
        //delete
        let delete = "DELETE FROM CHORES WHERE GROUP_ID=\"\(groupID)\" AND CHORENAME=\"\(text1.text!)\" AND MEMBER_NAME=\"\(mem2.text!)\";"
        var errMsg:UnsafeMutablePointer<Int8> = nil
        result = sqlite3_prepare_v2(database, delete, -1, &statement, nil)
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
        mem2.text = ""
        
    }
    
    func buttonPressed3()
    {
        //Open db
        var database:COpaquePointer = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        
        var statement:COpaquePointer = nil
        //delete
        let delete = "DELETE FROM CHORES WHERE GROUP_ID=\"\(groupID)\" AND CHORENAME=\"\(text1.text!)\" AND MEMBER_NAME=\"\(mem3.text!)\";"
        var errMsg:UnsafeMutablePointer<Int8> = nil
        result = sqlite3_prepare_v2(database, delete, -1, &statement, nil)
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
        mem3.text = ""
        
    }
    
    func buttonPressed4()
    {
        //Open db
        var database:COpaquePointer = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        
        var statement:COpaquePointer = nil
        //delete
        let delete = "DELETE FROM CHORES WHERE GROUP_ID=\"\(groupID)\" AND CHORENAME=\"\(text1.text!)\" AND MEMBER_NAME=\"\(mem4.text!)\";"
        var errMsg:UnsafeMutablePointer<Int8> = nil
        result = sqlite3_prepare_v2(database, delete, -1, &statement, nil)
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
        mem4.text = ""
    }
    
    func buttonPressed5()
    {
        //Open db
        var database:COpaquePointer = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        
        var statement:COpaquePointer = nil
        //delete
        let delete = "DELETE FROM CHORES WHERE GROUP_ID=\"\(groupID)\" AND CHORENAME=\"\(text1.text!)\" AND MEMBER_NAME=\"\(mem5.text!)\";"
        var errMsg:UnsafeMutablePointer<Int8> = nil
        result = sqlite3_prepare_v2(database, delete, -1, &statement, nil)
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
        mem5.text = ""
        
    }
    
    
    @IBOutlet var text2: UITextField!
    @IBOutlet var text1: UITextField!
    @IBOutlet var Members: [UITextField]!
    @IBAction func DoneButton(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        mem2.resignFirstResponder()
        mem3.resignFirstResponder()
        mem4.resignFirstResponder()
        mem5.resignFirstResponder()
        mem1.resignFirstResponder()
        text1.resignFirstResponder()
        text2.resignFirstResponder()
        
    }
    
    
    @IBOutlet var mem5: UITextField!
    @IBOutlet var mem4: UITextField!
    @IBOutlet var mem3: UITextField!
    @IBOutlet var mem2: UITextField!
    @IBOutlet var mem1: UITextField!
    @IBOutlet var del5: UIButton!
    @IBOutlet var del4: UIButton!
    @IBOutlet var del3: UIButton!
    @IBOutlet var del1: UIButton!
    
    @IBOutlet var del2: UIButton!
    @IBAction func backgroundTap(sender:UIControl)
    {
        text1.resignFirstResponder()
        text2.resignFirstResponder()
        mem2.resignFirstResponder()
        mem3.resignFirstResponder()
        mem4.resignFirstResponder()
        mem5.resignFirstResponder()
        mem1.resignFirstResponder()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        text1.text = choreName
        text1.enabled = false
        text2.enabled = false
        del1.hidden = true
        del2.hidden = true
        del3.hidden = true
        del4.hidden = true
        del5.hidden = true
        mem1.enabled = false
        mem2.enabled = false
        mem3.enabled = false
        mem4.enabled = false
        mem5.enabled = false
        
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
        let query = "SELECT MEMBER_NAME, CREDITS FROM CHORES WHERE GROUP_ID=\(groupID) AND CHORENAME=\"\(choreName)\";"
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            var no = sqlite3_data_count(statement)
            var c=0
            while sqlite3_step(statement) == SQLITE_ROW{
                let rowData2 = sqlite3_column_text(statement, 0)
                let memName = String.fromCString(UnsafePointer<CChar>(rowData2))
                if c==0{
                    mem1.text=memName
                }else if c==1{
                    mem2.text=memName
                }
                else if c==2{
                    mem3.text=memName
                }
                else if c==3{
                    mem4.text=memName
                }
                else if c==4{
                    mem5.text=memName
                }
                c++
                let credits = sqlite3_column_int(statement, 1)
                text2.text = String(credits)
                
                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        
        
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
    
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
