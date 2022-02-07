//
//  NetworkManager.swift
//  ImgUrTest
//
//  Created by Digital on 06/02/22.
//

import Foundation
import Moya

// Setup NetworkManager
struct NetworkManager: Networkable {
    var imgProvider: MoyaProvider<ImgAPI> = MoyaProvider<ImgAPI>(plugins: [NetworkLoggerPlugin()])
    static let enviroment: APIEnvironment = (UIApplication.shared.delegate as! AppDelegate).enviroment
}
