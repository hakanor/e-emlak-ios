//
//  ProfileViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 10.10.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class ProfileViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - Properties
    var user: User? {
        didSet {
            applyUserData()
        }
    }
    var ads = [Ad]()
    var uid = ""

    // MARK: - Subviews
    
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
        label.text = "Merhaba! Benim adım Hakan, Konya ilinde emlakçılık yapıyorum."
        return label
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var editProfileButton: ProfileCustomButton = {
        let button = ProfileCustomButton(leftIconName: "pencil", text: "Profilimi Düzenle", target: self, action: #selector(handleEditProfileButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var changePasswordButton: ProfileCustomButton = {
        let button = ProfileCustomButton(leftIconName: "lock.fill", text: "Şifremi Değiştir", target: self, action: #selector(handleChangePasswordButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var logoutButton: ProfileCustomButton = {
        let button = ProfileCustomButton(leftIconName: "square.and.arrow.up", text: "Çıkış Yap", target: self, action: #selector(handleLogOutButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var aboutApplicationButton: ProfileCustomButton = {
        let button = ProfileCustomButton(leftIconName: "book.fill", text: "Uygulama Hakkında", target: self, action: #selector(handleAboutApplicationButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var postAdButton: ProfileCustomButton = {
        let button = ProfileCustomButton(leftIconName: "plus.circle.fill", text: "İlan Ekle", target: self, action: #selector(handlePostAdButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        fetchUser()
        configureUI()
        configureStackView()
        
        let gestureProfilePhoto = UITapGestureRecognizer(target: self, action: #selector(self.handleAddProfilePhoto(_:)))
        profilePhoto.addGestureRecognizer(gestureProfilePhoto)
        
    }
    // MARK: - API
    func fetchUser(){
        UserService.shared.fetchUser { user in
            self.user = user
        }
    }
    
    // MARK: - Helpers
    func applyUserData(){
        guard let user = user else { return }
        titleLabel.text = user.name + " " + user.surname
        subtitleLabel.text = user.city
        aboutMeLabel.text = user.aboutMe
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
    
    func logUserOut(){
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func dismissPage(){
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else { return }
        guard let tab = window.rootViewController as? MainTabViewController else { return }
        
        tab.authenticateUserAndConfigureUI()
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureUI(){
        [backgroundImage, containerView, profilePhoto, ] .forEach(view.addSubview(_:))
        
        profilePhoto.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: containerView.topAnchor, paddingLeft: 24, paddingBottom: -24, width: 80, height: 80)
        
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        
        containerView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65).isActive = true
        
        [titleLabel , subtitleLabel, aboutMeLabel, buttonsStackView] .forEach(containerView.addSubview(_:))
        
        titleLabel.anchor(top: containerView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 24, paddingRight: 24)
        
        subtitleLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        aboutMeLabel.anchor(top: subtitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        buttonsStackView.anchor(top: aboutMeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 40, paddingRight: 24)
        
    }
    
    func configureStackView(){
        [editProfileButton, changePasswordButton, logoutButton, aboutApplicationButton, postAdButton] .forEach(buttonsStackView.addArrangedSubview(_:))
    }
    
    // MARK: - Selectors
    @objc func handleAddProfilePhoto(_ sender: UITapGestureRecognizer? = nil){
       present(imagePicker,animated: true, completion: nil)
    }
    
    @objc func handleEditProfileButton(){
        let nav = UINavigationController(rootViewController: EditProfileViewController())
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)
    }
    
    @objc func handleChangePasswordButton(){
        let nav = UINavigationController(rootViewController: ChangePasswordViewController())
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)
    }
    
    @objc func handleLogOutButton(){
        
        let dialogMessage = UIAlertController(title: "Çıkış Yap", message: "Hesabınızdan çıkış yapmak istediğinize emin misiniz?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Çıkış Yap", style: .default) { (action) -> Void in
            self.logUserOut()
            self.dismissPage()
        }
        let cancel = UIAlertAction(title: "İptal", style: .cancel) { (action) -> Void in
            print("DEBUG: Logout has been cancelled.")
        }
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    @objc func handleAboutApplicationButton(){
        let dialogMessage = UIAlertController(title: "Uygulama Hakkında", message: "Bu uygulama Hakan OR tarafından kodlanmıştır.\n\n v1.0.0 \n 2022", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Tamam", style: .cancel) { (action) -> Void in
            print("DEBUG: handleAboutApplicationButton")
        }
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @objc func handlePostAdButton(){
        let nav = UINavigationController(rootViewController: EstateTypeViewController())
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profilePhoto.image = profileImage.withRenderingMode(.alwaysOriginal)
        guard let imageData = profileImage.jpegData(compressionQuality: 0.6) else { return }
        uploadImage(imageData: imageData)
        dismiss(animated: true, completion: nil)
    }
}
