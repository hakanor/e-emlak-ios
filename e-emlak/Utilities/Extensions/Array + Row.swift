//
//  Array + Row.swift
//  e-emlak
//
//  Created by Hakan Or on 22.11.2022.
//

import Foundation

/// Extension of Array. Adds capability to safe subscript Array with Element
extension Array {
    ///   Returns element for given index.
    ///
    ///   - Parameter index: Index to retrieve Element.
    ///
    ///   - Returns: Element matching index or nil.
    public subscript(safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
