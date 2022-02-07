//
//  GalleryView.swift
//  ImgUrTest
//
//  Created by Digital on 06/02/22.
//

import UIKit

// MARK: - ViewStates
// Create view states to easy handle the feedback to the user. For example loading, no results, network error, etc.
extension GalleryView {
    enum State {
        case loading
        case showCollection
        case searching
        case error
    }
}


class GalleryView: UIViewController {
    //IBOutlets of the screen
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTopLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchingIndicator: UIActivityIndicatorView!
    
    
    //Variables and constants declaration
    lazy var viewModel = {GalleryViewModel()}()
    let numberOfColumns: CGFloat = 3
    let spacing: CGFloat = 10
    
    //View state handle
    var state: State = .loading {
        didSet {
            switch state {
            case .showCollection:
                self.errorView.isHidden = true
                self.collectionView.isHidden = false
                self.loadingView.isHidden = true
                self.searchingIndicator.isHidden = true
                self.searchingIndicator.stopAnimating()
            case .loading:
                self.errorView.isHidden = true
                self.collectionView.isHidden = true
                self.loadingView.isHidden = false
                self.searchingIndicator.isHidden = true
                self.searchingIndicator.stopAnimating()
            case .searching:
                self.errorView.isHidden = true
                self.collectionView.isHidden = true
                self.loadingView.isHidden = true
                self.searchingIndicator.isHidden = false
                self.searchingIndicator.startAnimating()
            case .error:
                self.errorView.isHidden = false
                self.collectionView.isHidden = true
                self.loadingView.isHidden = true
                self.searchingIndicator.isHidden = true
                self.searchingIndicator.stopAnimating()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
    }
    
    //Init view, set delegates, datasources and custom UI
    func initView(){
        self.viewModel.numberOfColumns = numberOfColumns
        self.state = .loading
        self.searchTopLabel.text = ""
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        self.collectionView.register(GalleryCellView.nib, forCellWithReuseIdentifier: GalleryCellView.identifier)
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = false
        self.searchBar.backgroundImage = UIImage()
        initViewModel()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - UICollectionViewDataSource
//Number of items to show
extension GalleryView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.galleryCellViewModels.count
    }
}

// MARK: - UICollectionViewDelegate
//Assign the cell
extension GalleryView: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GalleryCellView = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCellView.identifier, for: indexPath) as! GalleryCellView
        cell.viewModel = self.viewModel.getCollectionViewModel(at: indexPath)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
//Auto calculate cells size
extension GalleryView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

        let size = ((collectionView.frame.width -  spacing)/numberOfColumns) - spacing
        return CGSize(width:size , height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    // Screen rotation handle
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
}
