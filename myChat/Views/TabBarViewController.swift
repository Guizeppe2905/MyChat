//
//  TabBarViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
//    private lazy var backgroundImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "background")
//        return imageView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     view.sendSubviewToBack(backgroundImageView)
      //  view.backgroundView = UIImage(named: "background")
//        view.addSubview(backgroundImageView)
//        backgroundImageView.frame = view.bounds
    //    view.backgroundColor = .systemGray3
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  view.backgroundColor = .systemPink
        let item1 = UINavigationController(rootViewController: ContactsViewController())
        let item2 = UINavigationController(rootViewController: ListOfChatsViewController())
        let item3 = UINavigationController(rootViewController: ProfileViewController())
        
        let icon1 = UITabBarItem(title: "Чаты", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book.fill"))
        let icon2 = UITabBarItem(title: "Форум", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        let icon3 = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        item1.tabBarItem = icon1
        item2.tabBarItem = icon2
        item3.tabBarItem = icon3
        let controllers = [item1, item2, item3]
        tabBar.unselectedItemTintColor = UIColor.systemPink
        tabBar.tintColor = UIColor.systemPink
        tabBar.backgroundImage = UIImage(named: "background")
      //  tabBar.backgroundColor = .systemPink
//    let items = [item1.tabBarItem, item2.tabBarItem, item3.tabBarItem]
//        for item in items {
//
//            let attributes = [NSForegroundColorAttributeName: .systemPink]
//            item.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
//          }

        
        self.viewControllers = controllers
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
     //   print("Should select viewController: \(viewController.title ?? "") ?")
        return true;
    }
}

