//
//  ProfileTableViewCell.swift
//  e-emlak
//
//  Created by Hakan Or on 12.12.2022.
//

import Foundation
import UIKit
import CoreData

class ProfileTableViewCellModel {
    let title: String
    let imageURL: URL?
    var imageData: Data?
    var url: String?
    var urlToImage: String?
    var publishedAt: String
    let description: String?
    var content: String?
    var sourceName: String
    
    init(
        title: String,
        imageURL: URL?,
        url : String?,
        urlToImage: String?,
        publishedAt: String,
        description: String?,
        content: String?,
        sourceName : String
    ) {
        self.title = title
        self.imageURL = imageURL
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.description = description
        self.content = content
        self.sourceName = sourceName
    }
}

class ProfileTableViewCell: UITableViewCell {
    
    var model = ProfileTableViewCellModel(title: "", imageURL: URL(string: ""), url: "", urlToImage: "", publishedAt: "", description: "", content: "", sourceName: "")
    // MARK: - Properties
    private let cornerRadiusValue : CGFloat = 16
    
    // MARK: - Subviews
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = themeColors.white
        return view
    }()
    
    private lazy var adImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "loginBg")
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadiusValue
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.dark
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "Browse"
        label.contentMode = .scaleToFill
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.grey
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.addLeading(image: UIImage(systemName: "location")?.withTintColor(themeColors.grey) ?? UIImage(), text: "Aydın/Kuşadası")
        label.contentMode = .scaleToFill
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.primary
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "153.000 ₺"
        label.contentMode = .scaleToFill
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var locationIcon: UIImageView = {
        let locationIcon = UIImageView()
        let image = UIImage(named: "location-sign")?.withTintColor(themeColors.error)
        locationIcon.image = image
        locationIcon.contentMode = .scaleAspectFit
        return locationIcon
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 70
        return stackView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "trash.fill")
        button.tintColor = .white
        button.backgroundColor = themeColors.error
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 6,left: 6, bottom: 6, right: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var activateButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "checkmark")
        button.tintColor = .white
        button.backgroundColor = themeColors.success
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 6,left: 6, bottom: 6, right: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "pencil")
        button.tintColor = .white
        button.backgroundColor = themeColors.primary
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 6,left: 6, bottom: 6, right: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        selectionStyle = .none
        contentView.addSubview(containerView)

        containerView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0)
        
        [adImage, titleLabel, locationLabel, priceLabel, locationIcon, buttonStackView] .forEach(containerView.addSubview(_:))
        
        adImage.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 150)
        
        titleLabel.anchor(top: adImage.bottomAnchor, left: containerView.leftAnchor, right:containerView.rightAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 20 )
        
        locationIcon.anchor(top: titleLabel.bottomAnchor, left:
                                containerView.leftAnchor, paddingTop: 12, paddingLeft: 20, width: 13, height: 13)
        
        locationLabel.anchor(left: locationIcon.rightAnchor, right: priceLabel.leftAnchor, paddingLeft:5, paddingRight: 10)
        
        locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor).isActive = true
        
        priceLabel.anchor(right: containerView.rightAnchor, paddingRight: 20)
        
        [deleteButton, activateButton, editButton] .forEach(buttonStackView.addArrangedSubview(_:))
        
        buttonStackView.anchor(top: locationLabel.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 14, paddingLeft: 20, paddingBottom: 14, paddingRight: 20)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = cornerRadiusValue
        containerView.layer.borderColor = themeColors.grey.cgColor
        containerView.layer.borderWidth = 0.2
    }
    
    // MARK: - Configuration
    
    func configureCells(with viewModel: ProfileTableViewCellModel){
        titleLabel.text = viewModel.title
        self.model = viewModel
        
        if let data = viewModel.imageData {
            adImage.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url){ data , _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self.adImage.image = UIImage(data:data)
                }
                
            }.resume()
        }
        
    }
    
    func configureCell(title:String, price:String, location:String, url:String){
        titleLabel.text = title
        priceLabel.text = price + " ₺"
        let locationSplitted = location.split(separator: "/")
        let locationNew = (locationSplitted[safe: 0] ?? "") + "/" + (locationSplitted[safe: 1] ?? "")
        locationLabel.text = String(locationNew)
        let formattedURL = URL(string: url)
        self.adImage.sd_setImage(with: formattedURL,completed: nil)
        
    }
    
}
