//
//  ResetPasswordViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 13.10.2022.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    // MARK: - Subviews
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "arrow.left")
        button.tintColor = themeColors.white
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "resetBg")
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
        titleLabel.text = "Şifreni mi unuttun?"
        return titleLabel
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Şifrenizı sıfırlamak için lütfen kayıtlı e-mail adresinizi girin."
        return label
    }()
    
    private lazy var textFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "EMAIL"
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.attributedPlaceholder = NSAttributedString(
            string: "example@example.com",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.addTarget(self, action: #selector(handleEmailTextField), for: .allEditingEvents)
        textField.setUnderLine()
        return textField
       }()
    
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Şifremi Sıfırla", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleResetPasswordButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
           
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = themeColors.white
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        
        [backgroundImage, containerView, backButton] .forEach(view.addSubview(_:))
        
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
        
        containerView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.60).isActive = true
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 20, width: 24, height: 24)
        
        [titleLabel , subtitleLabel, textFieldLabel, textField, resetPasswordButton] .forEach(containerView.addSubview(_:))
 
        titleLabel.anchor(top: containerView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 24, paddingRight: 24)

        subtitleLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        textFieldLabel.anchor(top: subtitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        textField.anchor(top: textFieldLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        resetPasswordButton.anchor(top: textField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 40, paddingLeft: 24, paddingRight: 24)
    }
    // MARK: - Helpers
    func isValidEmail(tf: UITextField){
        if tf.text!.isValidEmail() {
            tf.rightImage(UIImage(systemName: "checkmark.circle"), imageWidth: 40, padding: 0, tintColor: themeColors.success)
        } else {
            tf.rightImage(UIImage(systemName: "x.circle"), imageWidth: 40, padding: 0, tintColor: themeColors.error)
        }
    }
    
    // MARK: - Selectors
    @objc func handleResetPasswordButton(){
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        print("Şifre sıfırlandı")
    }
    
    @objc func handleEmailTextField(){
        isValidEmail(tf: textField)
    }
    
    @objc func handleBackButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
}
