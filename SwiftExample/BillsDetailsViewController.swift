//
//  BillsDetailsViewController.swift
//  ChoreSmart
//
//  Created by Judith Vijey on 4/8/16.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit

class BillsDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var memberOwes: UITableView!
    
    var members = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        members = ["Judith","Jelly","Shyam"]
        
        
        // Do any additional setup after loading the view.
        
        
                   }
    
   

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell?.textLabel!.text = self.members[indexPath.row]
        
        
        //labels to show amount
        var billAmt = [String]()
        billAmt = ["$ 20", "$ 20", "$ 20"]
        
        let billLabel = UILabel(frame: CGRectMake(300.0, 15.0, 300.0, 15.0))
        billLabel.text = billAmt[indexPath.row]
        billLabel.tag = 1
        billLabel.font = UIFont(name: "Calibri", size: 17.0)
        billLabel.textColor = UIColor.blackColor()
        
        //label to display "owes"
        let string = "owes"
        let owesLabel = UILabel(frame: CGRectMake(200.0, 15.0, 200.0, 15.0))
        owesLabel.text = string
        owesLabel.tag = 2
        owesLabel.font = UIFont(name: "Calibri", size: 20.0)
        owesLabel.textColor = UIColor.darkGrayColor()
        
        cell!.addSubview(billLabel)
        cell!.addSubview(owesLabel)

        
        return cell!
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
