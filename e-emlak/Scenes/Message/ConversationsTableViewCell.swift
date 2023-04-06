//
//  ConversationsTableViewCell.swift
//  e-emlak
//
//  Created by Hakan Or on 3.04.2023.
//

import UIKit

class ConversationsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let cornerRadiusValue : CGFloat = 24
    
    // MARK: - Subviews
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = themeColors.white
        return view
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "loginBg")
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadiusValue
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.dark
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "John Doe"
        label.contentMode = .scaleToFill
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.grey
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "MessageContent"
        label.contentMode = .scaleToFill
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.grey
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "10:53"
        label.textAlignment = .right
        label.contentMode = .scaleToFill
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(containerView)

        containerView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0)
        
        [userImage, textStackView, timeLabel] .forEach(containerView.addSubview(_:))
        
        [nameLabel, contentLabel] .forEach(textStackView.addArrangedSubview(_:))
        
        userImage.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, width: 48, height: 48)
        userImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        textStackView.anchor(top: containerView.topAnchor, left: userImage.rightAnchor, bottom: containerView.bottomAnchor, right: timeLabel.leftAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 5, paddingRight: 3)
        
        timeLabel.anchor(top: containerView.topAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor)
        
        timeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.borderColor = themeColors.grey.cgColor
        userImage.layer.borderWidth = 1
    }
    
    // MARK: - Configuration
    func configureCell(uid: String, lastMessageText: String, timeStamp: String){
        // fetch user and set image and name
        UserService.shared.fetchUser(uid:uid) { user in
            self.userImage.sd_setImage(with: user.imageUrl)
            self.nameLabel.text = user.name + " " + user.surname
        }
        self.contentLabel.text = lastMessageText
        self.timeLabel.text = timeStamp
        
    }
}
