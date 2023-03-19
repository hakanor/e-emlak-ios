//
//  MapModeViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 13.03.2023.
//

import UIKit
import MapKit
import Foundation
import CoreLocation
import FloatingPanel

protocol MapModeDelegate: AnyObject {
    func adsFiltered(ads: [Ad])
}

class MapModeViewController: UIViewController, FloatingPanelControllerDelegate {
    
    // MARK: - Properties
    var currentLocationPin = MKPointAnnotation()
    private let selectableValues: [Float] = [5, 10, 15, 20, 50, 100]
    var ads = [Ad]()
    var filteredAds = [Ad]()
    var fpc: FloatingPanelController!
    weak var delegate: MapModeDelegate?
    
    // MARK: - Subviews
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "arrow.left")
        button.tintColor = .black
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = Float(selectableValues.count - 1)
        slider.isContinuous = false
        slider.tintColor = themeColors.primary
        
        slider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        for (index, value) in selectableValues.enumerated() {
            slider.setValue(Float(index), animated: false)
            if value == 100 {
                slider.maximumTrackTintColor = themeColors.primary.withAlphaComponent(0.4)
            }
        }
        return slider
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var valueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var map: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getUserLocation()
        fetchAds()
        
        fpc = FloatingPanelController()
        fpc.delegate = self
        
        fpc.layout = CustomFloatingPanelLayout()
    
        let contentVC = MapListViewController()
        delegate = contentVC
        fpc.set(contentViewController: contentVC)
        
        contentVC.delegate = self
        
        fpc.track(scrollView: contentVC.tableView)
        
        fpc.addPanel(toParent: self)
    }

    // MARK: - API
    private func getUserLocation(){
    
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
                self?.currentLocationPin = pin
                print("LocationManager - \(pin.coordinate)")
            }
        }
        
    }
    
    private func createAnnotations(ads: [Ad]) -> [MKPointAnnotation] {
        let annotations = ads.map { ad in
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = ad.latitude
            annotation.coordinate.longitude = ad.longitude
            return annotation
        }
        return annotations
    }
    
    private func addAnnotations(annotations: [MKPointAnnotation]) {
        let allAnnotations = self.map.annotations
        map.removeAnnotations(allAnnotations)
        
        // Add the annotations to your map view
        map.addAnnotations(annotations)
    }
    
    private func fetchAds() {
        AdService.shared.fetchAds { fetchedAds in
            self.ads.removeAll()
            self.ads = fetchedAds
            self.filterAds()
        }
    }
    
    func calculateDistance(currentLocation: MKPointAnnotation, ad: Ad) -> Double {
        let lat1 = currentLocation.coordinate.latitude
        let lon1 = currentLocation.coordinate.longitude
        let lat2 = ad.latitude
        let lon2 = ad.longitude
        
        let p = 0.017453292519943295
        
        let deltaLat = lat2 - lat1
        let deltaLon = lon2 - lon1
        let cosDeltaLat = cos(deltaLat * p) / 2
        let cosDeltaLon = cos(deltaLon * p)
        let a = 0.5 - cosDeltaLat + cos(lat1 * p) * cos(lat2 * p) * (1 - cosDeltaLon) / 2
        let distance = 12742 * asin(sqrt(a))
        return distance
    }
    
    private func filterAds() {
        self.filteredAds.removeAll()
        for ad in ads {
            let distance = calculateDistance(currentLocation: currentLocationPin, ad: ad)
            if  distance <= Double(selectableValues[Int(slider.value)]) {
                filteredAds.append(ad)
            }
        }
        // Create annotations from filteredAds and add to Map
        let annotations = createAnnotations(ads: filteredAds)
        addAnnotations(annotations: annotations)
        
        self.delegate?.adsFiltered(ads: filteredAds)
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = themeColors.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.title = "Haritadan Tüm İlanları Gör"
        
        [stackView, map] .forEach(view.addSubview(_:))
        
        [slider, valueStackView] .forEach(stackView.addArrangedSubview(_:))
        
        for value in selectableValues {
            let label = UILabel()
            label.anchor(width: 31)
            label.textAlignment = .center
            label.text = "\(Int(value))"
            label.textColor = themeColors.grey
            label.font = UIFont.systemFont(ofSize: 12)
            valueStackView.addArrangedSubview(label)
        }
        
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 24, paddingRight: 24)
        
        map.anchor(top: stackView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 5)
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        self.dismiss(animated: true)
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!){
        let selectedIndex = Int(sender.value)
        sender.setValue(Float(selectedIndex), animated: true)
        filterAds()
    }
}

extension MapModeViewController: MapListDelegate {
    func adClicked(index: Int) {
        print(self.filteredAds[index].adId)
    }
}
