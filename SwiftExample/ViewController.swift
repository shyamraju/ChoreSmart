//
//  ViewController.swift
//  SwiftExample
//
//  Created by Wenchao Ding on 9/3/15.
//  Copyright (c) 2015 wenchao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet var choresView: UITableView!
    @IBOutlet var Back1: UIButton!
    var swiftBlogs1:[String] = [""]
    
    @IBOutlet var choose: UILabel!
    
    var swiftBlogs = ["Select a date to load Chores"]
    func dataFilePath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory = paths[0] as NSString
        
        return documentsDirectory.stringByAppendingPathComponent("data.sqlite") as String
        
    }
    @IBAction func Back(sender: AnyObject) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.calendar.setScope(.Month, animated: true)
            
        }
        Back1.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAdd"
        {
            let popoverViewController = segue.destinationViewController
            popoverViewController.popoverPresentationController?.delegate=self
            //pass currentdate
            
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    let datesWithCat = ["20150505","20150605","20150705","20150805","20150905","20151005","20151105","20151205","20160106",
        "20160206","20160306","20160406","20160506","20160606","20160706"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.scrollDirection = .Vertical
        calendar.appearance.caseOptions = [.HeaderUsesUpperCase,.WeekdayUsesUpperCase]
        let date1 = NSDate()
        let calendar1 = NSCalendar.currentCalendar()
        let components1 = calendar1.components([.Day , .Month , .Year], fromDate: date1)
        
        let year1 =  components1.year
        let month1 = components1.month
        let day1 = components1.day
        
        
        calendar.selectDate(calendar.dateWithYear(year1, month: month1, day: day1))
        choresView .reloadData()
        choresView.hidden = true
        Back1.hidden = true
        print("group under")
        print(groupID);
        
        //        calendar.allowsMultipleSelection = true
        
        // Uncomment this to test month->week and week->month transition
        /*
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
        self.calendar.setScope(.Week, animated: true)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
        self.calendar.setScope(.Month, animated: true)
        }
        }
        */
        
        choresView.delegate = self
        choresView.dataSource = self
        self.choresView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.choresView.dataSource = self
        //Open db
        var database:COpaquePointer = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
       
        
        //Create a table
        let createGroupsSQL = "CREATE TABLE IF NOT EXISTS GROUPS " +
        "(GROUP_ID INTEGER PRIMARY KEY, GROUP_NAME TEXT);"
        let createMemberSQL = "CREATE TABLE IF NOT EXISTS MEMBERS " +
        "(MEMBER_NAME TEXT PRIMARY KEY, CONTACT_NO TEXT, MEM_CREDITS INTEGER, GROUP_ID INTEGER,FOREIGN KEY(GROUP_ID) REFERENCES GROUPS(GROUP_ID));"
        let createChoresSQL = "CREATE TABLE IF NOT EXISTS CHORES " +
        "(CHORENAME TEXT,GROUP_ID INTEGER ,MEMBER_NAME TEXT, CREDITS INTEGER, DONEBY TEXT,ENTRY_DATE DATE DEFAULT CURRENT_DATE,PRIMARY KEY (CHORENAME, GROUP_ID, MEMBER_NAME),FOREIGN KEY(DONEBY) REFERENCES MEMBERS(MEMBER_NAME),FOREIGN KEY(MEMBER_NAME) REFERENCES MEMBERS(MEMBER_NAME),FOREIGN KEY(GROUP_ID) REFERENCES GROUPS(GROUP_ID));"
        let createBillSQL = "CREATE TABLE IF NOT EXISTS BILL " +
        "(BILL_DESCRIPTION TEXT,AMOUNT INTEGER,GROUP_ID INTEGER ,PAID_BY TEXT, MEMBER_NAME TEXT,SHARE INTEGER,ENTRY_DATE DATE DEFAULT CURRENT_DATE,PRIMARY KEY (BILL_DESCRIPTION, GROUP_ID),FOREIGN KEY(PAID_BY) REFERENCES MEMBERS(MEMBER_NAME),FOREIGN KEY(MEMBER_NAME) REFERENCES MEMBERS(MEMBER_NAME),FOREIGN KEY(GROUP_ID) REFERENCES GROUPS(GROUP_ID));"
        var errMsg:UnsafeMutablePointer<Int8> = nil
        if (sqlite3_exec(database, "PRAGMA foreign_keys = ON", nil, nil, &errMsg) != SQLITE_OK)
        {
            sqlite3_close(database)
            print("Failed to open database")
            return
            
        }
        result = sqlite3_exec(database, createGroupsSQL, nil, nil, &errMsg);
        let result2 = sqlite3_exec(database, createMemberSQL, nil, nil, &errMsg);
        let result3 = sqlite3_exec(database, createChoresSQL, nil, nil, &errMsg);
        let result4 = sqlite3_exec(database, createBillSQL, nil, nil, &errMsg);
        
        if result != SQLITE_OK || result2 != SQLITE_OK || result3 != SQLITE_OK || result4 != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        
        let update = "INSERT OR REPLACE INTO GROUPS (GROUP_ID,GROUP_NAME)" +
        "VALUES (1,\"iTeam\");"
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
        
        let update1 = "INSERT OR REPLACE INTO GROUPS (GROUP_ID,GROUP_NAME)" +
        "VALUES (2,\"iApp\");"
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
        
        let update3 = "INSERT OR REPLACE INTO MEMBERS (MEMBER_NAME, CONTACT_NO,MEM_CREDITS,GROUP_ID)" +
        "VALUES (\"Shyam Raju\",\"111-222-3456\",0,1);"
        let update4 = "INSERT OR REPLACE INTO MEMBERS (MEMBER_NAME, CONTACT_NO,MEM_CREDITS,GROUP_ID)" +
        "VALUES (\"Jelly Vora\",\"222-333-3456\",0,1);"
        let update5 = "INSERT OR REPLACE INTO MEMBERS (MEMBER_NAME, CONTACT_NO,MEM_CREDITS,GROUP_ID)" +
        "VALUES (\"Judith Jane\",\"333-444-3456\",0,1);"
        let update6 = "INSERT OR REPLACE INTO MEMBERS (MEMBER_NAME, CONTACT_NO,MEM_CREDITS,GROUP_ID)" +
        "VALUES (\"Zhi Li\",\"444-888-3456\",0,1);"
        let update7 = "INSERT OR REPLACE INTO MEMBERS (MEMBER_NAME, CONTACT_NO,MEM_CREDITS,GROUP_ID)" +
        "VALUES (\"Shengde Li\",\"555-999-3456\",0,1);"
        let update13 = "INSERT OR REPLACE INTO MEMBERS (MEMBER_NAME, CONTACT_NO,MEM_CREDITS,GROUP_ID)" +
        "VALUES (\"Lexie Grey\",\"000-999-3456\",0,2);"
        let update14 = "INSERT OR REPLACE INTO MEMBERS (MEMBER_NAME, CONTACT_NO,MEM_CREDITS,GROUP_ID)" +
        "VALUES (\"Mark Sloan\",\"999-666-3456\",0,2);"

        
        result = sqlite3_prepare_v2(database, update3, -1, &statement, nil)
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
        result = sqlite3_prepare_v2(database, update4, -1, &statement, nil)
        print(result)
        NSLog("Database returned error %d: %s",sqlite3_errcode(database), sqlite3_errmsg(database));
        if result == SQLITE_OK {
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error updating table")
            sqlite3_close(database)
            return
        }
        result = sqlite3_prepare_v2(database, update5, -1, &statement, nil)
        print(result)
        NSLog("Database returned error %d: %s",sqlite3_errcode(database), sqlite3_errmsg(database));
        if result == SQLITE_OK {
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error updating table")
            sqlite3_close(database)
            return
        }
        result = sqlite3_prepare_v2(database, update6, -1, &statement, nil)
        print(result)
        NSLog("Database returned error %d: %s",sqlite3_errcode(database), sqlite3_errmsg(database));
        if result == SQLITE_OK {
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error updating table")
            sqlite3_close(database)
            return
        }
        result = sqlite3_prepare_v2(database, update7, -1, &statement, nil)
        print(result)
        NSLog("Database returned error %d: %s",sqlite3_errcode(database), sqlite3_errmsg(database));
        if result == SQLITE_OK {
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error updating table")
            sqlite3_close(database)
            return
        }
        result = sqlite3_prepare_v2(database, update13, -1, &statement, nil)
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
        result = sqlite3_prepare_v2(database, update14, -1, &statement, nil)
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
        
        let update8 = "INSERT OR REPLACE INTO CHORES (CHORENAME, GROUP_ID, MEMBER_NAME,CREDITS, DONEBY,ENTRY_DATE)" +
        "VALUES (\"COOK DINNER\",1,\"Jelly Vora\",2,\"Jelly Vora\",\"2016-04-03\");"
        
        result = sqlite3_prepare_v2(database, update8, -1, &statement, nil)
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
        
        let update9 = "INSERT OR REPLACE INTO CHORES (CHORENAME, GROUP_ID, MEMBER_NAME,CREDITS, DONEBY,ENTRY_DATE)" +
        "VALUES (\"WASH UTENSILS\",2,\"Zhi Li\",1,\"Zhi Li\",\"2016-04-04\");"
        
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
        
        let update10 = "INSERT OR REPLACE INTO CHORES (CHORENAME, GROUP_ID, MEMBER_NAME,CREDITS, DONEBY,ENTRY_DATE)" +
        "VALUES (\"THROW TRASH\",1,\"Shyam Raju\",0,\"Shyam Raju\",\"2016-04-05\");"
        
        result = sqlite3_prepare_v2(database, update10, -1, &statement, nil)
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
        
        
        
        let update11 = "INSERT OR REPLACE  INTO CHORES (CHORENAME, GROUP_ID, MEMBER_NAME,CREDITS, DONEBY,ENTRY_DATE)" +
        "VALUES (\"THROW TRASH 2\",2,\"Judith Jane\",0,\"Judith Jane\",\"2016-04-05\");"
        
        result = sqlite3_prepare_v2(database, update11, -1, &statement, nil)
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
        let update12 = "INSERT OR REPLACE  INTO CHORES (CHORENAME, GROUP_ID, MEMBER_NAME,CREDITS, DONEBY,ENTRY_DATE)" +
        "VALUES (\"THROW TRASH\",1,\"Shengde Li\",4,\"Shengde Li\",\"2016-04-05\");"
        
        result = sqlite3_prepare_v2(database, update12, -1, &statement, nil)
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
        let update15 = "INSERT OR REPLACE INTO CHORES (CHORENAME, GROUP_ID, MEMBER_NAME,CREDITS, DONEBY,ENTRY_DATE)" +
        "VALUES (\"THROW TRASH\",1,\"Lexie Grey\",1,\"Lexie Grey\",\"2016-04-05\");"
        
        result = sqlite3_prepare_v2(database, update15, -1, &statement, nil)
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
        let update16 = "INSERT OR REPLACE INTO CHORES (CHORENAME, GROUP_ID, MEMBER_NAME,CREDITS, DONEBY,ENTRY_DATE)" +
        "VALUES (\"THROW TRASH\",1,\"Mark Sloan\",1,\"Mark Sloan\",\"2016-04-05\");"
        
        result = sqlite3_prepare_v2(database, update16, -1, &statement, nil)
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
    
    
    
    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2016, month: 1, day: 1)
    }
    
    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2020, month: 12, day: 31)
    }
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
    NSLog("change page to \(calendar.stringFromDate(calendar.currentPage))")
    var month1:String
    if(calendar.monthOfDate(calendar.currentPage) < 10)
    {
    month1 = "0\(calendar.monthOfDate(calendar.currentPage))"
    
    }
    else
    {
    month1 = "\(calendar.monthOfDate(calendar.currentPage))"
    }
    print(month1)
    //icons(month1)
    }
    
    
    //func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
    //    let day = calendar.dayOfDate(date)
    //    return day % 5 == 0 ? day/5 : 0;
    //}
    
   
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        NSLog("calendar did select date \(calendar.stringFromDate(date))")
        dateSelected = calendar.stringFromDate(date)
        swiftBlogs.removeAll()
        swiftBlogs = ["Select a date to load Chores"]
        //Query the table
        //var statement:COpaquePointer = nil
        var database:COpaquePointer = nil
        let result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        var statement:COpaquePointer = nil
        let query = "SELECT DISTINCT(CHORENAME) FROM CHORES WHERE GROUP_ID=\"\(groupID)\" AND ENTRY_DATE=\"\(calendar.stringFromDate(date))\";"
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let rowData = sqlite3_column_text(statement, 0)
                let memName = String.fromCString(UnsafePointer<CChar>(rowData))
                swiftBlogs.insert(memName!, atIndex: swiftBlogs.count)
                //print(swiftBlogs)
                //print(swiftBlogs.count)
                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        swiftBlogs.removeFirst()
        choresView.reloadData()
        choose.hidden = true
        choresView.hidden = false
        //print(swiftBlogs)
        //print(swiftBlogs.count)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.calendar.setScope(.Week, animated: true)
            
        }
        Back1.hidden = false
        
    }
    
    func calendar(calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    //icons
    
    func icons(month:String){
        
        var database:COpaquePointer = nil
        let result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        var statement:COpaquePointer = nil
    //SELECT strftime('%d', `Date`) FROM sessiondate
    let queryicon = "SELECT strftime('%d', ENTRY_DATE) FROM CHORES WHERE strftime('%m', ENTRY_DATE) = \"\(month)\";"
    if sqlite3_prepare_v2(database, queryicon, -1, &statement, nil) == SQLITE_OK {
    while sqlite3_step(statement) == SQLITE_ROW{
    let rowData = sqlite3_column_text(statement, 0)
    let memName = String.fromCString(UnsafePointer<CChar>(rowData))
        print(memName)
    
        swiftBlogs1.insert(memName!, atIndex: swiftBlogs.count)
        //print(swiftBlogs1)
        //print(swiftBlogs.count)
        
        }
        sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        swiftBlogs1.removeFirst()
        print(swiftBlogs1)
        intArray = swiftBlogs1.map { Int($0)!}
        intArray=Array(Set(intArray))
        print(intArray)
   
    
    swiftBlogs1=[""]
    }
    
    
    var intArray:[Int] = []
    func calendar(calendar: FSCalendar, imageForDate date: NSDate) -> UIImage? {
        return [intArray].containsObject(calendar.dayOfDate(date)) ? UIImage(named: "icon_cat") : nil
    }
    
    
 
    
    let textCellIdentifier = "Chores"
    
    
    
    //Cells to view
    
    var identities = ["Detail View Controller","Detail View Controller","Detail View Controller","Detail View Controller","Detail View Controller","Detail View Controller","Detail View Controller","Detail View Controller","Detail View Controller"]
    
    
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.choresView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        //print(indexPath.row)
        cell.textLabel!.text = self.swiftBlogs[indexPath.row]
        
        
        cell.imageView!.image = UIImage(named: swiftBlogs[indexPath.row])
        
        
        //claim button to cell
        let btn = UIButton(type: UIButtonType.System)
        btn.backgroundColor = UIColor.clearColor()
        btn.setTitle("CLAIM", forState: UIControlState.Normal)
        btn.frame = CGRectMake(280.0, 5.0, 100.0, 30.0)
        btn.setTitleColor(UIColor.init(red: 63.0/255.0, green: 179.0/255.0, blue: 130.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
        
        //claim button border
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.grayColor().CGColor
        
        btn.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.tag = indexPath.row
        cell.contentView.addSubview(btn)
        
        return cell
    }
    
    func buttonPressed(sender: UIButton){
        let alertController = UIAlertController(title: "CHORE CLAIMED", message:
            "You have successfully claimed the chore.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            print("Chore Deleted")
            //Open db
            var database:COpaquePointer = nil
            var result = sqlite3_open(dataFilePath(), &database)
            if result != SQLITE_OK{
                sqlite3_close(database)
                print("Failed to open database")
                return
            }
            
            //delete
            let val = self.swiftBlogs[indexPath.row]
            let update = "DELETE FROM CHORES WHERE CHORENAME=\"\(val)\";"
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
            

            self.swiftBlogs.removeAtIndex(indexPath.row)
            
            // Take this line off while using database
            self.choresView.reloadData()
        }
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(swiftBlogs[row])
        
        // cells to view
        
        let vcName = identities[indexPath.row]
        if vcName=="Detail View Controller"{
        let viewController = storyboard?.instantiateViewControllerWithIdentifier(vcName) as! ChoreDetailViewController
        viewController.choreName = self.swiftBlogs[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
        self.navigationController!.navigationBar.translucent = false
        }else{
            let viewController = storyboard?.instantiateViewControllerWithIdentifier(vcName)
            self.navigationController?.pushViewController(viewController!, animated: true)
            self.navigationController!.navigationBar.translucent = false
        }
    }
    
    
    
    //BILLS
    
    
    
    
    
    
    
}

