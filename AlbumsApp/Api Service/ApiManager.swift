//
//  ApiManager.swift
//  AlbumsApp
//
//  Created by Lavanya on 17/02/21.
//

import UIKit
import Alamofire

class ApiManager {
    static let  baseURL  = "https://jsonplaceholder.typicode.com"
   
    

    
    static func fetchAlbumsList(completion:@escaping ([NSDictionary], NSError?) -> Void) {
        AF.request(PGApiRouter.fetchAlbums).validate().responseJSON { response in
            switch response.result {
            case .success(let result):
                completion(result as? [NSDictionary] ?? [[:]], nil)
            case .failure(let error):
                completion([NSDictionary()], error as NSError?)
            }
        }
    }
    
    static func fetchPhotosForAlbumsWith(albumId: Int, completion:@escaping ([NSDictionary], NSError?) -> Void) {
        AF.request(PGApiRouter.fetchPhotosForAlbumsWithAlbumId(albumId:albumId)).validate().responseJSON { response in
            switch response.result {
            case .success(let result):
                completion(result as? [NSDictionary] ?? [[:]], nil)
            case .failure(let error):
                completion([NSDictionary()], error as NSError?)
            }
        }

    }
}

