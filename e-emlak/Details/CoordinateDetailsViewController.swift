//
//  CoordinateDetailsViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 5.12.2022.
//

import UIKit
import MapKit

class CoordinateDetailsViewController: UIViewController{
    
    // MARK: - Properties
    var pin = MKPointAnnotation()
    var delegate: FetchCoordinateDelegate?
   
    // MARK: - SubViews
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
    
    private lazy var getLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        let image = UIImage(named:"location-sign")
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        self.dismiss(animated: true)
    }
    
    @objc func handleNextButton(){
        print(self.pin.coordinate)
        delegate?.fetchCoordinate(coordinate: pin.coordinate)
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
        
        let pin = MKPointAnnotation()
        pin.coordinate.longitude = 42.1
        pin.coordinate.latitude = 42.1
        self.map.setRegion(MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)), animated: true)
        self.map.addAnnotation(pin)
        
    }
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = themeColors.white
        title = "Haritadan Konum Seç"
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        [map, getLocationButton, backButton] .forEach(view.addSubview(_:))
        map.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        backButton.anchor(top: map.topAnchor, left: map.leftAnchor ,paddingTop: 10, paddingLeft: 10)
        getLocationButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 24, paddingBottom: 20, width: 42, height: 42)
    }
        
}
