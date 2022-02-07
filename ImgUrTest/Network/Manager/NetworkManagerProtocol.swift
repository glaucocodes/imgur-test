//
//  NetworkManagerProtocol.swift
//  ImgUrTest
//
//  Created by Digital on 06/02/22.
//

import Foundation
import Moya

// NetworkManager protocol
protocol Networkable{
    var imgProvider: MoyaProvider<ImgAPI>{get}
    func searchImg(queryValue: String,onResult: @escaping ([GalleryItem])->(),onError: @escaping (Error)->())
}
