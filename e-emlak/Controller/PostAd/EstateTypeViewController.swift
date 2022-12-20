//
//  UploadAdViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 22.10.2022.
//

import Foundation
import UIKit
import Firebase

class EstateTypeViewController: UIViewController{
    
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
    
    private lazy var propertyTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Emlak Türü"
        return label
    }()
    
    private lazy var propertyTypeTextField: UITextField = {
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
    
    private lazy var categoryTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Emlak Kategorisi"
        return label
    }()
    
    private lazy var categoryTypeTextField: UITextField = {
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
        setTextFieldDelegates()
        pickerView.delegate = self
        pickerView.dataSource = self
        propertyTypeTextField.inputView = pickerView
        categoryTypeTextField.inputView = pickerView
        serviceTypeTextField.inputView = pickerView
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        dismiss(animated: true,completion: nil)
    }
    @objc func handleCancel(){
        dismiss(animated: true,completion: nil)
    }
    
    @objc func handleNextButton(){
        
        guard let propertyType = propertyTypeTextField.text else { return }
        guard let categoryType = categoryTypeTextField.text else { return }
        guard let serviceType  = serviceTypeTextField.text else { return }
        
        let estateType = propertyType + "/" + categoryType + "/" + serviceType
        
        let vc = LocationViewController()
        vc.estateType = estateType
        vc.propertyType = propertyType
        
        if self.navigationController != nil {
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let navCon = UINavigationController(rootViewController: vc)
            navCon.modalPresentationStyle = .fullScreen
            present(navCon, animated: true)
        }
        
    }
    // MARK: - API
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
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = themeColors.white
        title = "İlan Ekle"
        navigationController?.navigationBar.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        [scrollView] .forEach(view.addSubview(_:))
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        [propertyTypeLabel, propertyTypeTextField, categoryTypeLabel, categoryTypeTextField, serviceTypeLabel, serviceTypeTextField, nextButton] .forEach(scrollView.addSubview(_:))
        
        propertyTypeLabel.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        propertyTypeTextField.anchor(top: propertyTypeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        categoryTypeLabel.anchor(top: propertyTypeTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        categoryTypeTextField.anchor(top: categoryTypeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        serviceTypeLabel.anchor(top: categoryTypeTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        serviceTypeTextField.anchor(top: serviceTypeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor, paddingLeft: 24, paddingBottom: 20,paddingRight: 24)
        
    }
    
    func setTextFieldDelegates(){
        propertyTypeTextField.delegate = self
        categoryTypeTextField.delegate = self
        serviceTypeTextField.delegate = self
    }
        
}

extension EstateTypeViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if propertyTypeTextField.isFirstResponder {
            return propertyTypeArray.count
        }
        if categoryTypeTextField.isFirstResponder{
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
        if propertyTypeTextField.isFirstResponder {
            return propertyTypeArray[row]
        }
        if categoryTypeTextField.isFirstResponder{
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
        if propertyTypeTextField.isFirstResponder {
            propertyTypeTextField.text = propertyTypeArray[row]
            fetchCategoryType(name: propertyTypeTextField.text ?? "")
            pickerView.reloadAllComponents()
            categoryTypeTextField.text?.removeAll()
            serviceTypeTextField.text?.removeAll()
        }
        if categoryTypeTextField.isFirstResponder{
            categoryTypeTextField.text = categoryTypeArray[row]
            fetchServiceType(id: ID)
            pickerView.reloadAllComponents()
            serviceTypeTextField.text?.removeAll()
        }
        if serviceTypeTextField.isFirstResponder{
            serviceTypeTextField.text = serviceTypeArray[row]
            pickerView.reloadAllComponents()
        }
    }
    
}

extension EstateTypeViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == propertyTypeTextField {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
        if textField == categoryTypeTextField {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
        if textField == serviceTypeTextField {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
    }
}
