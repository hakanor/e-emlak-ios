//
//  RegisterStep1ViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 8.10.2022.
//

import UIKit

class RegisterEmailPassViewController: UIViewController {
    
//    MARK: - Subviews
    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "registerBg")
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
        titleLabel.text = "Create new account"
        return titleLabel
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textColor = themeColors.grey
        subtitleLabel.numberOfLines = 2
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.text = "Fill these form and jump to next step"
        return subtitleLabel
    }()
    
    private lazy var emailLabel: UILabel = {
        let textFieldLabel = UILabel()
        textFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldLabel.textColor = themeColors.dark
        textFieldLabel.numberOfLines = 2
        textFieldLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        textFieldLabel.text = "EMAIL"
        return textFieldLabel
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "example@example.com",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.rightImage(UIImage(systemName: "checkmark.circle"), imageWidth: 36, padding: 0, tintColor: themeColors.success)
//        textField.addTarget(self, action: #selector(searchFunc), for: .editingDidEndOnExit)
        return textField
       }()
    
    
    private lazy var passwordLabel: UILabel = {
        let textFieldLabel = UILabel()
        textFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldLabel.textColor = themeColors.dark
        textFieldLabel.numberOfLines = 2
        textFieldLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        textFieldLabel.text = "PASSWORD"
        return textFieldLabel
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.rightImage(UIImage(systemName: "eye.fill"), imageWidth: 36, padding: 0, tintColor: themeColors.grey)
//        textField.addTarget(self, action: #selector(searchFunc), for: .editingDidEndOnExit)
        return textField
       }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.setTitle("Next step", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = themeColors.white
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        [backgroundImage, containerView] .forEach(view.addSubview(_:))
        
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.85).isActive = true
        
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.35).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        [titleLabel , subtitleLabel, emailLabel, emailTextField, passwordLabel, passwordTextField, nextButton] .forEach(containerView.addSubview(_:))
 
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 40).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 8).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor,constant: 24).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor,constant: 8).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true

        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,constant: 24).isActive = true
        passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor,constant: 8).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        nextButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 24).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
    }

    
}




