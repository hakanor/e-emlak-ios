//
//  ProfileCustomButton.swift
//  e-emlak
//
//  Created by Hakan Or on 19.12.2022.
//

import Foundation
import UIKit
import CoreData

class ProfileCustomButton: UIButton {
    
    // MARK: - Properties
    private let cornerRadiusValue : CGFloat = 16
    
    // MARK: - Subviews
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var leftIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "location-sign")?.withTintColor(themeColors.dark)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(hexString: "#EBEBF3")
        imageView.layer.cornerRadius = self.cornerRadiusValue
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.dark
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "Browse"
        label.contentMode = .scaleToFill
        label.numberOfLines = 2
        return label
    }()

    private lazy var rightIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "chevron.forward")?.withTintColor(themeColors.white).withInset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = themeColors.primary
        imageView.layer.cornerRadius = self.cornerRadiusValue
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    init(leftIconName: String, text: String, target: Any, action: Selector) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(hexString: "#F2F2F3")
        
        self.layer.cornerRadius = self.cornerRadiusValue
        
        self.addSubview(containerView)

        containerView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0)
        
        [leftIcon, textLabel, rightIcon] .forEach(containerView.addSubview(_:))
        
        leftIcon.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        textLabel.anchor(left: leftIcon.rightAnchor, right: rightIcon.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 5)
        
        textLabel.centerYAnchor.constraint(equalTo: leftIcon.centerYAnchor).isActive = true
        
        rightIcon.anchor(top: containerView.topAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor ,paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 32, height: 32)
        
        textLabel.text = text
        
        leftIcon.image = UIImage(systemName: leftIconName)?.withTintColor(themeColors.dark).withInset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        
        addTarget(target, action: action, for: .touchUpInside)
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Layout
        
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
