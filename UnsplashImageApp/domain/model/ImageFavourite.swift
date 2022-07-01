//
//  ImageFavourite.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 1/07/22.
//

import Foundation
import RealmSwift

class ImageFavourite: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var uiImage: UIImage
}
