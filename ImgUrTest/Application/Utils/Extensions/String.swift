//
//  String.swift
//  ImgUrTest
//
//  Created by Digital on 06/02/22.
//

extension String {
    var urlEncoded: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}
