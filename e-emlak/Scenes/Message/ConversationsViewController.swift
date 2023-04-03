//
//  ConversationsViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 10.10.2022.
//

import UIKit
import JGProgressHUD
import FirebaseAuth



class ConversationsViewController: UIViewController {
    // MARK: - Properties
    private var conversations = [Conversation]()
    private var currentUser : User?
    private var otherUser :  User?
    
    // MARK: - SubViews
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let spinner = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureTableView()
        fetchConversations()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - API
    private func fetchConversations() {
        
        let currentUser = Auth.auth().currentUser
        if let currentUser = currentUser {
            let uid = currentUser.uid
            UserService.shared.fetchUser(uid: uid) { user in
                self.currentUser = user
                ChatService.shared.fetchConversations(uid: uid) { result in
                    switch result {
                    case .success(let conversations):
                        self.conversations = conversations
                        self.tableView.reloadData()
                    case .failure(let error):
                        print("Error fetching conversations: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // MARK: - Selectors
    @objc func handleTestButton(){
        let vc = NewConversationViewController()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    // MARK: - Helpers
    private func configureUI(){
        view.backgroundColor = themeColors.white
        
        [tableView] .forEach(view.addSubview(_:))
        tableView.anchor(top: view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor
                         , right:view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 10, paddingRight: 24)
    }
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
    }
}

extension ConversationsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var uidOtherUser = ""
        if self.currentUser?.uid == self.conversations[indexPath.row].userId1 {
            uidOtherUser = self.conversations[indexPath.row].userId2
        } else {
            uidOtherUser = self.conversations[indexPath.row].userId1
        }
        
        UserService.shared.fetchUser(uid:uidOtherUser) { user in
            self.otherUser = user
            let displayName = user.name + " " + user.surname
            let vc = ChatViewController(conversationId: self.conversations[indexPath.row].conversationId, currentUser: self.currentUser, otherUser: self.otherUser)
            vc.title = displayName
            vc.navigationItem.largeTitleDisplayMode = .never

            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav,animated: true,completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.conversations[indexPath.row].conversationId
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
 
