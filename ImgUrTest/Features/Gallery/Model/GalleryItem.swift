//
//  GalleryItem.swift
//  ImgUrTest
//
//  Created by Digital on 06/02/22.
//

struct GalleryItem: Decodable{
    var id: String?
    var title: String?
    var images: [ImageItem]?
}
