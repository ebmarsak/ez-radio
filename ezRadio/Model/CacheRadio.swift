//
//  CacheRadio.swift
//  ezRadio
//
//  Created by Teto on 28.02.2022.
//

import Foundation

struct CacheRadio: Codable {
    var name: String
    var url: String
    var image: String
    
    init(name: String, url: String, image: String) {
        self.name = name
        self.url = url
        self.image = image
    }

}
