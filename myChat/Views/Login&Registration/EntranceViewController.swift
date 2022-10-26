//
//  ViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit

class EntranceViewController: TemplateViewController {
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Пусть ваше общение будет таким же теплым и уютым как и при личной встрече ..."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .systemYellow
        return label
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(.brown, for: .normal)
        button.backgroundColor = .systemYellow
        return button
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        registrationButton.addTarget(self, action: #selector(didTapregistrationButton), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(didTapEnterButton), for: .touchUpInside)
    }

    private func setupView() {
        
        view.addSubview(descriptionLabel)
        view.addSubview(registrationButton)
        view.addSubview(enterButton)
    }
    
    @objc private func didTapregistrationButton() {
        Router.shared.navigateToVC(RegistrationViewController())
    }
    
    @objc private func didTapEnterButton() {
        Router.shared.navigateToVC(LoginViewController())
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 430),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 330),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 200),
            
            registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationButton.bottomAnchor.constraint(equalTo: enterButton.topAnchor, constant: -20),
            registrationButton.widthAnchor.constraint(equalToConstant: 340),
            registrationButton.heightAnchor.constraint(equalToConstant: 50),
            
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            enterButton.widthAnchor.constraint(equalToConstant: 340),
            enterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

