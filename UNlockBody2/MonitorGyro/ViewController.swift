//
//  ViewController.swift
//  MonitorGyro
//
//  Created by Dreamy Sun on 2/10/19.
//  Copyright © 2019 ChenyuSun. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController ,UIAccelerometerDelegate{

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var time: UIProgressView!
    @IBOutlet var bgImage: UIImageView!
 
    var indexProgressBar = 30
    let imageArr = ["print-yoga.gif","2.svg"]
    
    //运动管理器
    let motionManager = CMMotionManager()
    
    
    //刷新时间间隔
    var timecount = 1
    let timeInterval: TimeInterval = 0.5
    var unlock = false
    var resetCount = 0
    var i = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.time.isHidden = true
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        resetScreen()
        self.time.isHidden = false
        startButton.setTitle("Reset", for: .normal)
        
        
        resetCount = resetCount + 1
        
        if resetCount == 2 {
        let text2 = "Try Again 2"
        self.time.isHidden = true
        self.textView.text = text2
        } else if resetCount == 4 {
        let text6 = "Fail"
        self.textView.text = text6
        startButton.isHidden = true
        self.time.isHidden = true
        } else if resetCount == 3 {
        let text4 = "Try Again 1"
        self.textView.text = text4
        self.time.isHidden = true
        }
        
    }
    
    

    func startUpdates() {
        if motionManager.isAccelerometerAvailable {
          
        self.motionManager.accelerometerUpdateInterval = self.timeInterval
                
        //
            let queue = OperationQueue.current
            self.motionManager.startAccelerometerUpdates(to: queue!, withHandler: {
                (accelerometerData, error) in
            guard error == nil else {
                print(error!)
                return
            }
          
                self.timecount += 1
                var stop = false
                func resetBar(){
                   
                    if stop == false{
                   
                    self.i += 1
                    }
                    if self.i >= 30 {stop = true; self.i = 31}
                    
                    let max = 30
                    // Compute ratio of 0 to 1 for progress.
                    let ratio = Float(self.i) / Float(max)
                    self.time.progress = Float(ratio)
                    
                    // Write message.
                    // self.textView.text = "Processing \(self.i) of \(max)..."
                }
                resetBar()
                stop = false
              
                
        
            if self.motionManager.isAccelerometerActive {
                
                if let rotationRate = accelerometerData?.acceleration {
//                    var text5 = "---当前陀螺仪数据---\n"
//                    text5 += "x: \(rotationRate.x)\n"
//                    text5 += "y: \(rotationRate.y)\n"
//                    text5 += "z: \(rotationRate.z)\n"
//                    self.textView.text = text5
                    
                      if rotationRate.x >= 0.7 && rotationRate.y >= -0.4 && rotationRate.z >= 0.1 && self.timecount >= 10 {
             
                        let text = "UNLOCKED!"
                        self.textView.text = text
                        self.unlock = true
                        self.time.isHidden = true
                        self.startButton.isHidden = true
                        
                     
                    } else if self.unlock == false && self.timecount == 30 {
                      let text5 = "Fail! Try Again"
                        self.textView.text = text5
                        self.time.isHidden = true
                    }
                    
                }
                
                
               
            }
                
            
        })
    }
    }
    
    
    
    
  


    func resetScreen() {
        startUpdates()
        textView.text = " "
        timecount = 1
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


