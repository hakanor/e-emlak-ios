//
//  FeedViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 10.10.2022.
//

import UIKit
import Firebase
import Toast

class FeedViewController: UIViewController {
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
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "İl İlçe Mahalle Veya Semt Ara",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.dark.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.backgroundColor = themeColors.lightGrey
        textField.leftImage(UIImage(systemName: "magnifyingglass")?.withTintColor(themeColors.dark), imageWidth: 10, padding: 15)

        let clearImage = UIImage(systemName: "multiply")?.withTintColor(themeColors.dark)
        let clearImageView = UIImageView(image: clearImage)
        clearImageView.contentMode = .center
        clearImageView.tintColor = .black
        clearImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(didTouchClearAllButton(_:)))
        textField.rightView(clearImageView, width: 20, padding: 5 , tapGesture:tapGesture)
        
        textField.layer.cornerRadius = 13
        textField.addTarget(self, action: #selector(searchFunc), for: .editingDidEndOnExit)
        return textField
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        let image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
        button.setImage(image, for: .normal)
        button.backgroundColor = themeColors.primary
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(handleFilterButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchAds()
        configureUI()
        configurateTableView()
        tableView.reloadData()
    }
    
    // MARK: - API
    func fetchAds() {
        AdService.shared.fetchAds { fetchedAds in
            self.ads.removeAll()
            self.ads = fetchedAds
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    func configureUI(){
        [tableView, textField, filterButton] .forEach(view.addSubview(_:))
        
        filterButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 10, paddingLeft: 24, width: 35, height: 35)
        
        textField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: filterButton.rightAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 24, height: 35)
        
        tableView.anchor(top: filterButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor
                         , right:view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 10, paddingRight: 24)
    }
    
    func configurateTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "FeedTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0  )
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFunc), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    // MARK: - Selectors
    @objc func refreshFunc(refreshControl: UIRefreshControl) {
//        fetchNews()
//        textField.text = ""
        tableView.reloadData()
        print("refresh")
        refreshControl.endRefreshing()
    }
    
    @objc func searchFunc() {
        print("search")
    }
    
    @objc private func didTouchClearAllButton(_ sender: UITapGestureRecognizer? = nil) {
        textField.text?.removeAll();
    }
    
    @objc func handleFilterButton() {
        print("filter")
    }
    
    
}

    // MARK: - UITableView Delegate & DataSource
extension FeedViewController : UITableViewDelegate, UITableViewDataSource {
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
