//
//  ListOfChatsViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit

class ListOfChatsViewController: UIViewController {
    
    var users = [CurrentUserModel]()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    private lazy var contactsTitleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 22)
        label.textColor = .systemPink
        label.text = "Форум со всеми пользователями приложения"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var enterForumButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Вступить в форум", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.textColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.bounds
        view.addSubview(contactsTitleLabel)
        view.addSubview(enterForumButton)

        setupConstraints()
        getUsers()
        enterForumButton.addTarget(self, action: #selector(didTapEnterForumButton), for: .touchUpInside)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
    }
    
    @objc private func didTapEnterForumButton() {
        let userID = users[0].id
        let vc = ChatViewController()
        vc.chatID = "kjhk"
        vc.otherUserID = userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getUsers() {
        Service.shared.getListOfUsers { [weak self] users in
            self?.users = users

        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            contactsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            contactsTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            contactsTitleLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 60),
            contactsTitleLabel.heightAnchor.constraint(equalToConstant: 80),
            
            enterForumButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            enterForumButton.topAnchor.constraint(equalTo: contactsTitleLabel.bottomAnchor, constant: 330),
            enterForumButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            enterForumButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
}
