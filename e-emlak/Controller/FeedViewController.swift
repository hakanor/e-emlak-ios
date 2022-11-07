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
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI(){
        [label, label2, label3] .forEach(view.addSubview(_:))
        
        label.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20)
        
        label2.anchor(top: label.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        label3.anchor(top: label2.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
    }
    
    // MARK: - Selectors

}
