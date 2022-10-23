//
//  TemplateViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit

class TemplateViewController: UIViewController {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "startBackground")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ваш Чат"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .systemYellow
        return label
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(.brown, for: .normal)
        return button
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Есть аккаунт?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        view.addSubview(submitButton)
//        view.addSubview(enterButton)
        setupConstraints()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
    }
    
    private func setupView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.bounds
        view.addSubview(titleLabel)
    }
    
//    func setButtons(mainButton: String, subButton: String) {
//        submitButton.setTitle(mainButton, for: .normal)
//        enterButton.setTitle(subButton, for: .normal)
//        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
//        enterButton.addTarget(self, action: #selector(enter), for: .touchUpInside)
////        view.addSubview(submitButton)
////        view.addSubview(enterButton)
//    }
//
//    @objc func submit(direction: UIViewController) {
//        let vc = direction
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @objc func enter(direction: UIViewController) {
//        let vc = direction
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 260),
            titleLabel.widthAnchor.constraint(equalToConstant: 250),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
//            
//            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            submitButton.bottomAnchor.constraint(equalTo: enterButton.topAnchor, constant: -20),
//            submitButton.widthAnchor.constraint(equalToConstant: 340),
//            submitButton.heightAnchor.constraint(equalToConstant: 50),
//            
//            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            enterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
//            enterButton.widthAnchor.constraint(equalToConstant: 340),
//            enterButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
}
