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
import ImageSlideshow

class DetailsVievController: UIViewController {
    
    private var bookmarkBool = false
    private var items : [Ad]?
    private var ad = Ad(adId: "", dictionary: ["s":""])
    private var phoneNumber = ""
    
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
    
    private lazy var slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        slideshow.pageIndicator = pageControl
        slideshow.contentScaleMode = .scaleAspectFill
        slideshow.preload = .all
        return slideshow
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
        label.textColor = themeColors.primary
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "Özellikler"
        return label
    }()
    
    private lazy var sellerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.textColor = themeColors.primary
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "Satıcı"
        return label
    }()
    
    private lazy var sellerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.textColor = themeColors.grey
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "Satıcı İsim"
        return label
    }()
    
    private lazy var sellerProfilePhoto: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "bookmark")?.withTintColor(.white)
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = themeColors.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var shareBookmarkStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 18
        return stackView
    }()
    
    private lazy var bookmarkIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "bookmark")
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBookmarkButton), for: .touchUpInside)
        button.addBlurEffect(style: .dark, cornerRadius: 13, padding: 5)
        return button
    }()
    
    private lazy var shareIcon: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "square.and.arrow.up")
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        button.addBlurEffect(style: .dark, cornerRadius: 13, padding: 5)
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.primary
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
    
    private lazy var locationButton: UIButton = {
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
    
    private lazy var callButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Ara", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.success
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleCallButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Mesaj", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleMessageButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    //  MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareBookmarkStackView)
        configureUI()
        configureCollectionView()
        configurePageControl()
        configureStackView()
        configureShareBookmarkStackView()
        configureGestures()
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
    
    @objc func handleBookmarkButton(){
        if bookmarkBool == false {
            print("not bookmarked")
            let image = UIImage(systemName: "bookmark.fill")?.withTintColor(themeColors.grey)
            self.bookmarkIcon.setImage(image, for: .normal)
            bookmarkBool = true
            
        } else {
            print("bookmarked")
            let image = UIImage(systemName: "bookmark")?.withTintColor(themeColors.grey)
            self.bookmarkIcon.setImage(image, for: .normal)
            bookmarkBool = false
        }
    }
    
    @objc func handleShareButton(sender:UIView){
        // Setting description
        let firstActivityItem = (self.titleLabel.text ?? "") + " ilanını paylaş."

            // Setting url
            let secondActivityItem : NSURL = NSURL(string: "http://github.com/hakanor")!
           
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
            
            // This lines is for the popover you need to show in iPad
            activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
            
            // This line remove the arrow of the popover to show in iPad
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            // Pre-configuring activity items
            activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
            
            // Anything you want to exclude
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.copyToPasteboard,
                UIActivity.ActivityType.message,
                UIActivity.ActivityType.mail,
                UIActivity.ActivityType.postToFacebook,
                UIActivity.ActivityType.postToTwitter
            ]
            
            activityViewController.isModalInPresentation = true
            self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func handleInspectProfileGesture(_ sender: UITapGestureRecognizer? = nil) {
        let vc = InspectProfileViewController(uid: self.ad.uid)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)
    }
    
    @objc func handleSlideTap(_ sender: UITapGestureRecognizer? = nil) {
        slideshow.presentFullScreenController(from: self)
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
        }
        
    }
    
    @objc func handleCallButton(){
        guard let url = URL(string: "telprompt://\(self.phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func handleMessageButton(){
        
    }
    
    
    func configureUI(){
        view.backgroundColor = themeColors.white
        
        [scrollView, locationButton, buttonStackView ] .forEach(view.addSubview(_:))
        
        locationButton.anchor(right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 24, width: 42, height: 42)
        locationButton.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor).isActive = true
        
        buttonStackView.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: locationButton.leftAnchor, paddingLeft: 24, paddingBottom: 10, paddingRight: 20)
        
        [callButton, messageButton] .forEach(buttonStackView.addArrangedSubview(_:))
        
        scrollView.anchor(top: view.topAnchor,left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        [contentView] .forEach(scrollView.addSubview(_:))
        
        contentView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, width: UIScreen.main.bounds.width)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        [slideshow, pageControl, titleLabel, locationLabel, sellerNameLabel, sellerName, sellerProfilePhoto ,locationIcon, detailsLabel ,stackView, descriptionLabel, descriptionContent] .forEach(contentView.addSubview(_:))
        
        slideshow.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        slideshow.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40).isActive = true
        
        pageControl.anchor(left: contentView.leftAnchor, bottom: slideshow.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 0, paddingBottom: 4, paddingRight: 0)
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.bringSubviewToFront(slideshow)
        view.bringSubviewToFront(pageControl)
        
        titleLabel.anchor(top: slideshow.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        locationIcon.anchor(left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 24, width: 13, height: 13)
        locationIcon.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor).isActive = true
        
        locationLabel.anchor(top: titleLabel.bottomAnchor, left: locationIcon.rightAnchor, right: contentView.rightAnchor, paddingTop: 7, paddingLeft: 4, paddingRight: 24)
        
        sellerNameLabel.anchor(top: locationLabel.bottomAnchor, left: contentView.leftAnchor, right: sellerProfilePhoto.leftAnchor, paddingTop: 20, paddingLeft: 24, paddingRight: 6)
        
        sellerName.anchor(top: sellerNameLabel.bottomAnchor, left: contentView.leftAnchor, right: sellerProfilePhoto.leftAnchor, paddingTop: 5, paddingLeft: 24, paddingRight: 6)
        
        sellerProfilePhoto.anchor(top: sellerNameLabel.topAnchor, bottom: sellerName.bottomAnchor, right:contentView.rightAnchor, paddingRight: 24 ,width: 45, height: 45)
        
        detailsLabel.anchor(top: sellerName.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 24, paddingRight: 24)
        
        stackView.anchor(top: detailsLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 7, paddingLeft: 24, paddingRight: 24, height: 400)
        
        descriptionLabel.anchor(top: stackView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 24, paddingRight: 24)
        
        descriptionContent.anchor(top: descriptionLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor ,right: contentView.rightAnchor, paddingTop: 7, paddingLeft: 24, paddingBottom: 70, paddingRight: 24)
    }
    
    
    func configureStackView(){
        let countOfDictionary = self.dictionary.count - 1
        for i in 0...countOfDictionary {
            let cell = DetailsTableViewCell()
            
            if Array(dictionary)[i].key == "Fiyat" {
                let left = Array(dictionary)[i].key
//                var rightString = Array(dictionary)[i].value
//                rightString = rightString.substring(0, rightString.length() - 2)

                let splitted = Array(dictionary)[i].value.split(separator: " ")
                
                print(Int(splitted[0]) ?? 0 )
                let unformattedValue : Int = Int(splitted[0]) ?? 0
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal // or .decimal if desired
                formatter.maximumFractionDigits = 0; //change as desired
                formatter.locale = Locale.current // or = Locale(identifier: "de_DE"), more locale identifier codes:
                formatter.groupingSeparator = "."
                let displayValue : String = formatter.string(from: NSNumber(value: unformattedValue))! // displayValue: "$3,534,235" ```
                
                let right = displayValue + " ₺"
                
                cell.config(
                    leftSide: left,
                    rightSide: right
                )
            } else {
                cell.config(
                    leftSide: Array(dictionary)[i].key,
                    rightSide: Array(dictionary)[i].value
                )
            }
            
            stackView.addArrangedSubview(cell)
        }
    }
    
    func configureShareBookmarkStackView(){
        [shareIcon,bookmarkIcon] .forEach(shareBookmarkStackView.addArrangedSubview(_:))
    }
    
    func configureGestures(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleInspectProfileGesture(_:)))
        let gestureForSellerName = UITapGestureRecognizer(target: self, action: #selector(self.handleInspectProfileGesture(_:)))
        let gestureForSellerNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.handleInspectProfileGesture(_:)))
        sellerName.addGestureRecognizer(gestureForSellerName)
        sellerNameLabel.addGestureRecognizer(gestureForSellerNameLabel)
        sellerProfilePhoto.addGestureRecognizer(gesture)
        
        let gestureslideshow = UITapGestureRecognizer(target: self, action: #selector(handleSlideTap))
        slideshow.addGestureRecognizer(gestureslideshow)
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
                let image = UIImage(named: "bookmark-filled")?.withTintColor(themeColors.grey)
                self.bookmarkIcon.setImage(image, for: .normal)
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
            
            var imageSource: [ImageSource] = []
            
            for image in self.imageArray {
                imageSource.append(ImageSource(image:  image ?? UIImage()))
            }
            
            self.slideshow.setImageInputs(imageSource)
            
        }
        
        self.descriptionContent.text = description
        
        self.dictionary = dictionary
        
        self.ad = ad
        
        UserService.shared.fetchUser(uid: ad.uid) { user in
            self.sellerName.text = user.name + " " + user.surname
            self.sellerProfilePhoto.sd_setImage(with: user.imageUrl,completed: nil)
            self.phoneNumber = user.phoneNumber
        }
        
        bookmarkBool = isArticleBookmarked(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DetailsVievController : UICollectionViewDelegate, UICollectionViewDataSource {
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
