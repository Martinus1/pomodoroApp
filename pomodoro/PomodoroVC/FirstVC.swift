//
//  FirstVC.swift
//  pomodoro
//
//  Created by Martin Michalko on 16/12/2017.
//  Copyright © 2017 Martin Michalko. All rights reserved.
//

import UIKit

    var timerOn = false
    var timerM = 30

class FirstVC: UIViewController {
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    var timer = Timer()
    var timeM = timerM
    var timeS = 0
    
    var totalTime: CGFloat!
    var currentTime: CGFloat! = 1
    var percentage: CGFloat! = 0
    var shapelayer: CAShapeLayer!
    
    var pulsatingLayer: CAShapeLayer!
    
    
    private func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 10
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.position = view.center
        return layer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.isHidden = true
        
        setupNotificationObservers()
        
        startBtn.layer.zPosition = 1
        timeLabel.layer.zPosition = 1
        resetButton.layer.zPosition = 1
        
        setupCircleLayers()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        
    }
    
    @objc func handleTap() {
        if startBtn.isHidden == false {
            return
        } else if timerOn == true {
            timerOn = false
            timer.invalidate()
        } else {
            timerOn = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerBlock) , userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    private func setupCircleLayers() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.5822720462))
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        let trackLayer = createCircleShapeLayer(strokeColor: #colorLiteral(red: 0.6276888251, green: 0.2580356002, blue: 0.01416406222, alpha: 1), fillColor: UIColor.clear)
        view.layer.addSublayer(trackLayer)
        
        
        shapelayer = createCircleShapeLayer(strokeColor: #colorLiteral(red: 0.9979166389, green: 0.5415845513, blue: 0.1036301628, alpha: 1), fillColor: UIColor.clear)
        shapelayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapelayer.strokeEnd = 0
        view.layer.addSublayer(shapelayer)
    }

    @IBAction func startBtnPressed(_ sender: Any) {
        timeM = timerM
        timeS = 0
        timeLabel.text = "\(timeM):" + "0\(timeS)"
        totalTime = CGFloat(timeM * 60)
        startBtn.isHidden = true
        timeLabel.isHidden = false
        timerOn = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerBlock) , userInfo: nil, repeats: true)
    }
    
    @objc private func timerBlock() {
        
        if timeM > 0 || timeS > 0 {
            if timeS > 0 {
                
                timeS -= 1

            }
            if timeS <= 0 {
                
                timeM -= 1
                timeS = 59
                print("newTIME")
            }
        } else {
            timer.invalidate()
            return
        }
        
        if timeM < 10 && timeS < 10{
            timeLabel.text = "0\(timeM):" + "0\(timeS)"
        } else if timeM > 9 && timeS > 9 {
            timeLabel.text = "\(timeM):" + "\(timeS)"
        } else if timeM > 9 && timeS < 10 {
            timeLabel.text = "\(timeM):" + "0\(timeS)"
        } else if timeM < 10 && timeS > 9 {
            timeLabel.text = "0\(timeM):" + "\(timeS)"
        }
        
        currentTime = CGFloat((timeM * 60) + timeS)
        print(currentTime)
        percentage = (totalTime - currentTime) / totalTime
        print(percentage)
        DispatchQueue.main.async {
            self.shapelayer.strokeEnd = self.percentage
        }
        
        
    }
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.4
        animation.duration = 0.6
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    fileprivate func AnimateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapelayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        timeM = timerM
        timeS = 0
        timeLabel.text = "\(timeM):" + "0\(timeS)"
        timer.invalidate()
        
        timeLabel.isHidden = true
        startBtn.isHidden = false
    }
    
}
