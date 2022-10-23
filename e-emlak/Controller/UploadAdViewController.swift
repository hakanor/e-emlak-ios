//
//  UploadAdViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 22.10.2022.
//

import Foundation
import UIKit
import Firebase

class UploadAdViewController: UIViewController{
    
    // MARK: - Properties
    var propertyTypeArray = [""]
    var categoryTypeArray = [""]
    var serviceTypeArray = [""]
    var ID = ""
    
    var pickerView = UIPickerView()
    
    // MARK: - SubViews
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "arrow.left")
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
        button.setTitle("İlan detaylarını gir", for: .normal)
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
    
    private lazy var scrollStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Emlak Türü"
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Emlak türü seçiniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Emlak Kategorisi"
        return label
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Kategori seçiniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var serviceTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Servis Türü"
        return label
    }()
    
    private lazy var serviceTypeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Servis türü seçiniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.tintColor = .clear
        return textField
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPropertyType()
        pickerView.delegate = self
        pickerView.dataSource = self
        titleTextField.inputView = pickerView
        descriptionTextField.inputView = pickerView
        serviceTypeTextField.inputView = pickerView
    }
    
    // MARK: - Selectors
    @objc func handleCancel(){
        dismiss(animated: true,completion: nil)
    }
    
    @objc func handleNextButton(){
        
        guard let title = titleTextField.text else { return }
        guard let desc = descriptionTextField.text else { return }
        guard let name  = serviceTypeTextField.text else { return }
        
        var estateType = title + ">" + desc + ">" + name
        
        let vc = UploadAdDetailsViewController()
        vc.estateType = estateType
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = themeColors.white
        title = "İlan Ekle"
        navigationController?.navigationBar.backgroundColor = .white
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        [scrollView] .forEach(view.addSubview(_:))
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        [titleLabel, titleTextField, descriptionLabel, descriptionTextField, serviceTypeLabel, serviceTypeTextField, nextButton] .forEach(scrollView.addSubview(_:))
        
        titleLabel.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        titleTextField.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        descriptionLabel.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        descriptionTextField.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        serviceTypeLabel.anchor(top: descriptionTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        serviceTypeTextField.anchor(top: serviceTypeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor, paddingLeft: 24, paddingBottom: 20,paddingRight: 24)
        
    }
    
    
    func fetchPropertyType(){
        self.propertyTypeArray.removeAll()
        
        Firestore.firestore().collection("propertyType").getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = snapshot?.documents else { return }
            
            for document in data {
                let documentID = document.documentID
                self.ID = documentID
                if let name = document.get("name") {
                    self.propertyTypeArray.append(name as! String)
                }
            }
            
        }
    }
    
    func fetchCategoryType(name:String){
        self.categoryTypeArray.removeAll()
        Firestore.firestore().collection("propertyType").whereField("name", isEqualTo: name).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = snapshot?.documents else { return }
            for document in data {
                let documentID = document.documentID
                self.ID = documentID
            }
            
            Firestore.firestore().collection("categoryType").whereField("propertyTypeID", isEqualTo: self.ID).getDocuments { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let data = snapshot?.documents else { return }
                for document in data {
                    if let name = document.get("name") {
                        self.categoryTypeArray.append(name as! String)
                    }
                }
            }
            
        }
        
       
    }
  
    func fetchServiceType(id:String){
        self.serviceTypeArray.removeAll()
        Firestore.firestore().collection("serviceType").whereField("propertyTypeID",arrayContains: id).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = snapshot?.documents else { return }

            for document in data {
                if let name = document.get("name") {
                    self.serviceTypeArray.append(name as! String)
                }
            }
                
        }
    }
        
}

extension UploadAdViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if titleTextField.isFirstResponder {
            return propertyTypeArray.count
        }
        if descriptionTextField.isFirstResponder{
            return categoryTypeArray.count
        }
        if serviceTypeTextField.isFirstResponder{
            return serviceTypeArray.count
        }
        else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if titleTextField.isFirstResponder {
            return propertyTypeArray[row]
        }
        if descriptionTextField.isFirstResponder{
            return categoryTypeArray[row]
        }
        if serviceTypeTextField.isFirstResponder{
            return serviceTypeArray[row]
        }
        else {
            return "Boş"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if titleTextField.isFirstResponder {
            titleTextField.text = propertyTypeArray[row]
            fetchCategoryType(name: titleTextField.text ?? "")
            descriptionTextField.text = "Kategori seçiniz."
            serviceTypeTextField.text = "Servis türü seçiniz."
        }
        if descriptionTextField.isFirstResponder{
            descriptionTextField.text = categoryTypeArray[row]
            fetchServiceType(id: ID)
            serviceTypeTextField.text = "Servis türü seçiniz."
        }
        if serviceTypeTextField.isFirstResponder{
            serviceTypeTextField.text = serviceTypeArray[row]
        }
    }
    
}
