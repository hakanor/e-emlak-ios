//
//  NewConversationViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 28.03.2023.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class NewConversationViewController: UIViewController {
    
    public var completion: ((User) -> (Void))?
    
    private var users = [User]()
    
    private let spinner = JGProgressHUD()
    
    private let searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users"
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Kayıtlı üye bulunamadı"
        label.textAlignment = .center
        label.textColor = themeColors.primary
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "İptal", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}

extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        searchBar.resignFirstResponder()

        users.removeAll()
        spinner.show(in: view)
        
        let currentUser = Auth.auth().currentUser
        if let currentUser = currentUser {
            let uid = currentUser.uid
        }

        UserService.shared.fetchAllUsers { users in
            var fetchedUsers = users
            fetchedUsers.removeAll(where: { $0.uid == currentUser?.uid })
            self.users = fetchedUsers
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.spinner.dismiss(animated: true)
            print(fetchedUsers.count)
        }
        
    }
    
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // start conversation
        let targetUserData = users[indexPath.row]
    }
    
    
}


