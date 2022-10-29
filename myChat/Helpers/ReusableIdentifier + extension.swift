//
//  ReusableIdentifier.swift
//  myChat
//
//  Created by Мария Хатунцева on 26.10.2022.
//

import Foundation

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}




protocol Configurable {
    func configure()
}
