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
        "startBackground", "back1", "back2", "back3", "back4", "back5", "back6",
 //       "1-1", "1-2", "1-3", "1-4", "1-5", "1-6", "1-7", "1-8", "1-9", "1-10", "1-11", "1-12", "1-13", "1-14", "1-15", "1-16", "1-17", "1-18", "1-19", "1-20"
    ]
}

