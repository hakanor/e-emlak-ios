//
//  MyFeedViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 10.10.2022.
//

import UIKit
import Firebase

protocol ClickDelegate {
    func deleteClicked(_ row:Int)
    func editClicked(_ row: Int)
    func activateClicked(_ row: Int)
}

class MyFeedViewController: UIViewController {
    
    // MARK: - Properties
    var ads = [Ad]()
    var uid = ""
    
    var user: User? {
        didSet {
            applyUserData()
        }
    }
    
    // MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.primary
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.text = "Size Ait İlanlar"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        configureUI()
        configureTableView()
    }
    
    // MARK: - Helpers
    func applyUserData(){
        guard let user = user else { return }
        titleLabel.text = user.name + ", tüm ilanlarınız listelenmektedir."
    }
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0  )
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFunc), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    // MARK: - API
    func fetchUser(){
        UserService.shared.fetchUser { user in
            self.user = user
            self.fetchAds(uid:user.uid)
        }
    }
    
    func fetchAds(uid:String) {
        AdService.shared.fetchAllAds(uid:uid) { fetchedAds in
            self.ads.removeAll()
            self.ads = fetchedAds
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
    @objc func refreshFunc(refreshControl: UIRefreshControl) {
        fetchAds(uid: self.uid)
        tableView.reloadData()
        print("refresh")
        refreshControl.endRefreshing()
    }

    
}

extension MyFeedViewController : UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        cell.configureCell(title: ads[indexPath.row].title, price: ads[indexPath.row].price, location: ads[indexPath.row].location, url: ads[indexPath.row].images.first ?? "nil", status: ads[indexPath.row].status)
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
            print("Default - ProfileViewController")
        }
        
        let prime = ad.latitude
        print (prime)
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

        
//        self.view.makeToast("\(indexPath.row) seçildi.", duration: 3.0, position: .bottom)

    }
}

extension MyFeedViewController: ClickDelegate {
    func deleteClicked(_ row: Int) {
        let dialogMessage = UIAlertController(title: "Uyarı", message: "İlanınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Tamam", style: .default) { (action) -> Void in
            print("OK")
            print(row)
            AdService.shared.deleteAd(adId: self.ads[row].adId) {
                print("İlan Başarıyla silindi.")
            }
        }
        let cancel = UIAlertAction(title: "İptal", style: .cancel) { (action) -> Void in
            print("İptal")
        }
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func editClicked(_ row: Int) {
        
        let dialogMessage = UIAlertController(title: "İlan Güncelleme Seçenekleri", message: "", preferredStyle: .alert)
        
        let location = UIAlertAction(title: "Konum güncelleme.", style: .default) { (action) -> Void in
            
        }
        
        let coordinate = UIAlertAction(title: "Harita konumu güncelleme.", style: .default) { (action) -> Void in
            let adId = self.ads[row].adId
            let lat = self.ads[row].latitude
            let lng = self.ads[row].longitude
            
            let vc = EditCoordinateViewController(adId: adId , lat: lat, lng: lng)
            
            if self.navigationController != nil {
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let navCon = UINavigationController(rootViewController: vc)
                navCon.modalPresentationStyle = .fullScreen
                self.present(navCon, animated: true)
            }
        }
        
        let details = UIAlertAction(title: "İlan detayı güncelleme.", style: .default) { (action) -> Void in
            let propertyType = self.ads[row].estateType.split(separator: "/").first
            
            switch propertyType {
            case "Konut":
                print(propertyType)
            case "Arsa":
                print(propertyType)
            case "İş Yeri":
                print(propertyType)
            default:
                print("PropertyType error - MyFeedViewController")
            }
            
        }
        
        let cancel = UIAlertAction(title: "İptal", style: .cancel) { (action) -> Void in
            
        }
        
        dialogMessage.addAction(location)
        dialogMessage.addAction(coordinate)
        dialogMessage.addAction(details)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func activateClicked(_ row: Int) {
        print("Activate")
        let statusBool = self.ads[row].status
        
        if statusBool {
            AdService.shared.updateAd(adId: self.ads[row].adId, dictionary: ["status":false]) {
                DispatchQueue.main.async {
                    self.ads[row].status = false
                    self.tableView.reloadData()
                    
                }
            }
            
        } else {
            AdService.shared.updateAd(adId: self.ads[row].adId, dictionary: ["status":true]) {
                DispatchQueue.main.async {
                    self.ads[row].status = true
                    self.tableView.reloadData()
                }
            }
        }
        
    }
}
