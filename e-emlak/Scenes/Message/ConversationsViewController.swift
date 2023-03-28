//
//  ConversationsViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 10.10.2022.
//

import UIKit
import JGProgressHUD

class ConversationsViewController: UIViewController {
    // MARK: - Properties
    

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
        ChatService.shared.test()
        configureUI()
        configureTableView()
        fetchConversations()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - API
    private func fetchConversations() {
        
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("row selected")
        let vc = ChatViewController()
        vc.title = "Janny Smith"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Selam"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
 
