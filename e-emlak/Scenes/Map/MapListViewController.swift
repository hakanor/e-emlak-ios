//
//  MapListViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 18.03.2023.
//

import UIKit

class MapListViewController: UIViewController {
    // MARK: - Properties
    var ads = [Ad]()

    // MARK: - Subviews
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        configureUI()
        configureTableView()
    }
    // MARK: - API
    // MARK: - Helpers
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MapListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .yellow
    }
    
    private func configureUI(){
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    // MARK: - Selectors
    // MARK: - Extensions
}

extension MapListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MapListTableViewCell
        cell.configureCell(ad: ads[indexPath.row])
        return cell
    }
}

extension MapListViewController: MapModeDelegate {
    func adsFiltered(ads: [Ad]) {
        self.ads = ads
        print(ads.count)
        self.tableView.reloadData()
    }
}
