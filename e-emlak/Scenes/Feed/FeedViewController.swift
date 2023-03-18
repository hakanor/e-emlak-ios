//
//  FeedViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 10.10.2022.
//

import UIKit
import Firebase
import Toast

struct CustomDictionaryObject {
    let key : String
    let value : String
}

class FeedViewController: UIViewController {
    // MARK: - Properties
    var ads = [Ad]()
    
    // MARK: - Subviews
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return tableView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "İl İlçe Mahalle Veya Semt Ara",
            attributes: [NSAttributedString.Key.foregroundColor: themeColors.dark.withAlphaComponent(0.6)]
        )
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.backgroundColor = themeColors.lightGrey
        textField.leftImage(UIImage(systemName: "magnifyingglass")?.withTintColor(themeColors.dark), imageWidth: 10, padding: 15)

        let clearImage = UIImage(systemName: "multiply")?.withTintColor(themeColors.dark)
        let clearImageView = UIImageView(image: clearImage)
        clearImageView.contentMode = .center
        clearImageView.tintColor = .black
        clearImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(didTouchClearAllButton(_:)))
        textField.rightView(clearImageView, width: 20, padding: 5 , tapGesture:tapGesture)
        
        textField.layer.cornerRadius = 13
        textField.addTarget(self, action: #selector(searchFunc), for: .editingDidEndOnExit)
        return textField
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        let image = UIImage(systemName: "line.3.horizontal.decrease")
        button.setImage(image, for: .normal)
        button.backgroundColor = themeColors.primary
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(handleFilterButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchAds()
        configureUI()
        configurateTableView()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAds()
        tableView.reloadData()
    }
    
    // MARK: - API
    func fetchAds() {
        AdService.shared.fetchAds { fetchedAds in
            self.ads.removeAll()
            self.ads = fetchedAds
            self.tableView.reloadData()
        }
    }
    
    func fetchAds(with Keyword:String) {
        AdService.shared.fetchAds(with: Keyword) { fetchedAds in
            let vc = FilteredResultViewController()
            vc.ads = fetchedAds
            self.present(vc,animated: true,completion: nil)
        }
    }
    
    // MARK: - Helpers
    func configureUI(){
        [tableView, textField, filterButton] .forEach(view.addSubview(_:))
        
        filterButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 10, paddingLeft: 24, width: 35, height: 35)
        
        textField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: filterButton.rightAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 24, height: 35)
        
        tableView.anchor(top: filterButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor
                         , right:view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 10, paddingRight: 24)
    }
    
    func configurateTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "FeedTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0  )
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFunc), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    // MARK: - Selectors
    @objc func refreshFunc(refreshControl: UIRefreshControl) {
        fetchAds()
        tableView.reloadData()
        print("refresh")
        refreshControl.endRefreshing()
    }
    
    @objc func searchFunc() {
        fetchAds(with: textField.text ?? "")
    }
    
    @objc private func didTouchClearAllButton(_ sender: UITapGestureRecognizer? = nil) {
        textField.text?.removeAll();
    }
    
    @objc func handleFilterButton() {
        let nav = UINavigationController(rootViewController: FilterViewController())
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)
    }
    
    
}

    // MARK: - UITableView Delegate & DataSource
extension FeedViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.ads.count == 0 {
            tableView.setEmptyView(title: "Hiç ilan bulunamadı.", message: "", messageImage: UIImage(systemName: "house")!)
        }
        else {
            tableView.restore()
        }
        return self.ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as! FeedTableViewCell
        cell.configureCell(title: ads[indexPath.row].title, price: ads[indexPath.row].price, location: ads[indexPath.row].location, url: ads[indexPath.row].images.first ?? "nil", ad: ads[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        let ad = ads[indexPath.row]
        
        let propertyType = ad.estateType.split(separator: "/").first
        
        var dictionary = [CustomDictionaryObject]()
        
        switch propertyType {
        case "Konut":
            dictionary = [
                CustomDictionaryObject(key: "Fiyat", value: String(ad.price) + " ₺"),
                CustomDictionaryObject(key: "İlan Tarihi", value: String(ad.timestamp)),
                CustomDictionaryObject(key: "Emlak Türü", value: String(ad.estateType)),
                CustomDictionaryObject(key: "Metrekare (Net)", value: String(ad.squareMeter)),
                CustomDictionaryObject(key: "Metrekare (Brüt)", value: String(ad.squareMeterNet)),
                CustomDictionaryObject(key: "Bina Yaşı", value: String(ad.ageOfBuilding)),
                CustomDictionaryObject(key: "Bina Kat Sayısı", value: String(ad.numberOfFloors)),
                CustomDictionaryObject(key: "Daire Kat Sayısı", value: String(ad.floorNumber)),
                CustomDictionaryObject(key: "Oda Sayısı", value: String(ad.numberOfRooms)),
                CustomDictionaryObject(key: "Banyo Sayısı", value: String(ad.numberOfBathrooms)),
                CustomDictionaryObject(key: "Isıtma", value: String(ad.heating))
            ]
        case "İş Yeri":
            dictionary = [
                CustomDictionaryObject(key: "Fiyat", value: String(ad.price) + " ₺"),
                CustomDictionaryObject(key: "İlan Tarihi", value: String(ad.timestamp)),
                CustomDictionaryObject(key: "Emlak Türü", value: String(ad.estateType)),
                CustomDictionaryObject(key: "Metrekare (Net)", value: String(ad.squareMeter)),
                CustomDictionaryObject(key: "Bina Yaşı", value: String(ad.ageOfBuilding)),
                CustomDictionaryObject(key: "Bina Kat Sayısı", value: String(ad.numberOfFloors)),
                CustomDictionaryObject(key: "Isıtma", value: String(ad.heating))
            ]
        case "Arsa":
            dictionary = [
                CustomDictionaryObject(key: "Fiyat", value: String(ad.price) + " ₺"),
                CustomDictionaryObject(key: "İlan Tarihi", value: String(ad.timestamp)),
                CustomDictionaryObject(key: "Emlak Türü", value: String(ad.estateType)),
                CustomDictionaryObject(key: "Metrekare (Net)", value: String(ad.squareMeter)),
                CustomDictionaryObject(key: "Metrekare / ₺", value: String(ad.pricePerSquareMeter)),
                CustomDictionaryObject(key: "Ada Numarası", value: String(ad.blockNumber)),
                CustomDictionaryObject(key: "Parsel Numarası", value: String(ad.parcelNumber))
            ]
        default:
            print("Default - FeedViewController")
        }
        
        let vc = DetailsVievController(
            title: ad.title,
            location: ad.location,
            imageUrl: ad.images.first ?? "",
            description: ad.description,
            dictionary: dictionary,
            urls: ad.images,
            ad : ad
        )
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true,completion: nil)
    }
}
