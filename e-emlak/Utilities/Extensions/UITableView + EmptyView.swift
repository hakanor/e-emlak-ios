//
//  UITableView + EmptyView.swift
//  e-emlak
//
//  Created by Hakan Or on 7.11.2022.
//

import Foundation
import UIKit

extension UITableView {
    
    func setEmptyView(title: String, message: String, messageImage: UIImage) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        lazy var messageImageView: UIImageView = {
            let messageImageView = UIImageView()
            messageImageView.translatesAutoresizingMaskIntoConstraints = false
            messageImageView.backgroundColor = .clear
            messageImageView.contentMode = .scaleAspectFit
            messageImageView.image = messageImage
            return messageImageView
        }()
        
        lazy var titleLabel: UILabel = {
            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            titleLabel.textColor = themeColors.dark
            titleLabel.numberOfLines = 2
            titleLabel.text = title
            titleLabel.textAlignment = .center
            return titleLabel
        }()
        
        lazy var messageLabel: UILabel = {
            let messageLabel = UILabel()
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            messageLabel.textColor = themeColors.grey
            messageLabel.numberOfLines = 2
            messageLabel.text = message
            messageLabel.textAlignment = .center
            return messageLabel
        }()
 
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -50).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor).isActive = true
        
        UIView.animate(withDuration: 1, animations: {
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
