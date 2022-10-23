//
//  MainViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit

class ContactsViewController: UIViewController {
    
    var users = [CurrentUserModel]()
    
    private lazy var usersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            usersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usersTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            usersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
}

extension ContactsViewController: UITableViewDelegate {
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

extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = users[indexPath.row].email
        return cell
    }
    
    
}
