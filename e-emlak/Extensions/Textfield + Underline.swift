//
//  Textfield + Underline.swift
//  e-emlak
//
//  Created by Hakan Or on 7.10.2022.
//

import Foundation
import UIKit

//extension UITextField {
//    func setUnderLine() {
//        let bottomLayer = CALayer()
//        bottomLayer.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
//        bottomLayer.backgroundColor = UIColor.black.cgColor
//        self.layer.addSublayer(bottomLayer)
//    }
//}

extension UITextField {

    func setUnderLine() {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width - 10, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

}
