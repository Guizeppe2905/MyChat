//
//  FilterUtils.swift
//  myChat
//
//  Created by Мария Хатунцева on 26.10.2022.
//

import Foundation
import UIKit
import Combine

private let filterNames = [
    
    "CIPhotoEffectChrome",
    "CIPhotoEffectFade",
    "CIPhotoEffectInstant",
    "CIPhotoEffectMono",
    "CIPhotoEffectNoir",
    "CIPhotoEffectProcess",
    "CIPhotoEffectTonal",
    "CIPhotoEffectTransfer",
    "CISepiaTone"
 
]
class FilterManager: NSObject {
    @objc dynamic var selectedFilter: [String] = filterNames
}
class SelectRandomFilter {
    @objc var observable = FilterManager()
    var filter: [String] = []
    var subscription: AnyCancellable? = nil
    
   init() {

       subscription = observable.publisher(for: \.selectedFilter, options: .new)
           .sink { value in
               self.filter = value
        }
    }
}

func applyRandomFilters(to image: UIImage, completion: @escaping (UIImage) -> Void) {
    
    let filtersCount = Int.random(in: (1...4))
    let filtersNames = Array(filterNames.shuffled().dropLast(filterNames.count - filtersCount))
                        
    applyFilters(filtersNames, to: image) { filteredImage in
        completion(filteredImage)
    }
    
    func applyFilters(_ filtersNames: [String], to image: UIImage, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            var filteredImage: UIImage = image
            filtersNames.forEach {
                filteredImage = filteredImage.applyFilter($0)
            }
            DispatchQueue.main.async {
                completion(filteredImage)
            }
        }
    }
}






