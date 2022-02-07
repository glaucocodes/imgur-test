//
//  ImgAPIPR.swift
//  ImgUrTest
//
//  Created by Digital on 06/02/22.
//
import Foundation
extension NetworkManager{
    func searchImg(queryValue: String, onResult: @escaping ([GalleryItem])->(),onError: @escaping (Error)->()) {
        imgProvider.request(.gallerySearch(queryValue: queryValue), completion: {result in
            switch result{
            case let .success(response):
                do{
                    let response = try JSONDecoder().decode(ImgGenericResponse.self, from: response.data)
                    onResult(response.data)
                }catch let error{
                    onError(error)
                }
            case let .failure(error):
                onError(error)
            }
        })
    }
}
