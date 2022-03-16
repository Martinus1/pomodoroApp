//
//  SettingsVC.swift
//  pomodoro
//
//  Created by Martin Michalko on 17/12/2017.
//  Copyright © 2017 Martin Michalko. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var timeInfoLbl: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    let timeSave = "timeSave"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let timeSave = UserDefaults.standard.value(forKey: timeSave) {
            slider.value = timeSave as! Float
        }
        
        timeInfoLbl.text = "\(Int(slider.value*10))"
    }
    
    @IBAction func changeTimeValue(_ sender: UISlider) {
        slider.value = roundf(slider.value)
        timeInfoLbl.text = "\(Int(slider.value*10))"
        timerM = Int(timeInfoLbl.text!)!
        
        UserDefaults.standard.set(sender.value, forKey: timeSave)
    }
    
    
}
