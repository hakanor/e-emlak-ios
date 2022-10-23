//
//  FeedViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 10.10.2022.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {
    // MARK: - Subviews
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = . center
        label.text = "mail"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var label2: UILabel = {
        let label = UILabel()
        label.textAlignment = . center
        label.text = "id"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var label3: UILabel = {
        let label = UILabel()
        label.textAlignment = . center
        label.numberOfLines = 0
        label.text = "id"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var testButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Çıkış Yap", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.dark, for: .normal)
        button.backgroundColor = themeColors.white
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = themeColors.grey.cgColor
        button.addTarget(self, action: #selector(handleLogOutButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("İlan Ekle", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.dark, for: .normal)
        button.backgroundColor = themeColors.white
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = themeColors.grey.cgColor
        button.addTarget(self, action: #selector(handleUploadButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        getCurrentUser()
        // Do any additional setup after loading the view.
    }
    // MARK: - API
    func logUserOut(){
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    func configureUI(){
        [label, label2, label3, testButton, uploadButton] .forEach(view.addSubview(_:))
        
        label.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20)
        
        label2.anchor(top: label.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        label3.anchor(top: label2.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        testButton.anchor(top: label3.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        uploadButton.anchor(top: testButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
    }
    
    func getCurrentUser(){
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            self.label.text = uid
            self.label2.text = email
        }
        Firestore.firestore().collection("users").document(user?.uid ?? "").getDocument(completion: ) { (snapshot,error) in
            print(snapshot?.data())
            self.label3.text = "Bilgiler: \(String(describing: snapshot?.data()))"
        }
    }
    
    func dismissPage(){
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else { return }
        guard let tab = window.rootViewController as? MainTabViewController else { return }
        
        tab.authenticateUserAndConfigureUI()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    @objc func handleLogOutButton(){
        logUserOut()
        dismissPage()
    }

    @objc func handleUploadButton(){
        let nav = UINavigationController(rootViewController: UploadAdViewController())
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)
    }
}
