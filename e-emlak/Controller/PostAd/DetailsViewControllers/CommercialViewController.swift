//
//  CommercialViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 28.10.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import Photos
import PhotosUI

class CommercialViewController: UIViewController{
    
    // MARK: - Properties
    var estateType : String = ""
    var credentials = CommercialCredentials(estateType: "", title: "", description: "", price: "", squareMeter: "", location: "", uid: "", ageOfBuilding: 0, numberOfFloors: 0, heating: "", latitude: 0, longitude: 0)
    var images = [Data]()

    // MARK: - SubViews
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        let cv = UICollectionView(frame: .zero,collectionViewLayout: layout)
        cv.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "arrow.left")
        button.tintColor = .black
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "multiply")
        button.tintColor = .black
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("İlanı Ekle", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = themeColors.white
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "İlan Başlığı"
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Başlık giriniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "İlan Açıklaması"
        return label
    }()
    
    private lazy var descriptionTextField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.center = self.view.center
        textField.contentInsetAdjustmentBehavior = .automatic
        textField.textAlignment = .justified
        textField.isScrollEnabled = false
        textField.setPlaceholder(placeholder: "Açıklama giriniz.")
        return textField
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = themeColors.lightGrey
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Fiyat"
        return label
    }()
    
    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Fiyat giriniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.keyboardType = .numberPad
        return textField
    }()

    private lazy var squareMeterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Metrekare (Brüt)"
        return label
    }()
    
    private lazy var squareMeterTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Metrekare giriniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var ageOfBuildingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Bina Yaşı"
        return label
    }()
    
    private lazy var ageOfBuildingTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Bina yaşı giriniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var numberOfFloorsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Bina Kat Sayısı"
        return label
    }()
    
    private lazy var numberOfFloorsTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Bina kat sayısı giriniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var heatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Isıtıma"
        return label
    }()
    
    private lazy var heatingTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Isıtıma türünü giriniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var photoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "İlan Fotoğrafları seçiniz."
        return label
    }()
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        let image = UIImage(systemName: "photo")
        button.setImage(image, for: .normal)
        button.backgroundColor = themeColors.grey
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        collectionView.dataSource = self
        collectionView.delegate = self
        descriptionTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleCancel(){
        dismiss(animated: true,completion: nil)
    }
    
    @objc func handleAddPhoto(){
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 6
        config.filter = .images
        images.removeAll()
        collectionView.reloadData()
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc,animated: true)
    }
    
    @objc func handleNextButton(){
        
        guard let title = titleTextField.text else { return }
        guard let desc = descriptionTextField.text else { return }
        guard let price  = priceTextField.text else { return }
        guard let meter  = squareMeterTextField.text else { return }
        guard let ageOfBuilding  = ageOfBuildingTextField.text else { return }
        guard let numberOfFloors  = numberOfFloorsTextField.text else { return }
        guard let heating  = heatingTextField.text else { return }
        
        self.credentials.title = title
        self.credentials.description = desc
        self.credentials.price = price
        self.credentials.squareMeter = meter
        self.credentials.ageOfBuilding = Int(ageOfBuilding) ?? 0
        self.credentials.numberOfFloors = Int(numberOfFloors) ?? 0
        self.credentials.heating = heating
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            self.credentials.uid = uid
        }
        
        AdService.shared.postAd(commercialCredentials: credentials, images: self.images) { (error) in
            print("DEBUG: Posting of commercial AD is successful")
            let dialogMessage = UIAlertController(title: "İlan Ekleme", message: "İlanınız başarıyla oluşturuldu.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Tamam", style: .cancel) { (action) -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        
    }
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = themeColors.white
        title = self.credentials.estateType
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        [scrollView, nextButton] .forEach(view.addSubview(_:))
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nextButton.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0)
        
        [titleLabel, titleTextField, descriptionLabel, descriptionTextField, priceLabel, priceTextField, squareMeterLabel,squareMeterTextField, ageOfBuildingLabel, ageOfBuildingTextField, numberOfFloorsLabel, numberOfFloorsTextField, heatingLabel, heatingTextField, divider, photoLabel, addPhotoButton, collectionView] .forEach(scrollView.addSubview(_:))
        
        titleLabel.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        titleTextField.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        descriptionLabel.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        descriptionTextField.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 19, paddingRight: 19)
        
        divider.anchor(top: descriptionTextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 24, paddingRight: 24, height: 1)
        
        priceLabel.anchor(top: divider.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        priceTextField.anchor(top: priceLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        squareMeterLabel.anchor(top: priceTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        squareMeterTextField.anchor(top: squareMeterLabel
            .bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        ageOfBuildingLabel.anchor(top: squareMeterTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        ageOfBuildingTextField.anchor(top: ageOfBuildingLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        numberOfFloorsLabel.anchor(top: ageOfBuildingTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        numberOfFloorsTextField.anchor(top: numberOfFloorsLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        heatingLabel.anchor(top: numberOfFloorsTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        heatingTextField.anchor(top: heatingLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        photoLabel.anchor(top: heatingTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        addPhotoButton.anchor(top: photoLabel.bottomAnchor, left: view.leftAnchor,  paddingTop: 8, paddingLeft: 24,width: 42,height: 42)
        
        collectionView.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 24, paddingBottom: 100 ,paddingRight: 24, height: 350)
        
        nextButton.anchor(top: scrollView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 24, paddingBottom: 0, paddingRight: 24)
        
    }
        
}

extension CommercialViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
    }
}

extension CommercialViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let group = DispatchGroup()
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self){ reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                guard let imageData = image.jpegData(compressionQuality: 0.6) else { return }
                self.images.append(imageData)
                group.leave()
            }
        }
        group.notify(queue: .main){
            self.collectionView.reloadData()
        }
    }
}

extension CommercialViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell else { fatalError() }
        cell.imageView.image = UIImage(data: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath){
//        images.remove(at: indexPath.row)
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
        self.imageTapped(image: UIImage(data: images[indexPath.row]) ?? UIImage())
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

