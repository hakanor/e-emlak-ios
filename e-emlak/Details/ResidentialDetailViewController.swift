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
        scrollView.contentInsetAdjustmentBehavior = .never
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
        button.addBlurEffect(style: .dark, cornerRadius: 13, padding: 5)
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
        titleLabel.text = "Title"
        return titleLabel
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Location Label"
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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        return stackView
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
        label.text = "Açıklama"
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
        configureCollectionView()
        configurePageControl()
        configureStackView()
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
        
        [scrollView, LocationButton] .forEach(view.addSubview(_:))
        
        LocationButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 10, paddingRight: 12, width: 42, height: 42)
        
        scrollView.anchor(top: view.topAnchor,left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        [contentView] .forEach(scrollView.addSubview(_:))
        
        contentView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, width: UIScreen.main.bounds.width)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        [adImages, pageControl, titleLabel, locationLabel, locationIcon, detailsLabel ,stackView, descriptionLabel, descriptionContent] .forEach(contentView.addSubview(_:))
        
        adImages.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        adImages.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40).isActive = true
        
        pageControl.anchor(left: contentView.leftAnchor, bottom: adImages.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 0, paddingBottom: 4, paddingRight: 0)
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.bringSubviewToFront(adImages)
        view.bringSubviewToFront(pageControl)
        
        titleLabel.anchor(top: adImages.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        locationIcon.anchor(left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 24, width: 13, height: 13)
        locationIcon.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor).isActive = true
        
        locationLabel.anchor(top: titleLabel.bottomAnchor, left: locationIcon.rightAnchor, right: contentView.rightAnchor, paddingTop: 7, paddingLeft: 4, paddingRight: 24)
        
        detailsLabel.anchor(top: locationLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 24, paddingRight: 24)
        
        stackView.anchor(top: detailsLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 7, paddingLeft: 24, paddingRight: 24, height: 400)
        
        descriptionLabel.anchor(top: stackView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 24, paddingRight: 24)
        
        descriptionContent.anchor(top: descriptionLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor ,right: contentView.rightAnchor, paddingTop: 7, paddingLeft: 24, paddingBottom: 70, paddingRight: 24)
    }
    
    
    func configureStackView(){
        let countOfDictionary = self.dictionary.count - 1
        for i in 0...countOfDictionary {
            let cell = DetailsTableViewCell()
            cell.config(
                leftSide: Array(dictionary)[i].key,
                rightSide: Array(dictionary)[i].value
            )
            stackView.addArrangedSubview(cell)
        }
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
