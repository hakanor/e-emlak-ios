//
//  ResidentialFilterViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 21.11.2022.
//

import UIKit
import Firebase

class ResidentialFilterViewController: UIViewController {
    // MARK: - Properties
    var ads = [Ad]()
    var adsFiltered = [Ad]()
    
    var priceMin = 0
    var priceMax = 0 
    
    var estateType : String = ""
    var pickerView = UIPickerView()
    
    var numberOfRoomsArray = ["1","2","3","4","5","6"]
    var numberOfFloorsArray = ["1-5","6-10","11 ve üzeri"]
    var numberOfBathroomsArray = ["Yok","1","2","3","4","5","5 ve üzeri"]
    var ageOfBuildingArray = ["Sıfır Bina","1-5","6-10","11-15","16-20","21 ve üzeri"]

    // MARK: - SubViews
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
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
        button.setTitle("Sonuçları Göster", for: .normal)
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
    
    private lazy var squareMeterMinLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Metrekare (min)"
        return label
    }()
    
    private lazy var squareMeterMinTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Metrekare min.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var squareMeterMaxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Metrekare (max)"
        return label
    }()
    
    private lazy var squareMeterMaxTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Metrekare max.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var numberOfRoomsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Oda Sayısı"
        return label
    }()
    
    private lazy var numberOfRoomsTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Oda sayısı seçiniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var numberOfBathroomsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Banyo Sayısı"
        return label
    }()
    
    private lazy var numberOfBathroomsTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Banyo sayısı giriniz.",
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
    
    private lazy var floorNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Daire Kat Sayısı"
        return label
    }()
    
    private lazy var floorNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Daire kat sayısını giriniz.",
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
        return textField
    }()
 
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Daha fazla detay seçiniz."
        configureUI()
        pickerView.delegate = self
        pickerView.dataSource = self
        numberOfRoomsTextField.inputView = pickerView
        ageOfBuildingTextField.inputView = pickerView
        numberOfFloorsTextField.inputView = pickerView
        numberOfBathroomsTextField.inputView = pickerView
        
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
    
    @objc func handleNextButton(){
        fetchAds()
    }
    
    // MARK: - API
    func fetchAds() {
        AdService.shared.fetchAds() { fetchedAds in
            let vc = FilteredResultViewController()
            
            for ad in fetchedAds {
                if ad.estateType.contains(self.estateType) {
                    self.adsFiltered.append(ad)
                }
            }
            
            vc.ads = self.adsFiltered
            self.present(vc,animated: true,completion: nil)
        }
    }
    
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = themeColors.white
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        [scrollView, nextButton] .forEach(view.addSubview(_:))
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nextButton.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0)
        
        [squareMeterMinLabel,squareMeterMinTextField,squareMeterMaxLabel,squareMeterMaxTextField, numberOfFloorsLabel, numberOfFloorsTextField, numberOfRoomsLabel, numberOfRoomsTextField, ageOfBuildingLabel, ageOfBuildingTextField ,numberOfBathroomsLabel, numberOfBathroomsTextField, floorNumberLabel, floorNumberTextField, heatingLabel, heatingTextField] .forEach(scrollView.addSubview(_:))
        
        squareMeterMinLabel.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        squareMeterMinTextField.anchor(top: squareMeterMinLabel
            .bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        squareMeterMaxLabel.anchor(top: squareMeterMinTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        squareMeterMaxTextField.anchor(top: squareMeterMaxLabel
            .bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        ageOfBuildingLabel.anchor(top: squareMeterMaxTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        ageOfBuildingTextField.anchor(top: ageOfBuildingLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        floorNumberLabel.anchor(top: ageOfBuildingTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        floorNumberTextField.anchor(top: floorNumberLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        numberOfFloorsLabel.anchor(top: floorNumberTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        numberOfFloorsTextField.anchor(top: numberOfFloorsLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        numberOfRoomsLabel.anchor(top: numberOfFloorsTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        numberOfRoomsTextField.anchor(top: numberOfRoomsLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        numberOfBathroomsLabel.anchor(top: numberOfRoomsTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        numberOfBathroomsTextField.anchor(top: numberOfBathroomsLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        heatingLabel.anchor(top: numberOfBathroomsTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        heatingTextField.anchor(top: heatingLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        nextButton.anchor(top: scrollView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 24, paddingBottom: 0, paddingRight: 24)
        
    }
    
    func setTextFieldDelegates(){
        numberOfRoomsTextField.delegate = self
        ageOfBuildingTextField.delegate = self
        numberOfBathroomsTextField.delegate = self
        numberOfFloorsTextField.delegate = self
    }
}

extension ResidentialFilterViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
    }
}

extension ResidentialFilterViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if numberOfRoomsTextField.isFirstResponder {
            return numberOfRoomsArray.count
        }
        if ageOfBuildingTextField.isFirstResponder {
            return ageOfBuildingArray.count
        }
        if numberOfFloorsTextField.isFirstResponder {
            return numberOfFloorsArray.count
        }
        if numberOfBathroomsTextField.isFirstResponder {
            return numberOfBathroomsArray.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if numberOfRoomsTextField.isFirstResponder {
            return numberOfRoomsArray[row]
        }
        if ageOfBuildingTextField.isFirstResponder {
            return ageOfBuildingArray[row]
        }
        if numberOfFloorsTextField.isFirstResponder {
            return numberOfFloorsArray[row]
        }
        if numberOfBathroomsTextField.isFirstResponder {
            return numberOfBathroomsArray[row]
        }
        else {
            return "Boş"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if numberOfRoomsTextField.isFirstResponder {
            numberOfRoomsTextField.text = numberOfRoomsArray[row]
        }
        if ageOfBuildingTextField.isFirstResponder {
            ageOfBuildingTextField.text = ageOfBuildingArray[row]
        }
        if numberOfFloorsTextField.isFirstResponder {
            numberOfFloorsTextField.text = numberOfFloorsArray[row]
        }
        if numberOfBathroomsTextField.isFirstResponder {
            numberOfBathroomsTextField.text = numberOfBathroomsArray[row]
        }
    }
    
}

extension ResidentialFilterViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == numberOfRoomsTextField {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
        if textField == ageOfBuildingTextField {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
        if textField == numberOfFloorsTextField {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
        if textField == numberOfBathroomsTextField {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
        
    }
}
