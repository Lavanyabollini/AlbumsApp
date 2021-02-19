//
//  AlbumsListViewController.swift
//  AlbumsApp
//
//  Created by Lavanya on 17/02/21.
//

import UIKit

class AlbumsListViewController: UIViewController {
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    private var viewModel: AlbumsViewModel?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AlbumsViewModel(updateClosure: {
            self.albumsCollectionView.reloadData()
            
        })
        //To make sticky header
        if let layout = albumsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }
}
// MARK: - UICollectionViewDataSource Datasource/Delegate Methods

extension AlbumsListViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfAlbums ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AlbumsCollectionViewCell  else {
            return UICollectionViewCell()
        }
        viewModel?.configureAlbumsCollectionviewWith(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
}

extension AlbumsListViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectAlbumAt(indexPath: indexPath, completion: { (title, id) in
            self.navigateToDetailAlbumView(title: title, albumId: id)
        })
        
    }
    
    func navigateToDetailAlbumView(title: String, albumId:Int ) {
        let stybd = UIStoryboard(name: "Main", bundle: nil)
        let identifier = "AlbumsDetailViewController"
        guard let albumDetailVC = stybd.instantiateViewController(withIdentifier: identifier) as? AlbumsDetailViewController else {
            return }
        albumDetailVC.navigationItem.title = title
        albumDetailVC.albumId = albumId
        self.navigationController?.pushViewController(albumDetailVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3
        guard  let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 120, height: 160)
        }
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
}


extension AlbumsListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!){
            self.albumsCollectionView?.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchBarTextDidChangeWith(searchText: searchText, completion: {  
            self.albumsCollectionView?.reloadData()
        })
        if !(searchBar.text == nil || searchBar.text == "")
        {
            searchBar.perform(#selector(self.becomeFirstResponder), with: nil, afterDelay: 0.1)
        }else{
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }
        
    }
    
    
}

