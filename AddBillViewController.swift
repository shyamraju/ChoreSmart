//
//  AddBillViewController.swift
//  ChoreSmart
//
//  Created by Jelly Vora on 4/2/16.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit

class AddBillViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate   {
    @IBOutlet var paidBy: UITextField!
    
    @IBOutlet var text1: UITextField!
    
    @IBOutlet var text2: UITextField!
    
    
    func dataFilePath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory = paths[0] as NSString
        
        return documentsDirectory.stringByAppendingPathComponent("data.sqlite") as String
        
    }
    
    
    
    @IBOutlet var memberView: UITableView!
    
    var pickOption = ["One"]
    @IBAction func saveBill(sender: AnyObject) {
        //Open db
        var database:COpaquePointer = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK{
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        var statement:COpaquePointer = nil
        let billName=self.text1.text!
        let amount:Double! = Double(self.text2.text!)
        let share = amount/Double(myarray.count)
        for name in myarray{
            var update9 = "INSERT INTO BILL (BILL_DESCRIPTION, AMOUNT,GROUP_ID, PAID_BY,MEMBER_NAME,SHARE,ENTRY_DATE)" +
                "VALUES (\"\(billName)\",\(amount),\(groupID),\"\(paidBy.text!)\",\"\(name)\",\(share),\"\(dateSelected)\");"
            
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
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        paidBy.resignFirstResponder()
        
    }
    
    @IBOutlet var BillStatus: UILabel!
    
    
    @IBAction func didEndEdit(sender: AnyObject) {
        print("EditDidEnd")
        if ((text1.text) == "Food"){
            imageView.image = UIImage(named:"food_icon.png")
            //self.view.addSubview(imageView)
        }
        
        if ((text1.text) == "Fuel"){
            imageView.image = UIImage(named:"fuel_icon.png")
        }
        
        if ((text1.text) == "Grocery"){
            imageView.image = UIImage(named:"grocery_icon.png")
        }
        
        if ((text1.text) == "Rent"){
            imageView.image = UIImage(named:"homerent_icon.png")
        }
        
    }
    
    
    @IBOutlet var imageView : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView  = UIImageView(frame:CGRectMake(30, 140, 70, 70));
        imageView.image = UIImage(named:"Chores.png")
        self.view.addSubview(imageView)
        //text1.addTarget(self, action: Selector("editDidEnd"), forControlEvents: UIControlEvents.EditingDidEnd)
        
        
        memberView.delegate = self
        memberView.dataSource = self
        self.memberView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.memberView.dataSource = self
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        paidBy.inputView = pickerView
        
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
                pickOption.insert(memName!, atIndex: pickOption.count)
                swiftBlogs.insert(memName!, atIndex: swiftBlogs.count)
                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        pickOption.removeFirst()
        swiftBlogs.removeFirst()
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        paidBy.text = pickOption[row]
        self.view.endEditing(true) //to dismiss picker after a row is selected
    }
    
    @IBAction func backgroundTap(sender:UIControl)
    {
        //paidBy.resignFirstResponder()
        text1.resignFirstResponder()
        text2.resignFirstResponder()
        
    }
    
    @IBAction func DoneButton(sender: AnyObject) {
        sender.resignFirstResponder()
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
    
    var swiftBlogs = ["Ray Wenderlich"]
    let textCellIdentifier = "Chores"
    var myarray = [String]()
    
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
        cell.imageView?.image = UIImage(named: swiftBlogs[indexPath.row])
        
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
    
    @IBOutlet var addedMembers: UITextView!
    
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //let row = indexPath.row
        //print(swiftBlogs[row])
        
        
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
        if(myarray.count>0){
            let stringRepresentation = myarray.joinWithSeparator(", ")
            //addedMembers.text = String(UTF8String: stringRepresentation)!
        }
    }
    
    
    
}
