//
//  MainTabViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 10.10.2022.
//

import UIKit

class MainTabViewController: UITabBarController {

    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        configureViewControllers()
        // Do any additional setup after loading the view.
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
