//
//  EditCoordinate.swift
//  e-emlak
//
//  Created by Hakan Or on 25.12.2022.
//

import Foundation
import UIKit
import MapKit

class EditCoordinateViewController: UIViewController{
    
    // MARK: - Properties
    var pin = MKPointAnnotation()
    var delegate: FetchCoordinateDelegate?
    var adId = ""
   
    // MARK: - SubViews
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "arrow.left")
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        button.addBlurEffect(style: .dark, cornerRadius: 13, padding: 5)
        return button
    }()
    
    private lazy var okButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Düzenle", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var getLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        let image = UIImage(systemName: "location.fill")
        button.setImage(image, for: .normal)
        button.backgroundColor = themeColors.primary
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleLocationButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setLocation()
    }
    
    init(adId:String ,lat:Double, lng:Double) {
        self.pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.adId = adId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        self.dismiss(animated: true)
    }
    
    @objc func handleNextButton(){
        print(self.pin.coordinate)
        let dict = ["latitude":self.pin.coordinate.latitude,"longitude":self.pin.coordinate.longitude]
        AdService.shared.updateAd(adId: self.adId, dictionary: dict) {
            let dialogMessage = UIAlertController(title: "Harita Konumu Değiştirme", message: "İlanınızın harita konumu başarıyla güncellendi.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Tamam", style: .cancel) { (action) -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    @objc func mapLongPress(_ recognizer: UIGestureRecognizer) {
        
        // Clear All annotations
        let annotations = map.annotations
        map.removeAnnotations(annotations)

        let touchedAt = recognizer.location(in: self.map) // adds the location on the view it was pressed
        let touchedAtCoordinate : CLLocationCoordinate2D = map.convert(touchedAt, toCoordinateFrom: self.map) // will get coordinates

        pin.coordinate = touchedAtCoordinate
        map.addAnnotation(pin)
        
        print("LongPress - \(pin.coordinate)")
        
    }
    
    @objc func handleLocationButton(){
        
        getUserLocation()
        
    }
    // MARK: - API
    
    func getUserLocation(){
    
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                // Clear All annotations
                let annotations = strongSelf.map.annotations
                strongSelf.map.removeAnnotations(annotations)
                
                // Add new annotation
                let pin = MKPointAnnotation()
                pin.coordinate = location.coordinate
                strongSelf.map.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)), animated: true)
                strongSelf.map.addAnnotation(pin)
                self?.pin = pin
                print("LocationManager - \(pin.coordinate)")
            }
        }
        
    }
    
    func setLocation(){
        if (self.pin.coordinate.longitude != 0 && self.pin.coordinate.latitude != 0) {
            self.map.setRegion(MKCoordinateRegion(center: self.pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)), animated: true)
            self.map.addAnnotation(self.pin)
        }
        else {
            getUserLocation()
        }
        
    }
    
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = themeColors.white
        title = "Haritadan Konum Seç"
        
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        [map, okButton, getLocationButton] .forEach(view.addSubview(_:))
        map.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        getLocationButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 24, paddingBottom: 20, width: 42, height: 42)
        
        okButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 20, paddingRight: 24, width: UIScreen.main.bounds.width / 3)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(mapLongPress(_:)))
            longPress.minimumPressDuration = 1
        map.addGestureRecognizer(longPress)
        
    }
        
}
