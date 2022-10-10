//
//  RegisterInfoViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 8.10.2022.
//

import UIKit

class RegisterInfoViewController: UIViewController {
    
//    MARK: - Subviews
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
    
    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "registerBg")
        backgroundImage.image = image
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        return backgroundImage
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.backgroundColor = themeColors.white
        return containerView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = themeColors.dark
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.text = "Kişisel Bilgileriniz..."
        return titleLabel
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textColor = themeColors.grey
        subtitleLabel.numberOfLines = 2
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.text = "Bilgilerin doğru olması çok önemlidir."
        return subtitleLabel
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "NAME"
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "John",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        textField.addTarget(self, action: #selector(searchFunc), for: .editingDidEndOnExit)
        return textField
       }()
    
    
    private lazy var surnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "SURNAME"
        return label
    }()
    
    private lazy var surnameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Doe",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        textField.addTarget(self, action: #selector(searchFunc), for: .editingDidEndOnExit)
        return textField
       }()

    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "PHONE NUMBER"
        return label
    }()
    
    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "+90 534 612 60 42",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.grey.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.rightImage(UIImage(systemName: "checkmark.circle"), imageWidth: 36, padding: 0, tintColor: themeColors.success)
//        textField.addTarget(self, action: #selector(searchFunc), for: .editingDidEndOnExit)
        return textField
       }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.setTitle("Next step", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - OBJC Func
    @objc func handleBackButton(){
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = themeColors.white
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        [backgroundImage, containerView, backButton] .forEach(view.addSubview(_:))
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.60).isActive = true
        
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.55).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        [titleLabel , subtitleLabel, nameLabel, nameTextField, surnameLabel, surnameTextField, phoneLabel, phoneTextField ,nextButton] .forEach(containerView.addSubview(_:))
 
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 40).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 8).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor,constant: 24).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 8).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true

        surnameLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,constant: 24).isActive = true
        surnameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        surnameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        surnameTextField.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor,constant: 8).isActive = true
        surnameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        surnameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        phoneLabel.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor,constant: 24).isActive = true
        phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        phoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor,constant: 8).isActive = true
        phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        nextButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor,constant: 24).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
    }

    
}




