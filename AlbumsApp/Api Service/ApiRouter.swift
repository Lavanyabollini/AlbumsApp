//
//  ApiRouter.swift
//  AlbumsApp
//
//  Created by Lavanya on 17/02/21.
//

import Foundation
import Alamofire

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case authentication = "Authorization"
}

enum ContentType: String {
    case json = "application/json"
    case multiportData = "multipart/form-data"
}

enum PGApiRouter: URLRequestConvertible {
  
    case fetchAlbums
    case fetchPhotosForAlbumsWithAlbumId(albumId: Int)
  
    
    private var httpMethod: HTTPMethod {
        switch self {
        
        case .fetchAlbums:
            return .get
        case .fetchPhotosForAlbumsWithAlbumId:
            return .get
        }
    }
    
    private var servicePath: String {
        switch self {
        
        case .fetchAlbums:
            return ApiManager.baseURL + "/albums"
                
        case .fetchPhotosForAlbumsWithAlbumId:
               return ApiManager.baseURL + "/photos?albumId=%d"
        }
    }
    
     var urlString: String {
        switch self {
        
        case .fetchAlbums:
            return servicePath
        case .fetchPhotosForAlbumsWithAlbumId(let albumId):
            return String(format: servicePath,albumId)
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        
        default:
            return .none
            
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let requestUrl =  try urlString.asURL()
        var request = URLRequest(url: requestUrl)
        request.httpMethod = httpMethod.rawValue
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        if let parameters = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                print(String(bytes: jsonData, encoding: String.Encoding.utf8) ?? "")
                request.httpBody = jsonData
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return request
    }
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func dict2json() -> String {
        return json
    }
}
