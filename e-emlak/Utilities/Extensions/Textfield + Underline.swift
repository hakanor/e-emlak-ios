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
        let dividerView = UIView()
        dividerView.backgroundColor = themeColors.lightGrey
        self.addSubview(dividerView)
        dividerView.anchor(top : self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 5, height: 1)
    }

}
