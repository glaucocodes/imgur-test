//
//  Tools.swift
//  ImgUrTest
//
//  Created by Digital on 06/02/22.
//

import Foundation
class Utils{
    class func getValueFromInfoList(key: String) -> String{
        if let value = Bundle.main.object(forInfoDictionaryKey: key) as? String{
            return value
        }else{
            return ""
        }
    }
}
