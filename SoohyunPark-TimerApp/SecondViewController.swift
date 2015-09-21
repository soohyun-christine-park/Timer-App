//
//  SecondViewController.swift
//  SoohyunPark-TimerApp
//
//  Created by Soohyun Christine Park on 2015. 2. 23..
//  Copyright (c) 2015년 SP. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var state: Int = 0
    // state
    // 0: stop
    // 1: counting
    // 2: paused
    
    var myTimer = NSTimer()
    var myMinute: Int = 0
    var mySecond: Int = 0
    var myTime: Int = 0
    
    var tableData = [String]()
    var count = 1
    
    @IBOutlet var tableView: UITableView!
   
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var start_stop_Button: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    @IBOutlet weak var lapLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        start_stop_Button.layer.cornerRadius = start_stop_Button.bounds.size.height //45
        start_stop_Button.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        
        lapButton.layer.cornerRadius = lapButton.bounds.size.height
        lapButton.layer.opacity = 0.4
        lapButton.enabled = false
        
        countLabel.text = "00:00.00"
        lapLabel.text = "00:00.00"
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        
        switch sender.titleLabel?.text as String! {
        case "Start":
            timer(1)
            
            start_stop_Button.setTitle("Stop", forState: UIControlState.Normal)
            start_stop_Button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            lapButton.layer.opacity = 1
            lapButton.enabled = true
            
            break
            
        case "Stop":
            start_stop_Button.setTitle("Start", forState: UIControlState.Normal)
            start_stop_Button.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
            lapButton.setTitle("Reset", forState: UIControlState.Normal)
            timer(2)
            break
            
        case "Lap":
            self.tableData.append("Lap \(count) : \(countLabel.text!)")
            self.tableView.reloadData()
            count = count+1
            lapLabel.text = countLabel.text!
            break
            
        case "Reset":
            timer(0)
            myTime = 0
            count = 1
            self.tableData.removeAll(keepCapacity: true)
            self.tableView.reloadData()
            lapButton.setTitle("Lap", forState: UIControlState.Normal)
            break
            
        default: break
        }
        
        
    }
    
    func timer(state:Int){
        
        switch state {
        case 0:
            myTimer.invalidate()
            
            countLabel.text = "00:00.00"
            lapLabel.text = countLabel.text!
            
            start_stop_Button.setTitle("Start", forState: UIControlState.Normal)
            start_stop_Button.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
            if lapButton.titleLabel?.text as String! == "Reset" {
                lapButton.setTitle("Lap", forState: UIControlState.Normal)
            }
            lapButton.layer.opacity = 0.4
            lapButton.enabled = false
            
            break
            
        case 1:
            myTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)
            
            break
            
        case 2:
            myTimer.invalidate()
            break
            
        default:break
            
        }
        
    }
    
    func countDown(){
        myTime = myTime + 1
        
        countLabel.text = String(format:"%02d:%02d.%02d", myTime/6000, (myTime/100)%60, myTime % 100)
        
    }
    
    func  numberOfComponentsInPickerView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.tableData[indexPath.row]
        cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
//        cell.textLabel?.adjustsFontSizeToFitWidth = true;
        cell.textLabel?.font = UIFont.systemFontOfSize(13.0)
        cell.textLabel?.textAlignment = .Right
        cell.textLabel?.textColor = UIColor.grayColor()
        
        cell.detailTextLabel?.text = "Lap"
        
        return cell
    }
    
    func tableView(tableView: UITableView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = tableData[row]
        var myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.redColor()])
        return myTitle
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


