//
//  FavouriteAdsViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 4.03.2023.
//

import Foundation
import UIKit

protocol historyButtonClickDelegate {
    func priceHistoryButtonClicked(_ row:Int, adId: String)
}

class FavouriteAdsViewController: UIViewController {

    // MARK: - Properties
    var ads = [Ad]()
    var uid = ""
    
    // MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.primary
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.text = "Favori ilanlarınız"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return tableView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "arrow.left")
        button.tintColor = themeColors.dark
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAdsFromCoreData()
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavouriteTableViewCell.self, forCellReuseIdentifier: "FavouriteCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0  )
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFunc), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    // MARK: - API
    func fetchAdsFromCoreData() {
        let coreDataService = CoreDataService()
        coreDataService.fetchAdsFromCoreData()

        guard let ads = coreDataService.ads else {
            return
        }

        let adObjects = ads.map { ad -> Ad in
            let adDictionary: [String: Any] = [
                "uid": ad.uid ?? "",
                "title": ad.title ?? "",
                "price": ad.price ?? "",
                "location": ad.location ?? "",
                "images": ad.images?.components(separatedBy: ",") ?? [],
                "estateType": ad.estateType ?? "",
                "timestamp": ad.timestamp ?? "",
                "description": ad.adDescription ?? "",
                "floorNumber": Int(ad.floorNumber),
                "numberOfFloors": Int(ad.numberOfFloors),
                "numberOfRooms": Int(ad.numberOfRooms),
                "numberOfBathrooms": Int(ad.numberOfBathrooms),
                "squareMeter": Int(ad.squareMeter),
                "squareMeterNet": Int(ad.squareMeterNet),
                "pricePerSquareMeter": ad.pricePerSquareMeter,
                "latitude": ad.latitude,
                "longitude": ad.longitude,
                "parcelNumber": Int(ad.parcelNumber),
                "blockNumber": Int(ad.blockNumber),
                "heating": ad.heating ?? "",
                "ageOfBuilding": Int(ad.ageOfBuilding),
                "status": ad.status
            ]

            return Ad(adId: ad.adId ?? "", dictionary: adDictionary)
        }

        self.ads = adObjects

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = themeColors.white
        
        [titleLabel, tableView] .forEach(view.addSubview(_:))
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        tableView.anchor(top: titleLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor
                         , right:view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 10, paddingRight: 24)
        
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshFunc(refreshControl: UIRefreshControl) {
        fetchAdsFromCoreData()
        tableView.reloadData()
        print("refresh")
        refreshControl.endRefreshing()
    }
    
    func refreshData(){
        fetchAdsFromCoreData()
        tableView.reloadData()
    }

}

extension FavouriteAdsViewController : UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell") as! FavouriteTableViewCell
        cell.configureCell(title: ads[indexPath.row].title, price: ads[indexPath.row].price, location: ads[indexPath.row].location, url: ads[indexPath.row].images.first ?? "nil", ad: ads[indexPath.row])
        cell.delegate = self
        cell.cellIndex = indexPath
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
            print("Default - FavouriteAdsViewController")
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
extension FavouriteAdsViewController: historyButtonClickDelegate {
    func priceHistoryButtonClicked(_ row: Int, adId: String) {
        
        let alertController = UIAlertController(title: "Fiyat Geçmişi", message: "", preferredStyle: .alert)
        // Create a stackView view and populate it with your data
        var priceHistory = [""]
        let coreDataService = CoreDataService()
        priceHistory = coreDataService.getPriceHistoryFromCoreData(adId: adId)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        
        for i in 0...priceHistory.count - 1 {
            let cell = PriceHistoryCell()
            
            let splitted = priceHistory[i].split(separator: " ")
            
            print(Int(splitted[0]) ?? 0 )
            let unformattedValue : Int = Int(splitted[0]) ?? 0
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal // or .decimal if desired
            formatter.maximumFractionDigits = 0; //change as desired
            formatter.locale = Locale.current // or = Locale(identifier: "de_DE"), more locale identifier codes:
            formatter.groupingSeparator = "."
            let displayValue : String = formatter.string(from: NSNumber(value: unformattedValue))! // displayValue: "$3,534,235" ```
            
            let right = displayValue + " ₺"
            
            let left = String(splitted[1])
            
            cell.config(
                leftSide: left,
                rightSide: right
            )
           
            stackView.addArrangedSubview(cell)

        }
        
        // Add the table view to the alert controller
        
        alertController.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.anchor(top: alertController.view.topAnchor, left: alertController.view.leftAnchor, bottom: alertController.view.bottomAnchor, right: alertController.view.rightAnchor, paddingTop: 70, paddingLeft: 1, paddingBottom: 70, paddingRight: 1)
        
        // Add an "OK" action button to the alert controller
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Do something when the "OK" button is clicked
        }
        alertController.addAction(okAction)
        
        // Show the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
}
