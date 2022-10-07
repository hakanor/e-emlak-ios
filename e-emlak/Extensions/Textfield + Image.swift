//
//  Textfield + Image.swift
//  e-emlak
//
//  Created by Hakan Or on 7.10.2022.
//

import Foundation
import UIKit

extension UITextField {
    func leftImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .center
        imageView.tintColor = .black
        imageView.alpha = 0.5
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        leftView = containerView
        leftViewMode = .always
    }
    
    func rightImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat, tintColor: UIColor) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .center
        imageView.tintColor = tintColor
        imageView.alpha = 1
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        rightView = containerView
        rightViewMode = .always
    }
    
    func rightView(_ view: UIView?, width: CGFloat, padding: CGFloat, tapGesture:UITapGestureRecognizer) {
        guard let view = view else { return }

        view.frame = CGRect(x: 0 , y: 0, width: width, height: frame.height)
        view.alpha = 0.5
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: width + 2 * padding, height: frame.height))
        containerView.addSubview(view)
        containerView.addGestureRecognizer(tapGesture)
        
        rightView = containerView
        rightViewMode = .always
    }
}
