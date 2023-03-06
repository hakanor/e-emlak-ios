//
//  FeedTableViewCell.swift
//  e-emlak
//
//  Created by Hakan Or on 7.11.2022.
//

import Foundation
import UIKit
import CoreData

class FeedTableViewCellViewModel {
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

class FeedTableViewCell: UITableViewCell {
    
    var model = FeedTableViewCellViewModel(title: "", imageURL: URL(string: ""), url: "", urlToImage: "", publishedAt: "", description: "", content: "", sourceName: "")
    var ad = Ad(adId: "String", dictionary: ["String" : nil])
    
    // MARK: - Properties
    private let cornerRadiusValue : CGFloat = 16
    var bookmarkBool : Bool = false
    
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
    
    private lazy var bookmarkIcon: UIImageView = {
        let bookmarkIcon = UIImageView()
        let image = UIImage(systemName: "bookmark")?.withTintColor(themeColors.error)
        bookmarkIcon.image = image
        return bookmarkIcon
    }()
    
    private lazy var locationIcon: UIImageView = {
        let locationIcon = UIImageView()
        let image = UIImage(named: "location-sign")?.withTintColor(themeColors.error)
        locationIcon.image = image
        locationIcon.contentMode = .scaleAspectFit
        return locationIcon
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(containerView)

        containerView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0)
        
        [adImage, titleLabel, bookmarkIcon, locationLabel, priceLabel, locationIcon] .forEach(containerView.addSubview(_:))
        
        adImage.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 96, height: 96)
        adImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        titleLabel.anchor(top: containerView.topAnchor, left: adImage.rightAnchor, right:bookmarkIcon.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 3 )
        
        bookmarkIcon.anchor(top: titleLabel.topAnchor, right: priceLabel.rightAnchor, paddingTop: 1, width: 16, height: 16)
        
        locationIcon.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, paddingTop: 12, width:13, height: 13)
        
        locationLabel.anchor(top: locationIcon.topAnchor, left: locationIcon.rightAnchor, paddingTop:-2 ,paddingLeft:3)
        
        priceLabel.anchor(bottom: containerView.bottomAnchor,right: containerView.rightAnchor, paddingBottom: 14, paddingRight: 20)
        
        let gestureBookmarkIcon = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGestureBookmark(_:)))
        bookmarkIcon.addGestureRecognizer(gestureBookmarkIcon)
        bookmarkIcon.isUserInteractionEnabled = true
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookmarkIcon.image = UIImage(systemName: "bookmark")?.withTintColor(themeColors.grey)
    }
    
    // MARK: - Configuration
    @objc func handleTapGestureBookmark(_ sender: UITapGestureRecognizer? = nil) {
        print("Bookmark icon")
        
        let coreDataService = CoreDataService()
        
        if bookmarkBool == false {
            bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
            bookmarkBool = true
            coreDataService.saveToCoreData(ad: self.ad)
        } else {
            for ad in coreDataService.ads!{
                if(ad.adId == self.ad.adId){
                    coreDataService.deleteFromCoreData(ad: self.ad)
                }
            }
            bookmarkIcon.image = UIImage(systemName: "bookmark")
            bookmarkBool = false
        }
    }
    
    func configureCell(title:String, price:String, location:String, url:String, ad:Ad){
        self.ad = ad
        titleLabel.text = title
        
        let coreDataService = CoreDataService()
        bookmarkBool = coreDataService.checkObjectExistInCoreData(adId: ad.adId)
        checkBookmark()
        
        let unformattedValue : Int = Int(price) ?? 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // or .decimal if desired
        formatter.maximumFractionDigits = 0; //change as desired
        formatter.locale = Locale.current // or = Locale(identifier: "de_DE"), more locale identifier codes:
        formatter.groupingSeparator = "."
        let displayValue : String = formatter.string(from: NSNumber(value: unformattedValue))! // displayValue: "$3,534,235" ```
        
        priceLabel.text = displayValue + " ₺"
        let locationSplitted = location.split(separator: "/")
        let locationNew = (locationSplitted[safe: 0] ?? "") + "/" + (locationSplitted[safe: 1] ?? "")
        locationLabel.text = String(locationNew)
        let formattedURL = URL(string: url)
        self.adImage.sd_setImage(with: formattedURL,completed: nil)
        
    }
    
    func checkBookmark (){
        if (bookmarkBool == true){
            bookmarkIcon.image = UIImage(systemName: "bookmark.fill")
        } else {
            bookmarkIcon.image = UIImage(systemName: "bookmark")
        }
    }
}
