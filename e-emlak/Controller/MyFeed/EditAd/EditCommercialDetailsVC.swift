//
//  EditCommercialDetailsVC.swift
//  e-emlak
//
//  Created by Hakan Or on 26.12.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import Photos
import PhotosUI

class EditCommercialDetailsVC: UIViewController{
    
    // MARK: - Properties
    var estateType : String = ""
    var images = [Data]()
    var ad = Ad(adId: "", dictionary: ["":""])

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
        setData()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 200)
    }
    
    init(ad:Ad) {
        self.ad = ad
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
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
        guard let numberOfFloors  = numberOfFloorsTextField.text else { return }
        guard let ageOfBuilding  = ageOfBuildingTextField.text else { return }
        guard let heating  = heatingTextField.text else { return }
        
        if checkTextFields() != "" {
            self.view.makeToast(checkTextFields(), duration: 3.0, position: .bottom)
        } else {
            
            let dict = [
                "title":title,
                "description":desc,
                "price":price,
                "squareMeter":meter,
                "numberOfFloors" : Int(numberOfFloors) ?? 0,
                "ageOfBuilding" : Int(ageOfBuilding) ?? 0,
                "heating" : heating
            ] as [String : Any]
            
            FirFile.shared.startUploading(images: images, id: ad.adId)
            
            AdService.shared.updateAd(adId: self.ad.adId, dictionary: dict) {
                let dialogMessage = UIAlertController(title: "İlan detay güncelleme", message: "İlanınızın detay bilgileri başarıyla güncellendi.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Tamam", style: .cancel) { (action) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }
                dialogMessage.addAction(cancel)
                self.present(dialogMessage, animated: true, completion: nil)
            }
        }
        // update data
        
    }
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = themeColors.white
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
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
    
    private func setData(){
        self.titleTextField.text = self.ad.title
        self.descriptionTextField.text = self.ad.description
        self.priceTextField.text = self.ad.price
        self.squareMeterTextField.text = String(self.ad.squareMeter)
        self.ageOfBuildingTextField.text = String(self.ad.ageOfBuilding)
        self.numberOfFloorsTextField.text = String(self.ad.numberOfFloors)
        self.heatingTextField.text = self.ad.heating
        
        var urls = self.ad.images
        
        downloadImages(forURLs: urls) { images in
            self.images = images
            self.collectionView.reloadData()
        }
        
    }
    
    private func downloadImages(forURLs urls: [String], completion: @escaping ([Data]) -> Void) {
        let group = DispatchGroup()
        var images: [Data] = .init(repeating: Data(), count: urls.count)
        
        for (index, urlString) in urls.enumerated() {
            group.enter()
            DispatchQueue.global().async {
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        images[index] = data
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
    
    private func checkTextFields() -> String {
        guard titleTextField.text != "" else { return "İlan başlığı alanı boş olamaz."}
        guard descriptionTextField.text != "" else { return "İlan açıklaması alanı boş olamaz."}
        guard priceTextField.text != "" else { return "Fiyat alanı boş olamaz."}
        guard squareMeterTextField.text != "" else { return "Metrekare(Brüt) alanı boş olamaz."}
        guard ageOfBuildingTextField.text != "" else { return "Bina yaşı alanı boş olamaz."}
        guard numberOfFloorsTextField.text != "" else { return "Bina kat sayısı alanı boş olamaz."}
        guard heatingTextField.text != "" else { return "Isıtma alanı boş olamaz."}
        return ""
    }
        
}

extension EditCommercialDetailsVC: PHPickerViewControllerDelegate {
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

extension EditCommercialDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell else { fatalError() }
        cell.imageView.image = UIImage(data: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath){
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
