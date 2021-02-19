//
//  AlbumDetailModel.swift
//  AlbumsApp
//
//  Created by Lavanya on 19/02/21.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

struct AlbumDetailModel: Mappable{
    var albumId: Int?
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
    init?() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        albumId <- map["albumId"]
        id <- map["id"]
        title <- map["title"]
        url <- map["url"]
        thumbnailUrl <- map["thumbnailUrl"]
    }
}

