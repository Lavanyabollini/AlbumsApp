//
//  AlbumsDetailViewController.swift
//  AlbumsApp
//
//  Created by Lavanya on 18/02/21.
//

import UIKit
import Kingfisher

class AlbumsDetailViewController: UIViewController {
    
    @IBOutlet weak var albumsDetailCollectionView: UICollectionView!
    private var viewModel: AlbumDetailViewModel?
    var albumId = 1
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AlbumDetailViewModel(albumId:albumId , updateClosure: { _  in
            self.albumsDetailCollectionView.reloadData()
        })
    }
}

// MARK: - UICollectionViewDataSource Datasource/Delegate Methods

extension AlbumsDetailViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfAlbums ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AlbumsDetailCollectionViewCell  else {
            return UICollectionViewCell()
        }
        viewModel?.configureAlbumsCollectionviewWith(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3
        guard  let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 140, height: 130)
        }
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
}

