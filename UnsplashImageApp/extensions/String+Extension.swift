//
//  String+Extension.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 12/07/22.
//

import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self )
    }
}
