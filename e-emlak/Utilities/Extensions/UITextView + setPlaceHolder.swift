//
//  UITextView + setPlaceHolder.swift
//  e-emlak
//
//  Created by Hakan Or on 24.10.2022.
//

import Foundation
import UIKit

extension UITextView{

    func setPlaceholder(placeholder:String) {

        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = themeColors.grey.withAlphaComponent(0.6)
        placeholderLabel.isHidden = !self.text.isEmpty

        self.addSubview(placeholderLabel)
    }

    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }

}
