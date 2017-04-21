//
//  FirstViewController.swift
//  LaDesign
//
//  Created by kai on 2017/4/11.
//  Copyright © 2017年 kai. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController {

    @IBOutlet weak var CPUTemperature: UILabel!
    @IBOutlet weak var CPULoad: UILabel!
    @IBOutlet weak var CPULoadProgress: UIProgressView!
    @IBOutlet weak var GPUTemperature: UILabel!
    @IBOutlet weak var GPULoad: UILabel!
    @IBOutlet weak var GPULoadProgress: UIProgressView!
    @IBOutlet weak var RAM: UILabel!
    @IBOutlet weak var RAMProgress: UIProgressView!
    @IBOutlet weak var HD: UILabel!
    @IBOutlet weak var HDProgress: UIProgressView!
    var normalTemperature: Float = 50.0
    var highTemperature: Float = 60.0
    let normalLoad: UInt32 = 50
    let highLoad: UInt32 = 70
    var timer: Timer!
    var cpuTemp: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateNormalTemperature), userInfo: nil, repeats: true)
        
    }

    @IBAction func normalTemperatureMode(_ sender: UIButton) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateNormalTemperature), userInfo: nil, repeats: true)
    }
    
    @IBAction func HighTemperatureMode(_ sender: UIButton) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateHighTemperature), userInfo: nil, repeats: true)
    }
    
    
    func updateNormalTemperature(){
        cpuTemp = normalTemperature + Float(arc4random_uniform(10))/Float(10)
        //notify cpu temperature changed
        let noti = Notification(name: Notification.Name("CPUTemperature"), object: cpuTemp, userInfo: nil)
        NotificationCenter.default.post(noti)
        //change label
        CPUTemperature.text = String(cpuTemp) + "°C"
        GPUTemperature.text = String(normalTemperature + Float(arc4random_uniform(10))/Float(10)) + "°C"
        let cpuload = normalLoad + arc4random_uniform(5)
        let gpuload = normalLoad + arc4random_uniform(5)
        CPULoad.text = String(cpuload) + "%"
        GPULoad.text = String(gpuload) + "%"
        CPULoadProgress.setProgress(Float(cpuload)/100.0, animated: true)
        GPULoadProgress.setProgress(Float(gpuload)/100.0, animated: true)
        let ramload = normalLoad + arc4random_uniform(5)
        let hdload  = normalLoad + arc4random_uniform(5)
        RAM.text = String(ramload) + "%"
        HD.text = String(hdload) + "%"
        RAMProgress.setProgress(Float(ramload)/100.0, animated: true)
        HDProgress.setProgress(Float(hdload)/100.0, animated: true)

    }
    func updateHighTemperature(){
        cpuTemp = highTemperature + Float(arc4random_uniform(10))/Float(10)
        //notify cpu temperature changed
        let noti = Notification(name: Notification.Name("CPUTemperature"), object: cpuTemp, userInfo: nil)
        NotificationCenter.default.post(noti)
        //change label
        CPUTemperature.text = String(cpuTemp) + "°C"
        GPUTemperature.text = String(highTemperature + Float(arc4random_uniform(10))/Float(10)) + "°C"
        let cpuload = highLoad + arc4random_uniform(5)
        let gpuload = highLoad + arc4random_uniform(5)
        CPULoad.text = String(cpuload) + "%"
        GPULoad.text = String(gpuload) + "%"
        CPULoadProgress.setProgress(Float(cpuload)/100.0, animated: true)
        GPULoadProgress.setProgress(Float(gpuload)/100.0, animated: true)
        let ramload = highLoad + arc4random_uniform(5)
        let hdload  = highLoad + arc4random_uniform(5)
        RAM.text = String(ramload) + "%"
        HD.text = String(hdload) + "%"
        RAMProgress.setProgress(Float(ramload)/100.0, animated: true)
        HDProgress.setProgress(Float(hdload)/100.0, animated: true)

    }
    
}

