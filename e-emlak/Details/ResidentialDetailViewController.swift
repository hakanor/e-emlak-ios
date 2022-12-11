//
//  ResidentialDetailViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 4.12.2022.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import SwiftUI

class ResidentialDetailViewController: UIViewController {
    
    private var bookmarkBool = false
    private var items : [Ad]?
    private var ad = Ad(adId: "", dictionary: ["s":""])
    
    var imageArray = [UIImage?]()
    var dictionary = [CustomDictionaryObject]()
    
    //  MARK: - Subviews
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = themeColors.white
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var adImages: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.60)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero,collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
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
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.text = "The latest situation in the presidential electionppppppjdjdjdjdjdjdjdjdjdjsdnnjhbdjshbdjhdsbdbjsbdsjbdhbjdjbhsdbsjhdsbjhdsbjhdsbjhdsbjhdsbjhdsbjdsbjhdsbjhdbjbhjdbjhdsbjdhsjbhdbhjdbjshddsbjdjbdbjdsbj"
        return titleLabel
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
        label.textColor = themeColors.grey
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam hendrerit purus a massa condimentum consequat in eu turpis. Donec maximus ipsum id luctus dictum. Fusce eu arcu mi. Nulla ullamcorper lectus ut ipsum semper, eu posuere odio porttitor. Suspendisse accumsan tellus et dui luctus, et feugiat quam suscipit. Praesent ligula dui, efficitur eu elementum vitae, vehicula tincidunt risus. Quisque faucibus sapien vitae iaculis aliquam. Maecenas felis elit, dapibus vitae suscipit non, commodo ut lorem. Vivamus facilisis, sapien vitae porttitor ullamcorper, ligula ante facilisis augue, id hendrerit erat justo in elit. Nunc imperdiet at quam sed sollicitudin."
        return label
    }()
    
    private lazy var LocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = themeColors.white
        let image = UIImage(named:"location-sign")
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setImage(image, for: .normal)
        button.backgroundColor = themeColors.primary
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleLocationButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        configureCollectionView()
        configurePageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTapGestureBack(_ sender: UITapGestureRecognizer? = nil) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleLocationButton(){
        if (self.ad.latitude != 0 && self.ad.longitude != 0) {
            let vc = CoordinateDetailsViewController()
            vc.pin.coordinate = CLLocationCoordinate2D(latitude: self.ad.latitude, longitude: self.ad.longitude)
            present(vc,animated: true)
        }
        else {
            let dialogMessage = UIAlertController(title: "İlan Konumu Hakkında", message: "Satıcı, ilan harita konumunu eklememiştir.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Tamam", style: .cancel) { (action) -> Void in
                
            }
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
            print(self.ad.timestamp)
        }
        
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
        
        [adImages , pageControl ,scrollView, LocationButton] .forEach(view.addSubview(_:))
        
        adImages.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        adImages.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40).isActive = true
        
        view.bringSubviewToFront(adImages)
        
        pageControl.anchor(left: view.leftAnchor, bottom: adImages.bottomAnchor, right: view.rightAnchor, paddingLeft: 0, paddingBottom: 4, paddingRight: 0)
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.bringSubviewToFront(pageControl)
        
        LocationButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 10, paddingRight: 12, width: 42, height: 42)
        
        scrollView.anchor(top: adImages.bottomAnchor,left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
//        scrollView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
//        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        [contentView] .forEach(scrollView.addSubview(_:))
        
        contentView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, width: UIScreen.main.bounds.width)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        [titleLabel, locationLabel, locationIcon, detailsLabel ,tableView, descriptionLabel, descriptionContent] .forEach(contentView.addSubview(_:))
        
        titleLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        locationIcon.anchor(left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 24, width: 13, height: 13)
        locationIcon.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor).isActive = true
        
        locationLabel.anchor(top: titleLabel.bottomAnchor, left: locationIcon.rightAnchor, right: contentView.rightAnchor, paddingTop: 7, paddingLeft: 4, paddingRight: 24)
        
        detailsLabel.anchor(top: locationLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 24, paddingRight: 24)
        
        tableView.anchor(top: detailsLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 7, paddingLeft: 24, paddingRight: 24, height: 400)
        
        descriptionLabel.anchor(top: tableView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 24, paddingRight: 24)
        
        descriptionContent.anchor(top: descriptionLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor ,right: contentView.rightAnchor, paddingTop: 7, paddingLeft: 24, paddingRight: 24)

        

    }
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "Details")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
    }
    
    func configureCollectionView(){
        adImages.dataSource = self
        adImages.delegate = self
        adImages.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: "detailscvcell")
        adImages.isPagingEnabled = true
    }
    
    func configurePageControl() {
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = themeColors.primary
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
    
    func downloadImages(forURLs urls: [String], completion: @escaping ([UIImage?]) -> Void) {
        let group = DispatchGroup()
        var images: [UIImage?] = .init(repeating: nil, count: urls.count)
        
        for (index, urlString) in urls.enumerated() {
            group.enter()
            DispatchQueue.global().async {
                var image: UIImage?
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        image = UIImage(data: data)
                    }
                }
                images[index] = image
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
    
    init(title:String, location:String, imageUrl:String , description:String, dictionary: [CustomDictionaryObject],urls: [String], ad: Ad) {
        super.init(nibName: nil, bundle: nil)
        
        self.titleLabel.text = title
        
        let newString = location.replacingOccurrences(of: "/", with: " > ", options: .literal, range: nil)
        self.locationLabel.text = newString
        
        downloadImages(forURLs: urls) { images in
            self.imageArray = images
            self.adImages.reloadData()
            self.pageControl.numberOfPages = self.imageArray.count
        }
        
        self.descriptionContent.text = description
        
        self.dictionary = dictionary
        
        self.ad = ad 
        bookmarkBool = isArticleBookmarked(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UITableViewDelegate,UITableViewDataSource
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ResidentialDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailscvcell", for: indexPath) as! DetailsCollectionViewCell
        cell.imageView.image = imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageTapped(image: imageArray[indexPath.row] ?? UIImage())
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func imageTapped(image:UIImage){
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
}
