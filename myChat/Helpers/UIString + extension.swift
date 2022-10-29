//
//  UIString + extension.swift
//  myChat
//
//  Created by Мария Хатунцева on 28.10.2022.
//

import UIKit

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
