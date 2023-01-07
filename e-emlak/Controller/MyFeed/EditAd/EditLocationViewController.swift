//
//  EditLocationViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 25.12.2022.
//

import Foundation
import UIKit
import Firebase
import MapKit

class EditLocationViewController: UIViewController{
    
    // MARK: - Properties
    var cityArray = [""]
    var townArray = [""]
    var districtArray = [""]
    var quarterArray = [""]
    var cityRow = 0
    var townRow = 0
    var districtRow = 0
    
    var adId = ""
    var city = ""
    var town = ""
    var district = ""
    var quarter = ""
    
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
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Düzenle", for: .normal)
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setTextFieldData()
        pickerView.delegate = self
        pickerView.dataSource = self
        cityTextField.inputView = pickerView
        townTextField.inputView = pickerView
        districtTextField.inputView = pickerView
        quarterTextField.inputView = pickerView
        setTextFieldDelegates()
        loadCities()
    }
    
    init(adId:String , location:String) {
        let splittedLocation = location.split(separator: "/")
        self.city = String(splittedLocation[0])
        self.town = String(splittedLocation[1])
        self.district = String(splittedLocation[2])
        self.quarter = String(splittedLocation[3])
        self.adId = adId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        dismiss(animated: true,completion: nil)
    }

    @objc func handleNextButton(){
        
        guard let city = cityTextField.text else { return }
        guard let town = townTextField.text else { return }
        guard let district  = districtTextField.text else { return }
        guard let quarter  = quarterTextField.text else { return }
        
        if checkTextFields() != "" {
            self.view.makeToast(checkTextFields(), duration: 3.0, position: .bottom)
        } else {
            let location = city + "/" + town + "/" + district + "/" + quarter

            let dict = ["location":location]
            AdService.shared.updateAd(adId: self.adId, dictionary: dict) {
                let dialogMessage = UIAlertController(title: "Konum Değiştirme", message: "İlanınızın konum bilgileri başarıyla güncellendi.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Tamam", style: .cancel) { (action) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }
                dialogMessage.addAction(cancel)
                self.present(dialogMessage, animated: true, completion: nil)
            }
        }
        
    }
    // MARK: - API
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
        title = "İlan konumu güncelle"
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        [scrollView] .forEach(view.addSubview(_:))
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        [cityLabel, cityTextField, townLabel, townTextField, districtLabel, districtTextField, quarterLabel, quarterTextField, nextButton] .forEach(scrollView.addSubview(_:))
        
        cityLabel.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        cityTextField.anchor(top: cityLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        townLabel.anchor(top: cityTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        townTextField.anchor(top: townLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        districtLabel.anchor(top: townTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        districtTextField.anchor(top: districtLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        quarterLabel.anchor(top: districtTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        quarterTextField.anchor(top: quarterLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor, paddingLeft: 24, paddingBottom: 20,paddingRight: 24)
    }
    
    func setTextFieldDelegates(){
        cityTextField.delegate = self
        townTextField.delegate = self
        districtTextField.delegate = self
        quarterTextField.delegate = self
    }
    
    func setTextFieldData(){
        self.cityTextField.text = self.city
        
        self.quarterTextField.text = self.quarter
        self.townTextField.text = self.town
        self.districtTextField.text = self.district
    }
    
    private func checkTextFields() -> String {
        guard cityTextField.text != "" else { return "İl alanı boş olamaz."}
        guard townTextField.text != "" else { return "İlçe alanı boş olamaz."}
        guard districtTextField.text != "" else { return "Semt alanı boş olamaz."}
        guard quarterTextField.text != "" else { return "Mahalle alanı boş olamaz."}
        return ""
    }
        
}

extension EditLocationViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
        if cityTextField.isFirstResponder {
            return cityArray[row]
        }
        if townTextField.isFirstResponder{
            return townArray[row]
        }
        if districtTextField.isFirstResponder{
            return districtArray[row]
        }
        if quarterTextField.isFirstResponder{
            return quarterArray[row]
        }
        else {
            return "Boş"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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

extension EditLocationViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
