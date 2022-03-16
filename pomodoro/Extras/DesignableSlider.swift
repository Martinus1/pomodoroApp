//
//  DesignableSlider.swift
//  pomodoro
//
//  Created by Martin Michalko on 17/12/2017.
//  Copyright © 2017 Martin Michalko. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableSlider: UISlider {

    @IBInspectable var thumbImage: UIImage? {
        didSet {
            setThumbImage(thumbImage, for: .normal)
        }
    }

}
