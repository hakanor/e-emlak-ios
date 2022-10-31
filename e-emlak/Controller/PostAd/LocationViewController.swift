//
//  LocationViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 24.10.2022.
//

import Foundation
import UIKit
import Firebase
import MapKit

class LocationViewController: UIViewController{
    
    // MARK: - Properties
    var cityArray = [""]
    var townArray = [""]
    var districtArray = [""]
    var quarterArray = [""]
    var cityRow = 0
    var townRow = 0
    var districtRow = 0
    var ID = ""
    
    var pickerView = UIPickerView()
    
    var estateType = ""
    var propertyType = ""
    
    var pickedCoordinate =  CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
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
    
    private lazy var mapButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Haritadan Konum Ekle", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleMapButton), for: .touchUpInside)
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
        pickerView.delegate = self
        pickerView.dataSource = self
        cityTextField.inputView = pickerView
        townTextField.inputView = pickerView
        districtTextField.inputView = pickerView
        quarterTextField.inputView = pickerView
        setTextFieldDelegates()
        loadCities()
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handleCancel(){
        dismiss(animated: true,completion: nil)
    }
    
    @objc func handleMapButton(){
        let vc = CoordinateViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleNextButton(){
        
        guard let city = cityTextField.text else { return }
        guard let town = townTextField.text else { return }
        guard let district  = districtTextField.text else { return }
        guard let quarter  = quarterTextField.text else { return }
        
        switch propertyType {
            
        case "Konut":
            var credentials = ResidentialCredentials(estateType: "", title: "", description: "", price: "", squareMeter: "", squareMeterNet: "", location: "", uid: "", numberOfRooms: 0, numberOfBathrooms: 0, ageOfBuilding: 0, floorNumber: 0, numberOfFloors: 0, heating: "", latitude: 0, longitude: 0)
            credentials.estateType = self.estateType
            credentials.location = city + "/" + town + "/" + district + "/" + quarter
            credentials.latitude = self.pickedCoordinate.latitude
            credentials.longitude = self.pickedCoordinate.longitude
            
            let vc = ResidentialViewController()
            vc.credentials = credentials
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "İş Yeri":
            var credentials = CommercialCredentials(estateType: "", title: "", description: "", price: "", squareMeter: "", location: "", uid: "", ageOfBuilding: 0, numberOfFloors: 0, heating: "", latitude: 0, longitude: 0)
            credentials.estateType = self.estateType
            credentials.location = city + "/" + town + "/" + district + "/" + quarter
            credentials.latitude = self.pickedCoordinate.latitude
            credentials.longitude = self.pickedCoordinate.longitude
            
            let vc = CommercialViewController()
            vc.credentials = credentials
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Arsa":
            var credentials = LandCredentials(estateType: "", title: "", description: "", price: "", pricePerSquareMeter: 0, squareMeter: "", location: "", uid: "", blockNumber: 0, parcelNumber: 0, latitude: 0, longitude: 0)
            credentials.estateType = self.estateType
            credentials.location = city + "/" + town + "/" + district + "/" + quarter
            credentials.latitude = self.pickedCoordinate.latitude
            credentials.longitude = self.pickedCoordinate.longitude
            
            let vc = LandViewController()
            vc.credentials = credentials
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            print("An error occurred while selecting ViewControllers via by propertyType.")
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
        title = "İlan Ekle"
        navigationController?.navigationBar.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
        [scrollView] .forEach(view.addSubview(_:))
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        [cityLabel, cityTextField, townLabel, townTextField, districtLabel, districtTextField, quarterLabel, quarterTextField, mapButton, nextButton] .forEach(scrollView.addSubview(_:))
        
        cityLabel.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        cityTextField.anchor(top: cityLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        townLabel.anchor(top: cityTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        townTextField.anchor(top: townLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        districtLabel.anchor(top: townTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        districtTextField.anchor(top: districtLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        quarterLabel.anchor(top: districtTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        quarterTextField.anchor(top: quarterLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        mapButton.anchor(left: view.leftAnchor, bottom: nextButton.topAnchor,right: view.rightAnchor, paddingLeft: 24, paddingBottom: 8,paddingRight: 24)
        
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor, paddingLeft: 24, paddingBottom: 20,paddingRight: 24)
    }
    
    func setTextFieldDelegates(){
        cityTextField.delegate = self
        townTextField.delegate = self
        districtTextField.delegate = self
        quarterTextField.delegate = self
    }
        
}

extension LocationViewController: UIPickerViewDelegate,UIPickerViewDataSource {
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
            cityTextField.text = cityArray[row]
            cityRow = row
            loadTowns()
            pickerView.reloadAllComponents()
            townTextField.text?.removeAll()
            districtTextField.text?.removeAll()
            quarterTextField.text?.removeAll()
        }
        if townTextField.isFirstResponder{
            townTextField.text = townArray[row]
            townRow = row
            loadDistricts()
            pickerView.reloadAllComponents()
            districtTextField.text?.removeAll()
            quarterTextField.text?.removeAll()
        }
        if districtTextField.isFirstResponder{
            districtTextField.text = districtArray[row]
            districtRow = row
            loadQuarters()
            pickerView.reloadAllComponents()
            quarterTextField.text?.removeAll()
        }
        if quarterTextField.isFirstResponder{
            quarterTextField.text = quarterArray[row]
            pickerView.reloadAllComponents()
        }
        
    }
    
}

extension LocationViewController: UITextFieldDelegate{
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

extension LocationViewController: FetchCoordinateDelegate {
    func fetchCoordinate(coordinate: CLLocationCoordinate2D) {
        self.navigationController?.popViewController(animated: true)
        self.pickedCoordinate = coordinate
    }
}
