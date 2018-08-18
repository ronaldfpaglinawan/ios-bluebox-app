//
//  Utility.swift
//  Blue Box
//
//  Created by Ronald F. Paglinawan on 29/08/2016.
//  Copyright © 2016 Harrison Grierson. All rights reserved.
//

import UIKit

open class Utility: NSObject {
    // MARK: - UIColor
    func UIColorFromHex(_ rgbValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    // MARK: - RoundedButton
    func setRoundedButton(_ sender: AnyObject, radius: Float, borderWidth: Float, borderColor color: UIColor)
    {
        let layer: CALayer = sender.layer
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)
        layer.borderWidth = CGFloat(borderWidth)
        layer.borderColor = color.cgColor
    }
}
