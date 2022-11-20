//
//  LoginViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 7.10.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Subviews
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
        titleLabel.text = "e-emlak'a Hoşgeldin"
        return titleLabel
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Giriş yapmak için lütfen e-mail ve şifrenizi girin."
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
    
    private lazy var passLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "ŞİFRE"
        return label
    }()
    
    private lazy var passTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "password",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        let eyeImage = UIImage(systemName: "eye.fill")?.withTintColor(themeColors.grey)
        let eyeImageView = UIImageView(image: eyeImage)
        eyeImageView.contentMode = .center
        eyeImageView.tintColor = .black
        eyeImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(showPassword(_:)))
        textField.rightView(eyeImageView, width: 24, padding: 4 , tapGesture:tapGesture)
        
        return textField
       }()
    
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Şifreni mi unuttun", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.primary, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleResetPasswordButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Giriş Yap", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "veya"
        return label
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Hesap Oluştur", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.dark, for: .normal)
        button.backgroundColor = themeColors.white
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = themeColors.grey.cgColor
        button.addTarget(self, action: #selector(handleCreateAccountButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Kayıt ol düğmesine tıklayarak, Koşullarımızı kabul etmiş olursunuz."
        let text = "Kayıt ol düğmesine tıklayarak,"
        let termsText = "Koşullarımızı"
        let text2 = "kabul etmiş olursunuz."
        let stringValue = text + " " + termsText + " " + text2
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColorForText(textForAttribute: text , withColor: themeColors.grey)
        attributedString.setColorForText(textForAttribute: termsText , withColor: themeColors.primary)
        attributedString.setColorForText(textForAttribute: text2 , withColor: themeColors.grey)
        label.attributedText = attributedString
        return label
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = themeColors.white
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        [backgroundImage, containerView] .forEach(view.addSubview(_:))
        
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
        
        containerView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.60).isActive = true
        
        [titleLabel , subtitleLabel, textFieldLabel, textField, passLabel, passTextField, resetPasswordButton, nextButton, orLabel, createAccountButton, termsLabel] .forEach(containerView.addSubview(_:))
 
        titleLabel.anchor(top: containerView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 24, paddingRight: 24)

        subtitleLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        textFieldLabel.anchor(top: subtitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        textField.anchor(top: textFieldLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        passLabel.anchor(top: textField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        passTextField.anchor(top: passLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        resetPasswordButton.anchor(top: passTextField.bottomAnchor,  paddingTop: 18)
        resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        nextButton.anchor(top: resetPasswordButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingRight: 24)
        
        orLabel.anchor(top: nextButton.bottomAnchor,paddingTop: 8)
        orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        createAccountButton.anchor(top: orLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        termsLabel.anchor(top: createAccountButton.bottomAnchor,left: view.leftAnchor, right:view.rightAnchor, paddingTop: 46, paddingLeft: 8, paddingRight: 8)
        termsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // MARK: - Helpers
    func isValidEmail(tf: UITextField){
        if tf.text!.isValidEmail() {
            tf.rightImage(UIImage(systemName: "checkmark.circle"), imageWidth: 40, padding: 0, tintColor: themeColors.success)
        } else {
            tf.rightImage(UIImage(systemName: "x.circle"), imageWidth: 40, padding: 0, tintColor: themeColors.error)
        }
    }
    
    func togglePassword(tf:UITextField){
        if tf.isSecureTextEntry {
            tf.isSecureTextEntry = false
        } else {
            tf.isSecureTextEntry = true
        }
    }
    
    // MARK: - Selectors
    @objc func handleCreateAccountButton(){
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func handleEmailTextField(){
        isValidEmail(tf: textField)
    }
    
    @objc private func showPassword(_ sender: UITapGestureRecognizer? = nil) {
        togglePassword(tf: passTextField)
    }
    
    @objc func handleLoginButton(){
        guard let email = textField.text else { return }
        guard let password = passTextField.text else { return }
        AuthService.shared.logUserIn(withEmail: email, password: password) {(result,error) in
            if let error = error {
                self.view.makeToast(error.localizedDescription, duration: 3.0, position: .bottom)
                return
            }
            
            print("DEBUG: Succesfully log in ...")
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else { return }
            guard let tab = window.rootViewController as? MainTabViewController else { return }
            
            tab.authenticateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleResetPasswordButton(){
        let vc = ResetPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
