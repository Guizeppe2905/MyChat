//
//  ListOfChatsViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit

class ListOfChatsViewController: UIViewController {
    
    var users = [CurrentUserModel]()
    
    private lazy var contactsTitleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 20)
        label.textColor = .systemBrown
        label.text = "Начните переписку с любым из списка контактов"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var usersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(contactsTitleLabel)
        view.addSubview(usersTableView)
        usersTableView.delegate = self
        usersTableView.dataSource = self
        setupConstraints()
        getUsers()
    }
    
    private func getUsers() {
        Service.shared.getListOfUsers { [weak self] users in
            self?.users = users
            self?.usersTableView.reloadData()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            contactsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            contactsTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            contactsTitleLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 60),
            contactsTitleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            usersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usersTableView.topAnchor.constraint(equalTo: contactsTitleLabel.bottomAnchor, constant: 30),
            usersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
}

extension ListOfChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userID = users[indexPath.row].id
        let vc = ChatViewController()
        vc.chatID = "kjhk"
        vc.otherUserID = userID
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let chat = ChatViewController()
//        chat.chatID = "temporary_id"
//        chat.otherUserID = "ptWTLbnogwWvZ9sOl27HkXISUTA2"
//        navigationController?.pushViewController(chat, animated: true)
    }
}

extension ListOfChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = users[indexPath.row].nickname
        return cell
    }
    
    
}
