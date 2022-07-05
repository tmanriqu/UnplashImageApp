//
//  ImageFavourite.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 5/07/22.
//

import Foundation
import RealmSwift

class ImageFavourite: Object {
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted var photoId: String = ""
    @Persisted var imageUrl: String = ""
}
