//
//  FilterViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 21.11.2022.
//

import UIKit
import Foundation
import Firebase

class FilterViewController: UIViewController{
    // MARK: - Properties
    
    var propertyType = ""
    var propertyTypeArray = [""]
    var categoryTypeArray = [""]
    var serviceTypeArray = [""]
    var ID = ""
    
    var cityArray = [""]
    var townArray = [""]
    var districtArray = [""]
    var quarterArray = [""]
    var cityRow = 0
    var townRow = 0
    var districtRow = 0
    
    var pickerView = UIPickerView()

    // MARK: - Subviews
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "arrow.left")
        button.tintColor = themeColors.dark
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
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
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.primary
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Emlak Kategorisi"
        return label
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
        label.text = "Kategori"
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
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.primary
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Konum"
        return label
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "İl"
        return label
    }()
    
    private lazy var cityTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "İl seçiniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var townLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "İlçe"
        return label
    }()
    
    private lazy var townTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "İlçe seçiniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var districtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Semt"
        return label
    }()
    
    private lazy var districtTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Semt seçiniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var quarterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Mahalle"
        return label
    }()
    
    private lazy var quarterTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Mahalle seçiniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.primary
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "Fiyat"
        return label
    }()
    
    // TODO: -
    var priceStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 10
        return view
    }()
    
    private lazy var priceMinTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "En Az",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        
        let label = UILabel()
        label.text = "₺"
        label.textColor = themeColors.grey.withAlphaComponent(0.6)
        textField.rightView = label
        textField.rightViewMode = .always
        textField.setUnderLine()

        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var priceMaxTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "En Çok",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        let label = UILabel()
        label.text = "₺"
        label.textColor = themeColors.grey.withAlphaComponent(0.6)
        textField.rightView = label
        textField.rightViewMode = .always
        textField.setUnderLine()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Ekle", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        configureUI()
        title = "İlanları Filtrele"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        fetchPropertyType()
        loadCities()
        setTextFieldDelegates()
        pickerView.delegate = self
        pickerView.dataSource = self
        propertyTypeTextField.inputView = pickerView
        categoryTypeTextField.inputView = pickerView
        serviceTypeTextField.inputView = pickerView
        cityTextField.inputView = pickerView
        townTextField.inputView = pickerView
        districtTextField.inputView = pickerView
        quarterTextField.inputView = pickerView
    }

    // MARK: - Selectors
    @objc func handleBackButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNextButton(){
        propertyType = propertyTypeTextField.text ?? ""
        switch propertyType {
            
        case "Konut":
            let vc = ResidentialFilterViewController()
            vc.priceMin = Int(self.priceMinTextField.text ?? "") ?? 0
            vc.priceMax = Int(self.priceMaxTextField.text ?? "") ?? 0
            vc.estateType = propertyType
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "İş Yeri":
            let vc = CommercialFilterViewController()
            vc.priceMin = Int(self.priceMinTextField.text ?? "") ?? 0
            vc.priceMax = Int(self.priceMaxTextField.text ?? "") ?? 0
            vc.estateType = propertyType
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Arsa":
            let vc = LandFilterViewController()
            vc.estateType = propertyType
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            self.view.makeToast("Emlak Türü alanının doldurulması gerekmektedir.", duration: 3.0, position: .bottom)
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
    
    // -- City
    func loadCities(){
        let data = DataLoader().cityData
        cityArray.removeAll()
        townArray.removeAll()
        districtArray.removeAll()
        quarterArray.removeAll()
        for city in data {
            cityArray.append(city.name)
        }
    }
    
    func loadTowns(){
        let data = DataLoader().cityData
        let ref = data[cityRow].towns
        townArray.removeAll()
        districtArray.removeAll()
        quarterArray.removeAll()
        for i in ref {
            townArray.append(i.name)
        }
    }
    
    func loadDistricts(){
        let data = DataLoader().cityData
        let ref = data[cityRow].towns[townRow].districts
        districtArray.removeAll()
        quarterArray.removeAll()
        for i in ref {
            districtArray.append(i.name)
        }
    }
    
    func loadQuarters(){
        let data = DataLoader().cityData
        let ref = data[cityRow].towns[townRow].districts[districtRow].quarters
        quarterArray.removeAll()
        for i in ref {
            quarterArray.append(i.name)
        }
    }

    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = themeColors.white
        
        [scrollView] .forEach(view.addSubview(_:))
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        [categoryLabel,propertyTypeLabel, propertyTypeTextField, categoryTypeLabel, categoryTypeTextField, serviceTypeLabel, serviceTypeTextField] .forEach(scrollView.addSubview(_:))
        
        categoryLabel.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        propertyTypeLabel.anchor(top: categoryLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        propertyTypeTextField.anchor(top: propertyTypeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        categoryTypeLabel.anchor(top: propertyTypeTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        categoryTypeTextField.anchor(top: categoryTypeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        serviceTypeLabel.anchor(top: categoryTypeTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        serviceTypeTextField.anchor(top: serviceTypeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        [locationLabel,cityLabel, cityTextField, townLabel, townTextField, districtLabel, districtTextField, quarterLabel, quarterTextField] .forEach(scrollView.addSubview(_:))
        
        locationLabel.anchor(top: serviceTypeTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        cityLabel.anchor(top: locationLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        cityTextField.anchor(top: cityLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        townLabel.anchor(top: cityTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        townTextField.anchor(top: townLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        districtLabel.anchor(top: townTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        districtTextField.anchor(top: districtLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        quarterLabel.anchor(top: districtTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        quarterTextField.anchor(top: quarterLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
       
        [priceLabel, priceStackView, nextButton] .forEach(scrollView.addSubview(_:))
        
        priceLabel.anchor(top: quarterTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        [priceMinTextField, priceMaxTextField] .forEach(priceStackView.addArrangedSubview(_:))
        
        priceStackView.anchor(top: priceLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
//        priceMinTextField.anchor(top: priceLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
//
//        priceMaxTextField.anchor(top: priceMinTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor, paddingLeft: 24, paddingBottom: 20,paddingRight: 24)
 

    }
    
    func setTextFieldDelegates(){
        propertyTypeTextField.delegate = self
        categoryTypeTextField.delegate = self
        serviceTypeTextField.delegate = self
        
        cityTextField.delegate = self
        townTextField.delegate = self
        districtTextField.delegate = self
        quarterTextField.delegate = self
    }
    
}

extension FilterViewController: UIPickerViewDelegate,UIPickerViewDataSource {
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
        if cityTextField.isFirstResponder {
            return cityArray.count
        }
        if townTextField.isFirstResponder{
            return townArray.count
        }
        if districtTextField.isFirstResponder{
            return districtArray.count
        }
        if quarterTextField.isFirstResponder{
            return quarterArray.count
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
        if cityTextField.isFirstResponder {
            return cityArray[safe: row]
        }
        if townTextField.isFirstResponder{
            return townArray[safe: row]
        }
        if districtTextField.isFirstResponder{
            return districtArray[safe: row]
        }
        if quarterTextField.isFirstResponder{
            return quarterArray[safe: row]
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
        if cityTextField.isFirstResponder {
            cityTextField.text = cityArray[safe: row]
            cityRow = row
            loadTowns()
            pickerView.reloadAllComponents()
            townTextField.text?.removeAll()
            districtTextField.text?.removeAll()
            quarterTextField.text?.removeAll()
        }
        if townTextField.isFirstResponder{
            townTextField.text = townArray[safe: row]
            townRow = row
            loadDistricts()
            pickerView.reloadAllComponents()
            districtTextField.text?.removeAll()
            quarterTextField.text?.removeAll()
        }
        if districtTextField.isFirstResponder{
            districtTextField.text = districtArray[safe: row]
            districtRow = row
            loadQuarters()
            pickerView.reloadAllComponents()
            quarterTextField.text?.removeAll()
        }
        if quarterTextField.isFirstResponder{
            quarterTextField.text = quarterArray[safe: row]
            pickerView.reloadAllComponents()
        }
    }
    
}

extension FilterViewController: UITextFieldDelegate{
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
        if textField == cityTextField {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
        if textField == townTextField {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
        if textField == districtTextField {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
        if textField == quarterTextField {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
    }
}
