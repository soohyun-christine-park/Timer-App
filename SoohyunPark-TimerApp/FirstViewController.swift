//
//  FirstViewController.swift
//  SoohyunPark-TimerApp
//
//  Created by Soohyun Christine Park on 2015. 2. 23..
//  Copyright (c) 2015년 SP. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    var state: Int = 0
    // state
    // 0: stop
    // 1: counting
    // 2: paused
    
    var myTimer = NSTimer()
    var inMinute: Int = 0
    var inSecond: Int = 0
    var myTime: Int = 0
    var inputedTime: Int = 0
    
    var player : AVAudioPlayer! = nil
    var playing = NSTimer()
    var startPoint = 0.0
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!

    @IBOutlet weak var start_stop_Button: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        start_stop_Button.layer.cornerRadius = start_stop_Button.bounds.size.height //45
        start_stop_Button.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        
        pauseButton.layer.cornerRadius = pauseButton.bounds.size.height
        pauseButton.layer.opacity = 0.4
        pauseButton.enabled = false
        
        timePicker.layer.opacity = 1.0
        minLabel.layer.opacity = 1.0
        secLabel.layer.opacity = 1.0
        countLabel.layer.opacity = 0.0
        
        countLabel.text = "00:00"
        
    }
    
    
    
    
    @IBAction func buttonPressed(sender: UIButton) {
        
        switch sender.titleLabel?.text as String! {
        case "Start":
            inMinute = timePicker.selectedRowInComponent(0)
            inSecond = timePicker.selectedRowInComponent(1)
            inputedTime = inMinute * 60 + inSecond    // total time in seconds.
            
            myTime = inputedTime
            
            if myTime != 0 {
            
                timer(1)
                
                timePicker.layer.opacity = 0.0
                minLabel.layer.opacity = 0.0
                secLabel.layer.opacity = 0.0
                countLabel.layer.opacity = 1.0
                
                start_stop_Button.setTitle("Cancel", forState: UIControlState.Normal)
                start_stop_Button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                pauseButton.layer.opacity = 1
                pauseButton.enabled = true
            
            }
            
            break
            
        case "Cancel":
            timer(0)
            
            break
            
        case "Pause":
                timer(2)
                pauseButton.setTitle("Resume", forState: UIControlState.Normal)

            break
            
        case "Resume":
            timer(1)
            pauseButton.setTitle("Pause", forState: UIControlState.Normal)
            break
            
        default: break
        }
        
        
    }
    
    
    func timer(state:Int){
        
        switch state {
        case 0:
            myTimer.invalidate()
            progressBar.progress = 1.0
            player.stop()
            
            timePicker.selectRow(0,inComponent: 0, animated: true)
            timePicker.selectRow(0,inComponent: 1, animated: true)
 
            timePicker.layer.opacity = 1.0
            minLabel.layer.opacity = 1.0
            secLabel.layer.opacity = 1.0
            countLabel.layer.opacity = 0.0
            
            countLabel.text = "00:00"
            
            start_stop_Button.setTitle("Start", forState: UIControlState.Normal)
            start_stop_Button.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
            if pauseButton.titleLabel?.text as String! == "Resume" {
                pauseButton.setTitle("Pause", forState: UIControlState.Normal)
            }
            pauseButton.layer.opacity = 0.4
            pauseButton.enabled = false
            
            break
            
        case 1:
            countLabel.text = String(format:"%02d:%02d", myTime/60, myTime%60)
            myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)
            
            break
            
        case 2:
            myTimer.invalidate()
            break
            
        default:break
            
        }
        
    }
    
    func playAlarm() {
        
        let path = NSBundle.mainBundle().pathForResource("Sound/VideoKids-DoTheRap", ofType:"wav")
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        
        player.prepareToPlay()
        player.play()
        println(player.duration)
        playing = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("playerDidFinishPlaying"), userInfo: nil, repeats: true)

    }
    
    func playerDidFinishPlaying() {
        
        startPoint = startPoint+1
        
        if player.duration - startPoint <= 0 {
            timer(0)
            playing.invalidate()
            startPoint = 0
        }
    }
    
    
    func countDown(){
        myTime = myTime - 1
        
        countLabel.text = String(format:"%02d:%02d", myTime/60, myTime%60)
        
        progressBar.progress = progressBar.progress - 1.0/Float(inputedTime)
        println("\(myTime)")
        
        if myTime == 0 {
            myTimer.invalidate()
            progressBar.progress = 0
            
            pauseButton.layer.opacity = 0.4
            pauseButton.enabled = false
            
            playAlarm()
        }
        
    }
    
    
    
    
    
    let timeArray = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeArray.count
    }
    

    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = timeArray[row]
        var myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.blackColor()])
        return myTitle
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

