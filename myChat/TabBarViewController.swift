//
//  TabBarViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item1 = ContactsViewController()
        let item2 = ListOfChatsViewController()
        let icon1 = UITabBarItem(title: "Контакты", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        let icon2 = UITabBarItem(title: "Контакты", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        item1.tabBarItem = icon1
        item2.tabBarItem = icon2
        let controllers = [item1, item2]
        self.viewControllers = controllers
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
     //   print("Should select viewController: \(viewController.title ?? "") ?")
        return true;
    }
}

