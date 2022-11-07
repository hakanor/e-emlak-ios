//
//  MyFeedViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 10.10.2022.
//

import UIKit

class MyFeedViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Subviews
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleUploadButton(){
        let nav = UINavigationController(rootViewController: EstateTypeViewController())
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = themeColors.white
        
        [uploadButton] .forEach(view.addSubview(_:))
        uploadButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 20, paddingRight: 20)
        uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
