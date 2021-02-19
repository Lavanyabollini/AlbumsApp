//
//  AlbumsModel.swift
//  AlbumsApp
//
//  Created by Lavanya on 17/02/21.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

struct AlbumsModel: Mappable{
    var userId: Int?
    var id: Int?
    var title: String?
    
    init?() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        userId <- map["userId"]
        id <- map["id"]
        title <- map["title"]
    }
}
