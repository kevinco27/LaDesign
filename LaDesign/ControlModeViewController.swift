//
//  FirstViewController.swift
//  LaDesign
//
//  Created by kai on 2017/4/11.
//  Copyright © 2017年 kai. All rights reserved.
//

import UIKit

class ControlModeViewController: UIViewController {
    
    var temperature: Float = 0.0
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var TempBallView: UIView!
    @IBOutlet weak var fan: UIImageView!
    var timer: Timer!
    var currentState: Int!
    var previousState: Int!
    var modeState: String!
    var coolingRate: Float!
    var heatingRate: Float!
    var caseTemp: Float!
    var CPUTemp: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(changeCPUTemp(_:)), name: NSNotification.Name("CPUTemperature"), object: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setTemperBall), userInfo: nil, repeats: true)
        
        //先讓風扇轉
        modeState = "S"
        fanRotating(status: "S")
        
        //初始化溫度
        caseTemp = 30
        heatingRate = 0.2
        coolingRate = 0.3
        
    }
    
    func fanRotating(status:String){
        
        switch status {
                        //慢風扇
        case "S":
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = CGFloat(0.0)
            rotationAnimation.toValue = CGFloat.pi * 2.0
            rotationAnimation.duration = 2.0
            rotationAnimation.repeatCount = Float.infinity
            self.fan.layer.add(rotationAnimation, forKey: nil)
            print("慢風扇開始轉")
            break
                        //中風扇
        case "Q":
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = CGFloat(0.0)
            rotationAnimation.toValue = CGFloat.pi * 2.0
            rotationAnimation.duration = 1.0
            rotationAnimation.repeatCount = Float.infinity
            self.fan.layer.add(rotationAnimation, forKey: nil)
            print("中風扇開始轉")
            break
                        //快風扇
        case "P":
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = CGFloat(0.0)
            rotationAnimation.toValue = CGFloat.pi * 2.0
            rotationAnimation.duration = 0.5
            rotationAnimation.repeatCount = Float.infinity
            self.fan.layer.add(rotationAnimation, forKey: nil)
            print("快風扇開始轉")
        default:
            break
        }
    }
    
    func changeCPUTemp(_ notification:Notification){
        CPUTemp = notification.object as! Float
    }
    
    func setTemperBall(){
        
        //溫度上升率
        if(Int(CPUTemp) == 50){
            heatingRate = 0.2
        }else if(Int(CPUTemp) == 60){
            heatingRate = 0.7
        }
        
        //溫度下降率
        switch modeState {
        case "S":
            coolingRate = 0.25
            break
        case "Q":
            coolingRate = 0.5
            break
        case "P":
            coolingRate = 1.2
            break
        default:
            break
        }
        
        //溫度到上限後不再上升
        if caseTemp>Float((Int(CPUTemp)-20+7)) && heatingRate - 0.2 < 0.000001{
            heatingRate = 0.0
        }else if caseTemp>(Float(Int(CPUTemp)-20+13)) && heatingRate - 0.7 < 0.000001{
            heatingRate = 0.0
        }
        
        //溫度到下限不在下降
        if caseTemp<Float((Int(CPUTemp)-20-4)) && coolingRate - 0.25 < 0.000001{
            coolingRate = 0.0
        }else if caseTemp<Float((Int(CPUTemp)-20-7)) && coolingRate - 0.5 < 0.000001{
            coolingRate = 0.0
        }else if caseTemp<Float((Int(CPUTemp)-20-10)) && coolingRate - 1.2 < 0.000001{
            coolingRate = 0.0
        }
        
        caseTemp = caseTemp + heatingRate - coolingRate
        print("h = \(heatingRate)  c = \(coolingRate)")
        print("lower = \(Float((Int(CPUTemp)-20-10)))   tmep = \(caseTemp)")
        tempLabel.text = String(format: "%.1f",caseTemp)
            UIView.animate(withDuration: 0.5, animations: {
                self.TempBallView.center.x = CGFloat(22.0) + CGFloat(338/40*(self.caseTemp-20))
            })
        }
    
    @IBAction func SMode(_ sender: UIButton) {
        modeState = "S"
        fanRotating(status: modeState)
    }
    @IBAction func QMode(_ sender: UIButton) {
        modeState = "Q"
        fanRotating(status: modeState)
    }
    @IBAction func PMode(_ sender: UIButton) {
        modeState = "P"
        fanRotating(status: modeState)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if modeState != nil{
            fanRotating(status: modeState)
        }else{
            fanRotating(status: "S")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.fan.stopAnimating()
        print("fan stop")
    }

    
}

