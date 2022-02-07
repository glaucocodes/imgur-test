//
//  ImgAPITarget.swift
//  ImgUrTest
//
//  Created by Digital on 06/02/22.
//

import Foundation
import Moya
extension ImgAPI: TargetType {
    var environmentBaseURL: String{
        return Utils.getValueFromInfoList(key: NetworkManager.enviroment.rawValue)
    }
    
    var baseURL: URL {
        return URL(string: environmentBaseURL)!
    }
    
    var path: String {
        switch self {
            case .gallerySearch:
                return "/gallery/search/time/"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .gallerySearch:
                return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case .gallerySearch(let queryValue):
                return .requestParameters(parameters: ["q" : queryValue], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": Utils.getValueFromInfoList(key: "Client-ID")
        ]
    }
    
    
}

