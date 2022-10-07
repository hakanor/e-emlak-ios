//
//  LoginPasswordViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 7.10.2022.
//

import UIKit

class LoginPasswordViewController: UIViewController {
    
//    MARK: - Subviews
    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "loginBg")
        backgroundImage.image = image
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        return backgroundImage
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.backgroundColor = themeColors.white
        return containerView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = themeColors.dark
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.text = "Welcome Back"
        return titleLabel
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textColor = themeColors.grey
        subtitleLabel.numberOfLines = 2
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.text = "Enter your password"
        return subtitleLabel
    }()
    
    private lazy var textFieldLabel: UILabel = {
        let textFieldLabel = UILabel()
        textFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldLabel.textColor = themeColors.dark
        textFieldLabel.numberOfLines = 2
        textFieldLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        textFieldLabel.text = "PASSWORD"
        return textFieldLabel
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "example@example.com",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.rightImage(UIImage(systemName: "eye.fill"), imageWidth: 36, padding: 0, tintColor: themeColors.grey)
//        textField.addTarget(self, action: #selector(searchFunc), for: .editingDidEndOnExit)
        return textField
       }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "or"
        return label
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.setTitle("Forgot password", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.dark, for: .normal)
        button.backgroundColor = themeColors.white
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = themeColors.grey.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "By signing in you agree to our Terms of Service"
        let text = "By signing in you agree to our"
        let termsText = "Terms of Service"
        let stringValue = text + " " + termsText
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColorForText(textForAttribute: text , withColor: themeColors.grey)
        attributedString.setColorForText(textForAttribute: termsText , withColor: themeColors.primary)
        attributedString.setColorForText(textForAttribute:  "°", withColor: .systemBlue)
        label.attributedText = attributedString
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = themeColors.white
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        [backgroundImage, containerView] .forEach(view.addSubview(_:))
        
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
        
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        [titleLabel , subtitleLabel, textFieldLabel, textField, nextButton, orLabel, createAccountButton, termsLabel] .forEach(containerView.addSubview(_:))
 
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 40).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 8).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        textFieldLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor,constant: 24).isActive = true
        textFieldLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        textFieldLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        textField.topAnchor.constraint(equalTo: textFieldLabel.bottomAnchor,constant: 8).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true

        nextButton.topAnchor.constraint(equalTo: textField.bottomAnchor,constant: 24).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        orLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor,constant: 8).isActive = true
        orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        createAccountButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor,constant: 8).isActive = true
        createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        termsLabel.bottomAnchor.constraint(equalTo: createAccountButton.bottomAnchor,constant: 52).isActive = true
        termsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }

    
}


