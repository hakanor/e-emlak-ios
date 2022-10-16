//
//  MainTabViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 10.10.2022.
//

import UIKit
import Firebase

class MainTabViewController: UITabBarController {

    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        logUserOut()
        authenticateUserAndConfigureUI()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - API
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav,animated: true,completion: nil)
            }
            
        } else {
            configureViewControllers()
        }
    }
    
    func logUserOut(){
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    func configureViewControllers(){
        let feed = FeedViewController()
        feed.tabBarItem.image = UIImage(systemName: "pencil")
        
        let myFeed = MyFeedViewController()
        myFeed.tabBarItem.image = UIImage(systemName: "pencil")
        
        let conversations = ConversationsViewController()
        conversations.tabBarItem.image = UIImage(systemName: "pencil")
        
        let profile = ProfileViewController()
        profile.tabBarItem.image = UIImage(systemName: "pencil")
        
        viewControllers = [feed, myFeed, conversations, profile]
    }
}
