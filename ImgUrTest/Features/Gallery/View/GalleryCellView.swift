//
//  GalleryCellView.swift
//  ImgUrTest
//
//  Created by Digital on 07/02/22.
//

import Foundation
import UIKit
class GalleryCellView: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    
    //Identifier for reuse cell
    class var identifier: String { return "GalleryCell" }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    //Init view, set delegates, datasources and custom UI
    func initView() {
        // Cell view customization
        self.backgroundColor = .clear
    }
    
    //Prepare the cell for new data
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
