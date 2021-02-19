//
//  AlbumDetailViewModel.swift
//  AlbumsApp
//
//  Created by Lavanya on 19/02/21.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class AlbumDetailViewModel {
    
    private var updateClosure: ((Int) -> Void)?
    var albumsDetailList: [AlbumDetailModel]?
    var albumDetailModel = AlbumDetailModel()
    var albumsDetailModel = [AlbumDetailModel]()
    var albumId:Int?
    
    init(albumId:Int, updateClosure: @escaping ((Int) -> Void)) {
        self.albumId = albumId
        self.updateClosure = updateClosure
        initialize()
    }
    
    private  func initialize() {
        fetchAlbumsDetailList{
            (albumModel, state) in
            if state == .success {
            self.albumsDetailList = albumModel
            self.updateClosure!(self.albumId ?? 0)
            }
        }
    }
    
    
    func fetchAlbumsDetailList(completion: @escaping([AlbumDetailModel], ApiResponseState) -> Void) {
        ApiManager.fetchPhotosForAlbumsWith(albumId: albumId ?? 0,  completion: {(response, error) in
            if (error) != nil {
                return completion([], .error)
            }
            var albumModel = AlbumDetailModel()
            for value in response {
                albumModel =
                    Mapper<AlbumDetailModel>().map(JSONObject: value)
                if let model = albumModel {
                    self.albumsDetailModel.append(model)
                }
            }
        completion(self.albumsDetailModel, .success)
        })
        
    }
    
}

extension AlbumDetailViewModel {
    
    var numberOfAlbums:Int {
        get {
            return self.albumsDetailList?.count ?? 0
        }
    }
    func configureAlbumsCollectionviewWith( cell: AlbumsDetailCollectionViewCell, indexPath: IndexPath) {
        guard let uRL = albumsDetailList?[indexPath.row].thumbnailUrl else { return  }
        if let url = URL(string: uRL) {
            cell.detailImageView.kf.indicatorType = .activity
            cell.detailImageView.kf.setImage(with: url)
            
        }
    }
    func didSelectImageAt(indexPath:IndexPath, completion:@escaping(String)-> Void){
        guard let title = albumsDetailList?[indexPath.row].title else { completion("")
            return  }
        completion(title)
    }
}


