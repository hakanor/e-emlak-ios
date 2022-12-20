//
//  EditProfileViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 20.12.2022.
//

import Foundation
import UIKit
import Firebase

class EditProfileViewController: UIViewController{
    
    // MARK: - Properties
    var cityArray = [""]
    var uid = ""
    
    var pickerView = UIPickerView()
    var cityRow = 0


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
        button.setTitle("Profilimi Düzenle", for: .normal)
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
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "İsim"
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "İsim giriniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        return textField
    }()
    
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = themeColors.lightGrey
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    private lazy var surnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Soyisim"
        return label
    }()
    
    private lazy var surnameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Soyisim giriniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        return textField
    }()

    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Telefon Numarası (Brüt)"
        return label
    }()
    
    private lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Telefon Numarası giriniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.addTarget(self, action: #selector(handlePhoneTextField), for: .allEditingEvents)
        return textField
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Şehir"
        return label
    }()
    
    private lazy var cityTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Şehir giriniz.",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        return textField
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Email"
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.setUnderLine()
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var aboutMeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Profil Açıklaması"
        return label
    }()
    
    private lazy var aboutMeTextField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.center = self.view.center
        textField.contentInsetAdjustmentBehavior = .automatic
        textField.textAlignment = .left
        textField.isScrollEnabled = false
        return textField
    }()
    
    private lazy var characterLimitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.grey
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "0/0"
        return label
    }()
  
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUserData()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        cityTextField.inputView = pickerView
        
        cityTextField.delegate = self
        aboutMeTextField.delegate = self
        
        loadCities()
        
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        self.dismiss(animated: true)
    }
    
    @objc func handlePhoneTextField(){
        phoneNumberTextField.text = formatPhone(phoneNumberTextField.text ?? "")
        isValidNumber(tf: phoneNumberTextField)
    }
    
    @objc func handleNextButton(){
        
        guard nameTextField.text != nil else { return }
        guard surnameTextField.text != nil else { return }
        guard cityTextField.text != nil else { return }
        guard aboutMeTextField.text != nil else { return }
        guard phoneNumberTextField.text != nil else { return }
        
        if checkRegisterFields() != "" {
            self.view.makeToast(checkRegisterFields(), duration: 3.0, position: .bottom)
        } else {
            let myDict:[String:String] = [
                "name":nameTextField.text ?? "",
                "surname":surnameTextField.text ?? "",
                "city":cityTextField.text ?? "",
                "phoneNumber":phoneNumberTextField.text ?? "",
                "aboutMe":aboutMeTextField.text ?? "",
            ]
            
            updateUserData(uid: self.uid, dictionary: myDict)
            let dialogMessage = UIAlertController(title: "Profil Düzeneleme", message: "Profil düzenleme işlemi başarıyla tamamlandı.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Tamam", style: .cancel) { (action) -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        
    }
    // MARK: - API
    func fetchUserData(){
        UserService.shared.fetchUser { user in
            self.uid = user.uid
            self.nameTextField.text = user.name
            self.surnameTextField.text = user.surname
            self.phoneNumberTextField.text = user.phoneNumber
            self.cityTextField.text = user.city
            self.aboutMeTextField.text = user.aboutMe
            self.emailTextField.text = user.email
            self.characterLimitLabel.text = String(user.aboutMe.count) + "/100"
        }
    }
    
    func loadCities(){
        let data = DataLoader().cityData
        cityArray.removeAll()
        for city in data {
            cityArray.append(city.name)
        }
    }
    
    private func updateUserData(uid:String, dictionary:[String:Any]){
        AuthService.shared.updateUser(uid: uid, dictionary: dictionary) { (error) in
            
        }
    }
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = themeColors.white
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.title = "Profilimi Düzenle"
        
        [scrollView, nextButton] .forEach(view.addSubview(_:))
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nextButton.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0)
        
        [nameLabel, nameTextField, cityLabel, cityTextField, aboutMeLabel, aboutMeTextField, surnameLabel, surnameTextField, divider,  phoneNumberLabel,phoneNumberTextField, emailLabel, emailTextField, characterLimitLabel] .forEach(scrollView.addSubview(_:))
        
        nameLabel.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        nameTextField.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        surnameLabel.anchor(top: nameTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        surnameTextField.anchor(top: surnameLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        cityLabel.anchor(top: surnameTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)

        cityTextField.anchor(top: cityLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)

        phoneNumberLabel.anchor(top: cityTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)

        phoneNumberTextField.anchor(top: phoneNumberLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        emailLabel.anchor(top: phoneNumberTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)

        emailTextField.anchor(top: emailLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        aboutMeLabel.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)

        aboutMeTextField.anchor(top: aboutMeLabel
            .bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        characterLimitLabel.anchor(top: aboutMeTextField
            .bottomAnchor, right: view.rightAnchor, paddingTop: 4, paddingRight: 24)

        divider.anchor(top: aboutMeTextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 24, paddingRight: 24, height: 1)
        
        nextButton.anchor(top: scrollView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 24, paddingBottom: 0, paddingRight: 24)
        
    }
    
    func isValidNumber(tf: UITextField){
        if tf.text?.count == 13 {
            tf.rightImage(UIImage(systemName: "checkmark.circle"), imageWidth: 40, padding: 0, tintColor: themeColors.success)
        } else {
            tf.rightImage(UIImage(systemName: "x.circle"), imageWidth: 40, padding: 0, tintColor: themeColors.error)
        }
    }
    
    private func formatPhone(_ number: String) -> String {
        let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let format: [Character] = ["X", "X", "X", "X", "-", "X", "X", "X", "-", "X", "X", "X", "X"]

        var result = ""
        var index = cleanNumber.startIndex
        for ch in format {
            if index == cleanNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func checkRegisterFields() -> String {
        guard nameTextField.text != "" else { return "İsim alanı boş olamaz."}
        guard surnameTextField.text != "" else { return "Soyisim alanı boş olamaz."}
        guard cityTextField.text != "" else { return "Şehir alanı boş olamaz."}
        guard phoneNumberTextField.text != "" else { return "Telefon numarası alanı boş olamaz."}
        guard aboutMeTextField.text != "" else { return "Profil açıklaması alanı boş olamaz."}
        
        if phoneNumberTextField.text?.count == 13 {
        } else {
            return "Telefon numarası doğru formatta değil"
        }
        
        return ""
    }
        
}

extension EditProfileViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if cityTextField.isFirstResponder {
            return cityArray.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if cityTextField.isFirstResponder {
            return cityArray[row]
        }
        else {
            return "Boş"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if cityTextField.isFirstResponder {
            cityTextField.text = cityArray[safe: row]
            cityRow = row
            pickerView.reloadAllComponents()
        }
    }
    
}

extension EditProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        characterLimitLabel.text = String(textView.text.count) + "/100"
          if(textView.text.count >= 100 && range.length == 0) {
              characterLimitLabel.textColor = .red
              return false
          } else {
              characterLimitLabel.textColor = themeColors.grey
          }

          return true
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == cityTextField {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
    }
}

