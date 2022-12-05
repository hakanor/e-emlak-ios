//
//  ResidentialDetailViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 4.12.2022.
//

import Foundation
import UIKit

class ResidentialDetailViewController: UIViewController {
    
    private var contentURL = ""
    private var bookmarkBool = false
    private var items : [Ad]?
    
    var dictionary = [CustomDictionaryObject]()
    
    //  MARK: - Subviews
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = themeColors.white
        return scrollView
    }()
    
    private lazy var adImages: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "loginBg")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "arrow.left")
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var bookmarkIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "bookmark")?.withTintColor(.white)
        icon.image = image
        icon.isUserInteractionEnabled = true
        icon.clipsToBounds = true
        return icon
    }()
    
    private lazy var shareIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "share")?.withTintColor(.white)
        icon.image = image
        icon.isUserInteractionEnabled = true
        icon.clipsToBounds = true
        return icon
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = themeColors.dark
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.text = "The latest situation in the presidential electionppppppjdjdjdjdjdjdjdjdjdjsdnnjhbdjshbdjhdsbdbjsbdsjbdhbjdjbhsdbsjhdsbjhdsbjhdsbjhdsbjhdsbjhdsbjdsbjhdsbjhdbjbhjdbjhdsbjdhsjbhdbhjdbjshddsbjdjbdbjdsbj"
        return titleLabel
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "The latest situation in the presidential election"
        return label
    }()
    
    private lazy var locationIcon: UIImageView = {
        let locationIcon = UIImageView()
        let image = UIImage(named: "location-sign")?.withTintColor(themeColors.error)
        locationIcon.image = image
        locationIcon.contentMode = .scaleAspectFit
        return locationIcon
    }()
    
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "Özellikler"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "Açıklama"
        return label
    }()
    
    private lazy var descriptionContent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.lightGrey
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam hendrerit purus a massa condimentum consequat in eu turpis. Donec maximus ipsum id luctus dictum. Fusce eu arcu mi. Nulla ullamcorper lectus ut ipsum semper, eu posuere odio porttitor. Suspendisse accumsan tellus et dui luctus, et feugiat quam suscipit. Praesent ligula dui, efficitur eu elementum vitae, vehicula tincidunt risus. Quisque faucibus sapien vitae iaculis aliquam. Maecenas felis elit, dapibus vitae suscipit non, commodo ut lorem. Vivamus facilisis, sapien vitae porttitor ullamcorper, ligula ante facilisis augue, id hendrerit erat justo in elit. Nunc imperdiet at quam sed sollicitudin."
        return label
    }()
    
    
    //  MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.setHidesBackButton(true, animated: true)
        let gestureBookmark = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGestureBookmark(_:)))
        bookmarkIcon.addGestureRecognizer(gestureBookmark)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        configureUI()
        configureTableView()
        
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTapGestureBack(_ sender: UITapGestureRecognizer? = nil) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTapGestureBookmark(_ sender: UITapGestureRecognizer? = nil) {
        if bookmarkBool == false {
            print("not bookmarked")
        } else {
            print("bookmarked")
            
        }
    }
    
    func configureUI(){
        view.backgroundColor = themeColors.white
        
        [adImages , scrollView] .forEach(view.addSubview(_:))
        
        adImages.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        adImages.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40).isActive = true
        
        view.bringSubviewToFront(adImages)
        
        scrollView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
//        scrollView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
//        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.60).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        [titleLabel, locationLabel, locationIcon, detailsLabel ,tableView, descriptionLabel, descriptionContent] .forEach(scrollView.addSubview(_:))
        
        titleLabel.anchor(top: adImages.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        locationIcon.anchor(left: scrollView.leftAnchor, paddingTop: 10, paddingLeft: 24, width: 13, height: 13)
        locationIcon.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor).isActive = true
        
        locationLabel.anchor(top: titleLabel.bottomAnchor, left: locationIcon.rightAnchor, right: scrollView.rightAnchor, paddingTop: 7, paddingLeft: 4, paddingRight: 24)
        
        detailsLabel.anchor(top: locationLabel.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 7, paddingLeft: 24, paddingRight: 24)
        
        tableView.anchor(top: detailsLabel.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 7, paddingLeft: 24, paddingRight: 24, height: 200)
        
        descriptionLabel.anchor(top: tableView.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 14, paddingLeft: 24, paddingRight: 24)
        
        descriptionContent.anchor(top: descriptionLabel.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 7, paddingLeft: 4, paddingRight: 24)

        tableView.backgroundColor = .red

    }
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "Details")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    
    private func isArticleBookmarked(title:String) -> Bool {
        for item in items ?? [] {
            if (item.title == title){
                bookmarkIcon.image = UIImage(named: "bookmark-filled")?.withTintColor(themeColors.grey)
                return true
            }
        }
        return false
    }
    
    
    
    init(title:String, location:String, imageUrl:String , description:String, dictionary: [CustomDictionaryObject]) {
        super.init(nibName: nil, bundle: nil)
        
        self.titleLabel.text = title
        
        let newString = location.replacingOccurrences(of: "/", with: " > ", options: .literal, range: nil)
        self.locationLabel.text = newString
        
        let formattedURL = URL(string: imageUrl)
        self.adImages.sd_setImage(with: formattedURL,completed: nil)
        
        self.descriptionContent.text = description
        
        self.dictionary = dictionary
        
        bookmarkBool = isArticleBookmarked(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ResidentialDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Details") as! DetailsTableViewCell
        cell.config(
            leftSide: Array(dictionary)[indexPath.row].key,
            rightSide: Array(dictionary)[indexPath.row].value
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
