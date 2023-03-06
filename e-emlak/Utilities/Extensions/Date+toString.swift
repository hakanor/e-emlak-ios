//
//  Date+toString.swift
//  e-emlak
//
//  Created by Hakan Or on 6.03.2023.
//

import Foundation

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
