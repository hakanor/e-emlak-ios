//
//  InspectProfileViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 12.12.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class InspectProfileViewController: UIViewController, AlertDisplayable {
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - Properties
    var user: User? {
        didSet {
            applyUserData()
        }
    }
    private var currentUser : User?
    
    var ads = [Ad]()
    var phoneNumber = ""

    // MARK: - Subviews
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
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "multiply")
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 0,left: 1.5, bottom: 0, right: 1.5)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.addBlurEffect(style: .dark, cornerRadius: 13, padding: 5)
        return button
    }()
    
    private lazy var callButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "phone.fill")
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCallButton), for: .touchUpInside)
        button.addBlurEffect(style: .dark, cornerRadius: 13, padding: 5)
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "message.fill")
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleMessageButton), for: .touchUpInside)
        button.addBlurEffect(style: .dark, cornerRadius: 13, padding: 5)
        return button
    }()
    
    private lazy var reportButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "exclamationmark.triangle.fill")
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleReportButton), for: .touchUpInside)
        button.addBlurEffect(style: .dark, cornerRadius: 13, padding: 5)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 25
        return stackView
    }()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return tableView
    }()
    
    private lazy var profilePhoto: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "bookmark")?.withTintColor(.white)
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = themeColors.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 40
        return imageView
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "profileBg")
        backgroundImage.image = image
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        return backgroundImage
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 15
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.backgroundColor = themeColors.white
        return containerView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.text = user?.name
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Konya"
        return label
    }()
    
    private lazy var aboutMeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Merhaba!"
        return label
    }()
    
    private lazy var activeAdsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.primary
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
        configureUI()
        configureTableView()
        fetchCurrentUser()
    }
    // MARK: - API
    private func fetchUser(uid:String){
        UserService.shared.fetchUser(uid:uid ) { user in
            self.user = user
        }
    }
    
    private func fetchAds(uid:String) {
        AdService.shared.fetchAds(uid:uid) { fetchedAds in
            self.ads.removeAll()
            self.ads = fetchedAds
            self.tableView.reloadData()
        }
    }
    
    private func fetchCurrentUser() {
        let currentUser = Auth.auth().currentUser
        if let currentUser = currentUser {
            let uid = currentUser.uid
            UserService.shared.fetchUser(uid: uid) { user in
                self.currentUser = user
            }
        }
    }
    
    // MARK: - Helpers
    func applyUserData(){
        guard let user = user else { return }
        titleLabel.text = user.name
        self.profilePhoto.sd_setImage(with: user.imageUrl,completed: nil)
    }
    
    func uploadImage(imageData: Data){
        let uid = AuthService.shared.getCurrentUserId()
        Storage.storage().reference().child("profile_images").child(uid).putData(imageData, metadata: nil) {(meta,error) in
            Storage.storage().reference().child("profile_images").child(uid).downloadURL { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let profileImageUrl = url?.absoluteString else { return }
                let values = [
                    "imageUrl":profileImageUrl
                ]
                Firestore.firestore().collection("users").document(uid).updateData(values) { (error) in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                    }
                }
                
            }
        }
    }
    
    func configureUI(){
        [backgroundImage, containerView, profilePhoto, ] .forEach(view.addSubview(_:))
        
        profilePhoto.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: containerView.topAnchor, paddingLeft: 24, paddingBottom: -24, width: 80, height: 80)
        
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        
        containerView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.70).isActive = true
        
        [titleLabel , subtitleLabel, activeAdsLabel, tableView,buttonStackView,aboutMeLabel] .forEach(containerView.addSubview(_:))
        
        [callButton, messageButton, reportButton] .forEach(buttonStackView.addArrangedSubview(_:))
        
        titleLabel.anchor(top: containerView.topAnchor, left: view.leftAnchor, right: buttonStackView.leftAnchor, paddingTop: 40, paddingLeft: 24, paddingRight: 24)
        
        buttonStackView.anchor(top: containerView.topAnchor, right: view.rightAnchor, paddingTop: 40, paddingRight: 24)
        
        subtitleLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        aboutMeLabel.anchor(top: subtitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        activeAdsLabel.anchor(top: aboutMeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        tableView.anchor(top: activeAdsLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor
                         , right:view.safeAreaLayoutGuide.rightAnchor, paddingTop:8, paddingLeft: 24, paddingBottom: 10, paddingRight: 24)
        
    }
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "FeedTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0  )
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCancel(){
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    @objc func handleCallButton(){
        guard let url = URL(string: "telprompt://\(self.phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func handleMessageButton(){
        
        if self.user?.uid != self.currentUser?.uid {
            let vc = ChatViewController(conversationId: "", currentUser: self.currentUser, otherUser: self.user)
            vc.title = (user?.name ?? "") + " " + (user?.surname ?? "")
            vc.navigationItem.largeTitleDisplayMode = .never
            
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav,animated: true,completion: nil)
        } else {
            self.showAlert(title: "Uyarı", message: "Kendi kendinize mesaj gönderemezsiniz.")
        }
    }
    
    @objc func handleReportButton(){
        
    }
    
    // MARK: - init
    init(uid: String) {
        super.init(nibName: nil, bundle: nil)
        
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
            self.titleLabel.text = user.name + " " + user.surname
            self.subtitleLabel.text = user.city
            self.aboutMeLabel.text = user.aboutMe
            self.profilePhoto.sd_setImage(with: user.imageUrl,completed: nil)
            self.phoneNumber = user.phoneNumber
            self.activeAdsLabel.text = user.name + " " + user.surname + " Satıcısının Aktif İlanları"
            self.fetchAds(uid:user.uid)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InspectProfileViewController : UITableViewDelegate, UITableViewDataSource {
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
        cell.configureCell(title: ads[indexPath.row].title, price: ads[indexPath.row].price, location: ads[indexPath.row].location, url: ads[indexPath.row].images.first ?? "nil", ad: ads[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        let ad = ads[indexPath.row]
        
        let propertyType = ad.estateType.split(separator: "/").first
        
        var dictionary = [CustomDictionaryObject]()
        
        switch propertyType {
        case "Konut":
            dictionary = [
                CustomDictionaryObject(key: "Fiyat", value: String(ad.price) + " ₺"),
                CustomDictionaryObject(key: "İlan Tarihi", value: String(ad.timestamp)),
                CustomDictionaryObject(key: "Emlak Türü", value: String(ad.estateType)),
                CustomDictionaryObject(key: "Metrekare (Net)", value: String(ad.squareMeter)),
                CustomDictionaryObject(key: "Metrekare (Brüt)", value: String(ad.squareMeterNet)),
                CustomDictionaryObject(key: "Bina Yaşı", value: String(ad.ageOfBuilding)),
                CustomDictionaryObject(key: "Bina Kat Sayısı", value: String(ad.numberOfFloors)),
                CustomDictionaryObject(key: "Daire Kat Sayısı", value: String(ad.floorNumber)),
                CustomDictionaryObject(key: "Oda Sayısı", value: String(ad.numberOfRooms)),
                CustomDictionaryObject(key: "Banyo Sayısı", value: String(ad.numberOfBathrooms)),
                CustomDictionaryObject(key: "Isıtma", value: String(ad.heating))
            ]
        case "İş Yeri":
            dictionary = [
                CustomDictionaryObject(key: "Fiyat", value: String(ad.price) + " ₺"),
                CustomDictionaryObject(key: "İlan Tarihi", value: String(ad.timestamp)),
                CustomDictionaryObject(key: "Emlak Türü", value: String(ad.estateType)),
                CustomDictionaryObject(key: "Metrekare (Net)", value: String(ad.squareMeter)),
                CustomDictionaryObject(key: "Bina Yaşı", value: String(ad.ageOfBuilding)),
                CustomDictionaryObject(key: "Bina Kat Sayısı", value: String(ad.numberOfFloors)),
                CustomDictionaryObject(key: "Isıtma", value: String(ad.heating))
            ]
        case "Arsa":
            dictionary = [
                CustomDictionaryObject(key: "Fiyat", value: String(ad.price) + " ₺"),
                CustomDictionaryObject(key: "İlan Tarihi", value: String(ad.timestamp)),
                CustomDictionaryObject(key: "Emlak Türü", value: String(ad.estateType)),
                CustomDictionaryObject(key: "Metrekare (Net)", value: String(ad.squareMeter)),
                CustomDictionaryObject(key: "Metrekare / ₺", value: String(ad.pricePerSquareMeter)),
                CustomDictionaryObject(key: "Ada Numarası", value: String(ad.blockNumber)),
                CustomDictionaryObject(key: "Parsel Numarası", value: String(ad.parcelNumber))
            ]
        default:
            print("Default - ProfileViewController")
        }
        
        let prime = ad.latitude
        print (prime)
        let vc = DetailsVievController(
            title: ad.title,
            location: ad.location,
            imageUrl: ad.images.first ?? "",
            description: ad.description,
            dictionary: dictionary,
            urls: ad.images,
            ad : ad
        )
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)

        
//        self.view.makeToast("\(indexPath.row) seçildi.", duration: 3.0, position: .bottom)

    }
}
