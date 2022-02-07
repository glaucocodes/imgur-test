//
//  ImgGenericResponse.swift
//  ImgUrTest
//
//  Created by Digital on 06/02/22.
//

struct ImgGenericResponse: Decodable{
    var status: Int
    var success: Bool
    var data: [GalleryItem]
}
