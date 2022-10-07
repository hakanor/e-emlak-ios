//
//  ViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 3.10.2022.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
// MARK: - Subviews
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = . center
        label.text = "Login"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "email"
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.layer.borderWidth = 1
        emailField.translatesAutoresizingMaskIntoConstraints = false
        return emailField
    }()
    
    private lazy var passField: UITextField = {
        let passField = UITextField()
        passField.placeholder = "şifre"
        passField.layer.borderColor = UIColor.black.cgColor
        passField.layer.borderWidth = 1
        passField.translatesAutoresizingMaskIntoConstraints = false
        return passField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonCreateHandle), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private lazy var buttonLogin: UIButton = {
        let buttonLogin = UIButton()
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        buttonLogin.backgroundColor = .green
        buttonLogin.setTitle("Login", for: .normal)
        buttonLogin.setTitleColor(.white, for: .normal)
        buttonLogin.addTarget(self, action: #selector(buttonLoginHandle), for: UIControl.Event.touchUpInside)
        return buttonLogin
    }()
    
    
    private lazy var getCurrentButton: UIButton = {
        let getCurrentButton = UIButton()
        getCurrentButton.translatesAutoresizingMaskIntoConstraints = false
        getCurrentButton.backgroundColor = .green
        getCurrentButton.setTitle("get Current user", for: .normal)
        getCurrentButton.setTitleColor(.white, for: .normal)
        getCurrentButton.addTarget(self, action: #selector(getCurrentUser), for: UIControl.Event.touchUpInside)
        return getCurrentButton
    }()
    
    private lazy var signOutButton: UIButton = {
        let signOutButton = UIButton()
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.backgroundColor = .green
        signOutButton.setTitle("sign out", for: .normal)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.addTarget(self, action: #selector(signOut), for: UIControl.Event.touchUpInside)
        return signOutButton
    }()
    
    private lazy var testButton: UIButton = {
        let signOutButton = UIButton()
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.backgroundColor = .green
        signOutButton.setTitle("TEST", for: .normal)
        signOutButton.setTitleColor(.black, for: .normal)
        signOutButton.addTarget(self, action: #selector(test), for: UIControl.Event.touchUpInside)
        return signOutButton
    }()

    // MARK: - User Actions
    @objc func buttonCreateHandle(){
        let email = emailField.text!
        let password = passField.text!
        Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
            if(error != nil){
                self.label.text = "\(error)"
                print(error)
                return
            }
            self.label.text = "Kayıt olundu"
        })
    }
    
    @objc func buttonLoginHandle(){
        let email = emailField.text!
        let password = passField.text!
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] user, error in
            guard let strongSelf = self else { return }
            if(error != nil){
                strongSelf.label.text = "Error check email pass"
                print(error)
                return
            }
            strongSelf.label.text = "Login success"
        
        })
    }
    
    @objc func getCurrentUser(){
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            self.label.text = uid + "-" + (email ?? "-")
            print(uid)
        }
    }
    
    @objc func signOut(){
        try! Auth.auth().signOut()
        self.label.text = "sign out"
    }
    
    @objc func test(){
        let vc = LoginEmailViewController()
        let vc2 = LoginPasswordViewController()
        self.navigationController?.pushViewController(vc2, animated: true)
    }
// MARK: - Properties
       
// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [label,emailField,passField,button,buttonLogin,getCurrentButton,signOutButton,testButton].forEach(view.addSubview(_:))
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        emailField.topAnchor.constraint(equalTo: label.bottomAnchor,constant: 30).isActive = true
        emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailField.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -10).isActive = true
        
        passField.topAnchor.constraint(equalTo: emailField.bottomAnchor,constant: 10).isActive = true
        passField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passField.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -10).isActive = true
        
        button.topAnchor.constraint(equalTo: passField.bottomAnchor,constant: 10).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        buttonLogin.topAnchor.constraint(equalTo: button.bottomAnchor,constant: 10).isActive = true
        buttonLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        getCurrentButton.topAnchor.constraint(equalTo: buttonLogin.bottomAnchor,constant: 10).isActive = true
        getCurrentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        signOutButton.topAnchor.constraint(equalTo: getCurrentButton.bottomAnchor,constant: 10).isActive = true
        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        testButton.topAnchor.constraint(equalTo: signOutButton.bottomAnchor,constant: 10).isActive = true
        testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }


}

