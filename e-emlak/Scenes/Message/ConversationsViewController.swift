//
//  ConversationsViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 10.10.2022.
//

import UIKit

class ConversationsViewController: UIViewController {

    // MARK: - SubViews
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        ChatService.shared.test()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Helpers

}

