//
//  LoginViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit
import FirebaseAuth
//import FirebaseDatabase

class LoginViewController: OnboardingVM {
    
    private var passwordIsVisible: Bool = false
    
    private lazy var emailTF: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.placeholder = "Введите email"
        return textField
    }()
    
    private lazy var buttonLock: UIButton = {
        let buttonLock = UIButton(type: .custom)
        buttonLock.setImage(UIImage(systemName: "lock.slash.fill"), for: .normal)
        buttonLock.tintColor = .systemYellow
        return buttonLock
    }()
    
    private lazy var passwordTF: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.placeholder = "Введите пароль"
        textField.isSecureTextEntry = true
        textField.rightViewMode = .unlessEditing
        textField.rightView = buttonLock
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(.brown, for: .normal)
        return button
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Нет аккаунта?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(forgotPasswordButton)
        view.addSubview(submitButton)
        view.addSubview(enterButton)
        setupConstraints()
        buttonLock.addTarget(self, action: #selector(didTapButtonLock), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(didTapEnterButton), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPasswordButton), for: .touchUpInside)
    }
    
    @objc private func didTapForgotPasswordButton() {
        self.alertForgotPassword(actionHandler: { email in
            guard let email = email else { return }
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    print("didTapPasswordFogotButton: ", error)
                    self.alertOk(title: "Ошибка", message: "Сбросить пароль не удалось, пожалуйста, повторите запрос.")
                }
                self.alertOk(title: "Запрос выполнен", message: "На ваш email \(email) отправлено письмо с инструкцией по смене пароля.")
            }
        })
    }
    
    @objc private func didTapButtonLock(_ sender: Any) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        if (sender as! UIButton).isSelected {
            passwordIsVisible = true
            buttonLock.setImage(UIImage(systemName: "lock.fill"), for: .normal)
            passwordTF.isSecureTextEntry = false
        } else {
            passwordIsVisible = false
            buttonLock.setImage(UIImage(systemName: "lock.slash.fill"), for: .normal)
            passwordTF.isSecureTextEntry = true
        }
    }
    
    @objc private func didTapSubmitButton() {
        let reg = RegistrationViewController()
        guard let nick = reg.nicknameTF.text, let email = emailTF.text, let password = passwordTF.text, let photoURL = UIImage(named: "ava1")?.toPngString() else { return }
        let authData = RegistrationModel(nickname: nick, email: email, password: password, photoURL: photoURL)
    
        Service.shared.login(authData) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
                
            case .isVerified:
                Router.shared.navigateToVC(TabBarViewController())
            case .isRegistered:
//                self.alertOk(title: "Email не был подтвержден", message: "Но вы можете пользоваться мессенджером... На почту выслано повторное оповещение о необходимости верифицировать почту.")
//
//                Service.shared.sendEmailConfirmation()
                Router.shared.navigateToVC(TabBarViewController())
                
            case .isUnknown:
                self.alertOk(title: "Ошибка авторизации", message: "Проверьте правильность ввода данных и попробуйте снова.")
            }
            
        }
    }
    
    @objc private func didTapEnterButton() {
        Router.shared.navigateToVC(RegistrationViewController())
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 430),
            emailTF.widthAnchor.constraint(equalToConstant: 340),
            emailTF.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 10),
            passwordTF.widthAnchor.constraint(equalToConstant: 340),
            passwordTF.heightAnchor.constraint(equalToConstant: 50),
            
            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: -10),
            forgotPasswordButton.widthAnchor.constraint(equalToConstant: 340),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 50),

            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: enterButton.topAnchor, constant: -20),
            submitButton.widthAnchor.constraint(equalToConstant: 340),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            enterButton.widthAnchor.constraint(equalToConstant: 340),
            enterButton.heightAnchor.constraint(equalToConstant: 50)

        ])
    }
}
