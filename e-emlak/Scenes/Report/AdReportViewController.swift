//
//  AdReportViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 17.04.2023.
//

import Foundation
import UIKit

private enum AdReportOptions: String, CaseIterable {
    case soldOrRentedService = "Hizmet satılmış ya da kiralanmış."
    case incorrectCategory = "İlan kategorisi hatalı."
    case incorrectInformation = "İlan bilgileri hatalı veya yanlış."
    case multiplePublications = "İlan birden fazla kere yayımlanmış."
    case other = "Diğer"
}

class AdReportViewController: UIViewController, AlertDisplayable {
    
    // MARK: - Properties
    var reporterId = ""
    var adId = ""
    var userId = ""
    
    // MARK: - Subviews
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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Yorum Ekle"
        return label
    }()
    
    private lazy var descriptionTextField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.center = self.view.center
        textField.contentInsetAdjustmentBehavior = .automatic
        textField.textAlignment = .justified
        textField.isScrollEnabled = false
        textField.setPlaceholder(placeholder: "Açıklama giriniz.")
        return textField
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Şikayet Et", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.error
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(adId: String, reporterId: String, userId:String) {
        self.reporterId = reporterId
        self.userId = userId
        self.adId = adId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        descriptionTextField.delegate = self
    }
    
    // MARK: - Selectors
    @objc private func handleBack(){
        self.dismiss(animated: true)
    }
    
    // MARK: - Helpers
    private func configureUI(){
        view.backgroundColor = themeColors.white
        title = "İlanı Şikayet Et"
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        [stackView, descriptionLabel, descriptionTextField, nextButton] .forEach(view.addSubview(_:))

        for option in AdReportOptions.allCases {
            let button = createOption(title: option.rawValue)
            stackView.addArrangedSubview(button)
        }

        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingRight: 24)
        
        descriptionLabel.anchor(top: stackView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 25, paddingLeft: 24, paddingRight: 24)
        
        descriptionTextField.anchor(top: descriptionLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 5, paddingLeft: 19, paddingRight: 19)
        
        nextButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 24, paddingBottom: 0, paddingRight: 24)
    }
    
    private func createOption(title: String) -> UIButton {
        let radioButton = UIButton()
        radioButton.setTitle(title, for: .normal)
        radioButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        radioButton.setTitleColor(.black, for: .normal)
        radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        radioButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .selected)
        radioButton.addTarget(self, action: #selector(radioButtonTapped(sender:)), for: .touchUpInside)
        return radioButton
    }
    
    // MARK: - Selectors
    @objc private func radioButtonTapped(sender: UIButton) {
        for subview in stackView.arrangedSubviews {
            if let button = subview as? UIButton {
                button.isSelected = button == sender
            }
        }
    }
    
    @objc private func handleNextButton(){
        var selectedOption: UIButton? = nil
        for subview in stackView.arrangedSubviews {
            if let button = subview as? UIButton, button.isSelected {
                selectedOption = button
                break
            }
        }
        
        if let selectedOption = selectedOption {
            
            let credentials = AdReportCredentials(reportCategory: selectedOption.titleLabel?.text ?? "", adId: self.adId, description: self.descriptionTextField.text, reporterId: self.reporterId, userId: self.userId)
            
            ReportService.shared.postAdReport(adReportCredentials: credentials) { (error)  in
                print("DEBUG: Report is succesfull")
                let dialogMessage = UIAlertController(title: "Teşekkürler", message: "Raporunuz başarıyla gönderildi.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Tamam", style: .cancel) { (action) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }
                dialogMessage.addAction(cancel)
                self.present(dialogMessage, animated: true, completion: nil)
            }
        }
        else {
            self.showAlert(title: "Uyarı", message: "Şikayet etmek için bir kategori seçmeniz gerekmektedir.")
        }
    }
}

extension AdReportViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
    }
}
