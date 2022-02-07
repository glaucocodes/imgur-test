//
//  GalleryCellView.swift
//  ImgUrTest
//
//  Created by Digital on 07/02/22.
//

import Foundation
import UIKit
import Kingfisher
class GalleryCellView: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    
    //Identifier for reuse cell
    class var identifier: String { return "GalleryCell" }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    // Setup the conection between the UIColletionViewCell and ViewModel, feteching the images from internet
    var viewModel: GalleryCellViewModel? {
        didSet {
            let url = URL(string: viewModel!.uRl)
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(
                with:url,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ]){
                    result in
                    switch result {
                    case .failure(_):
                        self.imageView.image = UIImage(named: "NotFound")
                    case .success(_):
                        break
                    }
                }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    //Init view, set delegates, datasources and custom UI
    func initView() {
        // Cell view customization
        self.backgroundColor = .clear
        self.imageView.contentMode = .scaleAspectFill
    }
    
    //Prepare the cell for new data
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
