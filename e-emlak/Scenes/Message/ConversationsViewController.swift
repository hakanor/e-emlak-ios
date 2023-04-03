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
    private lazy var hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Yükleniyor"
        return hud
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = themeColors.white
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.primary
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.text = "Mesajlar"
        label.contentMode = .scaleToFill
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureTableView()
        fetchConversations()
        hud.show(in: self.view, animated: true)
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
    
    @objc func refreshFunc(refreshControl: UIRefreshControl) {
        fetchConversations()
        tableView.reloadData()
        print("refresh")
        refreshControl.endRefreshing()
    }
    
    // MARK: - Helpers
    private func configureUI(){
        view.backgroundColor = themeColors.white
        
        [tableView, titleLabel] .forEach(view.addSubview(_:))
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        tableView.anchor(top: titleLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor
                         , right:view.safeAreaLayoutGuide.rightAnchor, paddingTop: 4, paddingLeft: 24, paddingBottom: 10, paddingRight: 24)
    }
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ConversationsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFunc), for: .valueChanged)
        tableView.addSubview(refreshControl)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ConversationsTableViewCell
        let message = self.conversations[indexPath.row].lastMessageText
        let timeStamp = self.conversations[indexPath.row].timestamp
        
        var uidOtherUser = ""
        if self.currentUser?.uid == self.conversations[indexPath.row].userId1 {
            uidOtherUser = self.conversations[indexPath.row].userId2
        } else {
            uidOtherUser = self.conversations[indexPath.row].userId1
        }
        
        cell.configureCell(uid: uidOtherUser, lastMessageText: message, timeStamp: timeStamp)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.conversations.count - 1
        if indexPath.row == lastElement {
            hud.dismiss()
        }
    }
}
