//
//  BackgroundViewModel.swift
//  myChat
//
//  Created by Мария Хатунцева on 26.10.2022.
//

import UIKit

struct ContactCellModel: Hashable {
    let image: UIImage
    let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
