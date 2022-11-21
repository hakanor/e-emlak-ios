//
//  FilteredResultViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 21.11.2022.
//

import UIKit
import Foundation

class FilteredResultViewController: UIViewController{
    // MARK: - Properties
    var ads = [Ad]()
    
    // MARK: - Subviews
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.primary
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "İlan Sonuçları"
        label.textAlignment = .center
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        configureUI()
        configurateTableView()
    }

    // MARK: - Selectors

    // MARK: - API

    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = themeColors.white
        [tableView, titleLabel] .forEach(view.addSubview(_:))
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right:view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 24, paddingRight: 24)
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        tableView.anchor(top: titleLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor
                         , right:view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 10, paddingRight: 24)
    }
    
    func configurateTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "FeedTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0  )
    }
    
    func refreshTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


extension FilteredResultViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.ads.count == 0 {
            tableView.setEmptyView(title: "Hiç ilan bulunamadı.", message: "", messageImage: UIImage(systemName: "house")!)
        }
        else {
            tableView.restore()
        }
        return self.ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as! FeedTableViewCell
        cell.configureCell(title: ads[indexPath.row].title, price: ads[indexPath.row].price, location: ads[indexPath.row].location, url: ads[indexPath.row].images.first ?? "nil")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected \(indexPath.row)")
        self.view.makeToast("\(indexPath.row) seçildi.", duration: 3.0, position: .bottom)

    }
}
