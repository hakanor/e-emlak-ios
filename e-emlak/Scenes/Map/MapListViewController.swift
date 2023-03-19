//
//  MapListViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 18.03.2023.
//

import UIKit

protocol MapListDelegate: AnyObject {
    func adClicked(index: Int)
}

protocol MapListTableClickDelegate: AnyObject {
    func navigateClicked(index: Int)
}

class MapListViewController: UIViewController {
    // MARK: - Properties
    var ads = [Ad]()
    weak var delegate: MapListDelegate?

    // MARK: - Subviews
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.grey
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Yakınlardaki İlanlar"
        label.contentMode = .scaleToFill
        label.numberOfLines = 1
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        configureUI()
        configureTableView()
    }
    // MARK: - API
    // MARK: - Helpers
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MapListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    private func configureUI(){
        view.addSubview(tableView)
        [tableView, descriptionLabel] .forEach(view.addSubview(_:))
        
        descriptionLabel.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 14, paddingLeft: 14, paddingRight: 14)
        
        tableView.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 14, paddingRight: 14)
    }
    // MARK: - Selectors
    // MARK: - Extensions
}

extension MapListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MapListTableViewCell
        cell.configureCell(ad: ads[indexPath.row])
        cell.delegate = self
        cell.cellIndex = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.adClicked(index: indexPath.row)
        print(indexPath.row)
    }
}

extension MapListViewController: MapModeDelegate {
    func adsFiltered(ads: [Ad]) {
        self.ads = ads
        self.tableView.reloadData()
    }
}

extension MapListViewController: MapListTableClickDelegate {
    func navigateClicked(index: Int) {
        let ad = self.ads[index]
        
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
            print("Default - ProfileViewController")
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
