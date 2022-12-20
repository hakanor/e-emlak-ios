//
//  ChangePasswordViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 19.12.2022.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    
    private var email = ""
    private var oldPassword = ""
    private var uid = ""
    
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
        let image = UIImage(named: "changePassword")
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
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.text = "Şifre Değiştirin"
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Şifrenizi değiştirebilmek için mevcut şifrenizi girmeniz gerekmektedir."
        return label
    }()
    
    private lazy var oldPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Eski Şifreniz"
        return label
    }()
    
    private lazy var oldPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "eski şifre",
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
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(showOldPassword(_:)))
        textField.rightView(eyeImageView, width: 40, padding: 0 , tapGesture:tapGesture)
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Yeni Şifreniz"
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "yeni şifre",
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
        textField.rightView(eyeImageView, width: 40, padding: 0 , tapGesture:tapGesture)
        return textField
    }()
    
    private lazy var newPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Yeni Şifreniz Tekrar"
        return label
    }()
    
    private lazy var newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "yeni şifre tekrar",
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
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(showNewPassword(_:)))
        textField.rightView(eyeImageView, width: 40, padding: 0 , tapGesture:tapGesture)
        return textField
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Şifremi Değiştir", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setKeyboardDelegates()
        fetchUserCredential()
        
        view.backgroundColor = themeColors.white
        self.navigationItem.setHidesBackButton(true, animated: true)

        [backgroundImage, containerView, backButton] .forEach(view.addSubview(_:))
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 20, width: 24, height: 24)
        
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
        
        containerView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.60).isActive = true
        
        [titleLabel , subtitleLabel, oldPasswordLabel, oldPasswordTextField, passwordLabel, passwordTextField, newPasswordLabel, newPasswordTextField, nextButton] .forEach(containerView.addSubview(_:))
        
        titleLabel.anchor(top: containerView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        subtitleLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        oldPasswordLabel.anchor(top: subtitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        oldPasswordTextField.anchor(top: oldPasswordLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
       
        passwordLabel.anchor(top: oldPasswordTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        passwordTextField.anchor(top: passwordLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        newPasswordLabel.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        newPasswordTextField.anchor(top: newPasswordLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
    
        nextButton.anchor(top: newPasswordTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 20, paddingRight: 24)

    }
    
    // MARK: - Helpers
    
    func fetchUserCredential(){
        UserService.shared.fetchUser { user in
            self.oldPassword = user.password
            self.email = user.email
            self.uid = user.uid
        }
    }
    
    func setKeyboardDelegates(){
        oldPasswordTextField.delegate = self
        passwordTextField.delegate = self
        newPasswordTextField.delegate = self
        
        oldPasswordTextField.tag = 1
        passwordTextField.tag = 2
        newPasswordTextField.tag = 3

    }
    
    func togglePassword(tf:UITextField){
        if tf.isSecureTextEntry {
            tf.isSecureTextEntry = false
        } else {
            tf.isSecureTextEntry = true
        }
    }

    func checkRegisterFields() -> String {
        guard oldPasswordTextField.text != "" else { return "Şifre alanı boş olamaz."}
        guard passwordTextField.text != "" else { return "Şifre alanı boş olamaz."}
        guard newPasswordTextField.text != "" else { return "Şifre alanı boş olamaz."}
        
        if oldPasswordTextField.text?.count ?? 0 >= 6 {
        } else {
            return "Eski şifreniz minimum 6 karakterden oluşmaktadır."
        }
        
        if oldPasswordTextField.text == self.oldPassword {
        } else {
            return "Eski şifrenizi yanlış."
        }
        
        if passwordTextField.text?.count ?? 0 >= 6 {
        } else {
            return "Yeni şifre için minimum 6 karakter girmeniz gerekmektedir."
        }
        if newPasswordTextField.text?.count ?? 0 >= 6 {
        } else {
            return "Yeni şifre tekrarı için minimum 6 karakter girmeniz gerekmektedir."
        }
        
        if newPasswordTextField.text == passwordTextField.text {
        } else {
            return "Eski şifreniz ile yeni şifreniz uyuşmamaktadır."
        }
        
        return ""
    }
    
    private func reauthenticateAndChangePassword(password:String){
        let user = Auth.auth().currentUser
        
        let credential = EmailAuthProvider.credential(withEmail: self.email, password: self.oldPassword)

        user?.reauthenticate(with: credential, completion: { (result, error) in
           if let error = error {
              print(error)
           } else {
               
               Auth.auth().currentUser?.updatePassword(to: password) { (error) in
                   if let error = error {
                       print(error)
                       self.view.makeToast("Şifre değiştirme işlemi hassas bir işlemdir. Lütfen hesabınızı kapatın ve yeniden giriş yaptıktan sonra tekrar deneyin.", duration: 3.0, position: .bottom)
                   } else {
                       print("DEBUG: Succesfully changed password")
                       self.updatePasswordData(uid: self.uid, password: password)
                       
                       let dialogMessage = UIAlertController(title: "Şifre Değiştirme", message: "Şifreniz başarıyla değiştirildi.", preferredStyle: .alert)
                       let cancel = UIAlertAction(title: "Tamam", style: .cancel) { (action) -> Void in
                           self.dismiss(animated: true, completion: nil)
                       }
                       dialogMessage.addAction(cancel)
                       self.present(dialogMessage, animated: true, completion: nil)
                   }
               }
              
           }
        })
        
    }
    
    private func updatePasswordData(uid:String, password:String){
        let passwordDict = ["password":password]
        AuthService.shared.updateUser(uid: uid, dictionary: passwordDict) { (error) in
            print("DEBUG: Password changed.")
        }
    }

    // MARK: - Selectors
    @objc func handleNextButton(){
        
        guard oldPasswordTextField.text != nil else { return }
        guard let password = passwordTextField.text else { return }
        guard newPasswordTextField.text != nil else { return }

        if checkRegisterFields() != "" {
            self.view.makeToast(checkRegisterFields(), duration: 3.0, position: .bottom)
        } else {
            reauthenticateAndChangePassword(password: password)
        }
        
    }
    
    @objc func handleBackButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func showOldPassword(_ sender: UITapGestureRecognizer? = nil) {
        togglePassword(tf: oldPasswordTextField)
    }
    @objc private func showPassword(_ sender: UITapGestureRecognizer? = nil) {
        togglePassword(tf: passwordTextField)
    }
    @objc private func showNewPassword(_ sender: UITapGestureRecognizer? = nil) {
        togglePassword(tf: newPasswordTextField)
    }
    
}

extension ChangePasswordViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
