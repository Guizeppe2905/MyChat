//
//  ObservableFilterImage.swift
//  myChat
//
//  Created by Мария Хатунцева on 26.10.2022.
//

import Foundation
import UIKit
import Combine

protocol ObsevableSelectImage {
    func selectObservableImage(_ image: UIImage)
}

class ObservableSelectImage: NSObject {
    @objc dynamic var observableOriginalImage: UIImage = UIImage()
    @objc dynamic var observableImageView: UIImage = UIImage()
}
class SelectObservableImage {
    @objc var observable = ObservableSelectImage()
    
    var subscription: AnyCancellable? = nil
    var subscription1: AnyCancellable? = nil
    var originalImage = UIImage()
    var imageView = UIImageView()
   init() {

       subscription = observable.publisher(for: \.observableOriginalImage, options: .new)
           .sink { value in
               self.originalImage = value
        }
       subscription1 = observable.publisher(for: \.observableImageView, options: .new)
           .sink { value in
               self.imageView.image = value
        }
    }
}
