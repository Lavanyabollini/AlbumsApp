//
//  AlbumsViewModel.swift
//  AlbumsApp
//
//  Created by Lavanya on 17/02/21.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper
public enum ApiResponseState {
    case success
    case error
}
class AlbumsViewModel {
    
    private var updateClosure: (() -> Void)?
    var albumsList: [AlbumsModel]?
    var albumModel = AlbumsModel()
    var albumsModel = [AlbumsModel]()
    var filteredAlbums: [AlbumsModel]?
    
    
    init(updateClosure: @escaping (() -> Void)) {
        self.updateClosure = updateClosure
        initialize()
    }
    
    private  func initialize() {
        fetchAlbumsList{
            (albumModel, state) in
            if state == .success {
            self.albumsList = albumModel
            self.filteredAlbums = self.albumsList
            self.updateClosure!()
            }
        }
    }
    
    
    func fetchAlbumsList(completion: @escaping([AlbumsModel], ApiResponseState) -> Void) {
        ApiManager.fetchAlbumsList(completion: {(response, error) in
            if (error) != nil {
                return completion([], .error)
            }
            var albumModel = AlbumsModel()
            
            // let responseData: [String: AnyObject] = (response as? [String: AnyObject] ?? [:])
            for value in response {
                albumModel =
                    Mapper<AlbumsModel>().map(JSONObject: value)
                if let model = albumModel {
                    self.albumsModel.append(model)
                }
            }
            
            
            completion(self.albumsModel, .success)
        })
        
    }
    
}

extension AlbumsViewModel {
    
    var numberOfAlbums:Int {
        get {
            return self.filteredAlbums?.count ?? 0
        }
    }
    func configureAlbumsCollectionviewWith( cell: AlbumsCollectionViewCell, indexPath: IndexPath) {
        //In order to display title for album I have capitalized the first letter and taken first word in the sentence to display as album title
        let title = filteredAlbums?[indexPath.row].title?.capitalized
        cell.albumTitleLabel.text = title?.components(separatedBy: " ").first
    }
    
    func didSelectAlbumAt(indexPath:IndexPath, completion:@escaping(String, Int)-> Void){
        guard let title = filteredAlbums?[indexPath.row].title?.capitalized, let id = filteredAlbums?[indexPath.row].id else { completion("",0)
            return  }
        completion(title,id)
    }
}

extension AlbumsViewModel {
    func searchBarTextDidChangeWith(searchText: String, completion: @escaping()-> Void){
        if(searchText.isEmpty){
            //reload your data source if necessary
            self.filteredAlbums = self.albumsList
            completion()
        } else {
            self.filteredAlbums = albumsList?.filter({($0.title? .contains(searchText.lowercased()))! })
            print(self.filteredAlbums?.count ?? 0)
            completion()
        }
        
    }
}
