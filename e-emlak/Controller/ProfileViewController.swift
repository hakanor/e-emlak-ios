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

    // MARK: - Subviews
    private lazy var profilePhotoButton2: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "registerBg"), for: .normal)
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.layer.borderColor = themeColors.white.cgColor
        button.layer.borderWidth = 2
        return button
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
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Merhaba! Benim adım Hakan, Konya ilinde emlakçılık yapıyorum."
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = themeColors.white
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        fetchUser()
        
        [backgroundImage, containerView, profilePhoto] .forEach(view.addSubview(_:))
        
        let gestureProfilePhoto = UITapGestureRecognizer(target: self, action: #selector(self.handleAddProfilePhoto(_:)))
        profilePhoto.addGestureRecognizer(gestureProfilePhoto)
        
        profilePhoto.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: containerView.topAnchor, paddingLeft: 24, paddingBottom: -24, width: 80, height: 80)
        
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        
        containerView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65).isActive = true
        
        [titleLabel , subtitleLabel, aboutMeLabel] .forEach(containerView.addSubview(_:))
        
        titleLabel.anchor(top: containerView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 24, paddingRight: 24)
        
        subtitleLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        aboutMeLabel.anchor(top: subtitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
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
    
    // MARK: - Selectors
    @objc func handleAddProfilePhoto(_ sender: UITapGestureRecognizer? = nil){
       present(imagePicker,animated: true, completion: nil)
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
