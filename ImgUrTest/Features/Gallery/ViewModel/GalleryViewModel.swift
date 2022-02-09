//
//  GalleryViewModel.swift
//  ImgUrTest
//
//  Created by Digital on 06/02/22.
//

import Foundation
import UIKit
class GalleryViewModel {
    //ViewModel Initialization
    private var networkProvider: NetworkManager
    var reloadCollectionView: (() -> Void)?
    var insertCells: (() -> Void)?
    var networkError: (() -> Void)?
    var galleryItems = [GalleryItem]()
    var newIndexPaths = [IndexPath]()
    var index = 0
    var numberOfColumns: CGFloat = 0
    var galleryCellViewModels = [GalleryCellViewModel]() {
        didSet {
            self.newIndexPaths.count == 0 ? reloadCollectionView?() : insertCells?()
        }
    }
    
    init(networkProvider: NetworkManager = NetworkManager()) {
        self.networkProvider = networkProvider
    }
    
    //Query the ImgUr api,we filter the response showing only the results with images
    func searchImg(query: String) {
        self.galleryItems = []
        self.galleryCellViewModels = []
        networkProvider.searchImg(queryValue: query,onResult: {result in
            self.updateData(galleryItems: result.filter({$0.images != nil && $0.images!.count > 0}))
        }, onError: {error in
            print(error.localizedDescription)
            self.networkError?()
        })
    }
    
    //Set feteching data to local cache, if we don´t have results, we show the network error buy we can create a custom error
    func updateData(galleryItems: [GalleryItem]) {
        self.galleryItems = galleryItems.filter({$0.images!.contains(where:{!($0.link?.contains("mp4"))!})})
        self.index = 0
        if(galleryItems.count == 0){
            self.networkError?()
        }else{
            loadMoreCells()
        }
    }
    
    //Load cells once we reach the bottom of the screen start to load more, row by row. We trying to add a new row, but if we have less cells to show add only the limit
    func loadMoreCells(){
        if(self.index == self.galleryItems.count){
            return
        }
        var newIndex = self.index + Int(self.numberOfColumns)
        self.newIndexPaths = []
        if(newIndex > self.galleryItems.count - 1){
            newIndex = self.galleryItems.count
        }
        
        var cellViewModels = self.galleryCellViewModels
        for tempIndex in self.index..<newIndex {
            cellViewModels.append(initCellModel(galleryItem: self.galleryItems[tempIndex]))
            if(self.index != 0){
                self.newIndexPaths.append(IndexPath(row: tempIndex, section: 0))
            }
        }
        
        self.index = newIndex
        self.galleryCellViewModels = cellViewModels
    }
    
    //Create the ViewModel for each cell
    func initCellModel(galleryItem: GalleryItem) -> GalleryCellViewModel {
        let uRl = galleryItem.images?.first?.link
        return GalleryCellViewModel(uRl: uRl!)
    }
    
    //Return the GalleryCell for the indexpath
    func getCollectionViewModel(at indexPath: IndexPath) -> GalleryCellViewModel {
        return galleryCellViewModels[indexPath.row]
    }
        
}

// Setup the conection between the UIVIewController and ViewModel
extension GalleryView{    
    func initViewModel() {
        self.viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.state = .showCollection
                self?.collectionView.reloadData()
            }
        }
        
        self.viewModel.insertCells = { [weak self] in
            self?.collectionView.reloadData()
            self?.collectionView.performBatchUpdates({
                self?.collectionView.insertItems(at: self?.viewModel.newIndexPaths ?? [])
                self?.viewModel.newIndexPaths = []
               })
        }
        
        self.viewModel.networkError = { [weak self] in
            self?.state = .error
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == self.viewModel.galleryCellViewModels.count - 1 ) {
            self.viewModel.loadMoreCells()
         }
    }
    
}

// Handle actions from searchbar
extension GalleryView: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearchBar()
        self.state = .loading
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchTopLabel.text = "Query: \(self.searchBar.text ?? "")"
        self.viewModel.searchImg(query: self.searchBar.text!)
        self.state = .searching
        clearSearchBar()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchTopLabel.text = ""
        self.searchBar.showsCancelButton = true
        self.state = .loading
        return true
    }
    
    func clearSearchBar(){
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
    }
    
}
