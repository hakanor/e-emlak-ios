//
//  AlertDisplayable.swift
//  e-emlak
//
//  Created by Hakan Or on 3.04.2023.
//

import UIKit

protocol AlertDisplayable where Self: UIViewController {
    func showAlert(title: String, message: String)
}

extension AlertDisplayable {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let positiveAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(positiveAction)
        present(alert,animated: true, completion: nil)
    }
}
