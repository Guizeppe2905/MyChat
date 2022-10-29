//
//  ImgFac.swift
//  myChat
//
//  Created by Мария Хатунцева on 26.10.2022.
//

import UIKit

struct ContactCellViewModel {
    
    enum Mode {
        case random
        case next
    }
    
    private static var index: Int = 0
    private static let maxIndex: Int = RandomImageSelector.images.count
    
    static func produce(using mode: Mode = .random) -> UIImage? {
        var localIndex: Int
        
        switch mode {
        case .random:
            localIndex = Int.random(in: 0..<maxIndex)
        case .next:
            incrementPointingIndex()
            localIndex = index
        }
        
        let imageName = RandomImageSelector.images[localIndex]
        return UIImage(named: imageName)
    }
    
    static func resetPoitingIndex() {
        index = 0
    }
    
    static func incrementPointingIndex() {
        index = (index + 1) % maxIndex
    }
}

struct RandomImageSelector {
    static var images: [String] = [
        "startBackground", "back1", "back2", "back3", "back4", "back5", "back6"
    ]
}

