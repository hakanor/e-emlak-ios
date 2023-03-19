//
//  MapListTableViewCell.swift
//  e-emlak
//
//  Created by Hakan Or on 18.03.2023.
//

import Foundation
import UIKit

class MapListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var ad = Ad(adId: "String", dictionary: ["String" : nil])
    private let cornerRadiusValue : CGFloat = 16
    var delegate: MapListTableClickDelegate?
    var cellIndex: IndexPath?
    
    // MARK: - Subviews
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = themeColors.white
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var adImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "loginBg")
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadiusValue
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.dark
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Browse"
        label.contentMode = .scaleToFill
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.primary
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "153.000 ₺"
        label.contentMode = .scaleToFill
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var navigateButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "chevron.forward")?.withTintColor(themeColors.dark).withInset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        button.contentMode = .scaleAspectFit
        button.setImage(image, for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleNavigateButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(containerView)

        containerView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0)
        
        [adImage, stackView, navigateButton] .forEach(containerView.addSubview(_:))
        
        [titleLabel, priceLabel] .forEach(stackView.addArrangedSubview(_:))
        
        adImage.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, paddingTop: 3, paddingLeft: 3, paddingBottom: 3, paddingRight: 0, width: 50, height: 50)
        adImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        stackView.anchor(top: containerView.topAnchor, left: adImage.rightAnchor, bottom: containerView.bottomAnchor, right: navigateButton.leftAnchor, paddingLeft: 12)
        
        navigateButton.anchor(top: containerView.topAnchor,bottom: containerView.bottomAnchor,right: containerView.rightAnchor,paddingTop: 8, paddingBottom: 8, paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.borderColor = themeColors.grey.cgColor
        containerView.layer.borderWidth = 0.2
        
        adImage.layer.borderColor = themeColors.grey.cgColor
        adImage.layer.borderWidth = 1
    }
    
    // MARK: - Selectors
    @objc func handleNavigateButton(){
        delegate?.navigateClicked(index: cellIndex!.row)
    }
    
    // MARK: - Configuration
    
    func configureCell(ad: Ad){
        self.titleLabel.text = ad.title

        let unformattedValue : Int = Int(ad.price) ?? 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // or .decimal if desired
        formatter.maximumFractionDigits = 0; //change as desired
        formatter.locale = Locale.current // or = Locale(identifier: "de_DE"), more locale identifier codes:
        formatter.groupingSeparator = "."
        let displayValue : String = formatter.string(from: NSNumber(value: unformattedValue))! // displayValue: "$3,534,235" ```

        priceLabel.text = displayValue + " ₺"

        let formattedURL = URL(string: ad.images.first ?? "")
        self.adImage.sd_setImage(with: formattedURL,completed: nil)
    }
}
