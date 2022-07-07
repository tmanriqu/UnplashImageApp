//
//  Response.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 27/06/22.
//

import Foundation

struct Response: Codable {
    let total: Int?
    let total_pages: Int?
    let results: [Result]
}
