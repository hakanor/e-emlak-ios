//
//  ViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 24.10.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Ekle", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(themeColors.white, for: .normal)
        button.backgroundColor = themeColors.primary
        button.contentEdgeInsets = UIEdgeInsets(top: 14,left: 14, bottom: 14,right: 14)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = themeColors.dark
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Uyarı - İlanı Eklemek İstediğinize Emin misiniz ?"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = themeColors.white
        [nextButton,cityLabel] .forEach(view.addSubview(_:))
        
//        cityLabel.anchor(top:view.topAnchor ,left: view.leftAnchor,right: view.rightAnchor, paddingTop: 20,paddingLeft: 24, paddingRight: 24)
        cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cityLabel.anchor(bottom: nextButton.topAnchor, paddingBottom: 34)
        
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor, paddingLeft: 24, paddingBottom: 20,paddingRight: 24)
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
