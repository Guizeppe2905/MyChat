//
//  Router.swift
//  myChat
//
//  Created by Мария Хатунцева on 26.10.2022.
//

import UIKit

class Router: ObservableObject {
    static let shared = Router()
    func navigateToVC(_ vc: UIViewController) {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow!.rootViewController = UINavigationController(rootViewController: vc)
        keyWindow!.makeKeyAndVisible()
    }
}
