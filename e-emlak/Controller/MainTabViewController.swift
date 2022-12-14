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
    var user: User? {
        didSet {
            print("DEBUG: Did set user in main tab")
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        authenticateUserAndConfigureUI()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - API
    func fetchUser(){
        UserService.shared.fetchUser { user in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav,animated: true,completion: nil)
            }
            
        } else {
            configureViewControllers()
            fetchUser()
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
        feed.title = "Ana Sayfa"
        feed.tabBarItem.image = UIImage(systemName: "house.circle")
        
        let myFeed = MyFeedViewController()
        myFeed.title = "İlanlarım"
        myFeed.tabBarItem.image = UIImage(systemName: "pencil")
        
        let postAd = EstateTypeViewController()
        postAd.title = "İlan Ekle"
        postAd.tabBarItem.image = UIImage(systemName: "plus.circle")
        
        let conversations = ConversationsViewController()
        conversations.title = "Mesajlar"
        conversations.tabBarItem.image = UIImage(systemName: "message.circle")
        
        let profile = ProfileViewController()
        profile.title = "Profilim"
        profile.tabBarItem.image = UIImage(systemName: "person.circle")
        
        viewControllers = [feed, myFeed, postAd,conversations, profile]
    }
}
