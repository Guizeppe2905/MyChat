//
//  RegistrationViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit

class RegistrationViewController: TemplateViewController {
    
    private lazy var emailTF: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите email"
        return textField
    }()
    
    private lazy var emailError: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 12)
        label.textColor = .systemPink
        return label
    }()
    
    private lazy var passwordTF: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите пароль"
        return textField
    }()
    
    private lazy var passwordError: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 12)
        label.textColor = .systemPink
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
        view.addSubview(emailTF)
        view.addSubview(emailError)
        view.addSubview(passwordTF)
        view.addSubview(passwordError)
        view.addSubview(submitButton)
        view.addSubview(enterButton)
//        setButtons(mainButton: "HHHHH", subButton: "KKKKK")
//        submit(direction: EntranceViewController())
//        enter(direction: LoginViewController())
        resetForm()
        setupConstraints()
        emailTF.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(didTapEnterButton), for: .touchUpInside)
    }
    
    @objc private func didTapEnterButton() {
        let login = LoginViewController()
        navigationController?.pushViewController(login, animated: true)
    }
    
    func resetForm() {
        submitButton.isEnabled = false
        emailError.isHidden = false
        passwordError.isHidden = false
        emailError.text = "Обазательное поле"
        passwordError.text = "Обазательное поле"
        emailTF.text = ""
        passwordTF.text = ""
    }
    
    @objc func emailDidChange(_ textField: UITextField) {
        if let email = emailTF.text {
            if let errorMessage = invalidEmail(email) {
                emailError.text = errorMessage
                emailError.isHidden = false
            } else {
                emailError.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func invalidEmail(_ value: String) -> String? {
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value) {
            return "Неправильный ввод"
        }
        return nil
    }
    
   @objc func passwordDidChange(_ textField: UITextField) {
        if let password = passwordTF.text {
            if let errorMessage = invalidPassword(password) {
                passwordError.text = errorMessage
                passwordError.isHidden = false
            } else {
                passwordError.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func invalidPassword(_ value: String) -> String? {
        if value.count < 6 {
            return "Пароль должен содержать не менее 6 знаков"
        }
        if containsDigit(value) {
            return "Пароль должен содержать как минимум 1 цифру"
        }
        if containsLowerCase(value) {
            return "В пароле должна быть хотя бы 1 прописная буква"
        }
        if containsUpperCase(value) {
            return "В пароле должна быть хотя бы 1 заглавная буква"
        }
        return nil
    }
    
    func containsDigit(_ value: String) -> Bool {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsLowerCase(_ value: String) -> Bool {
        let reqularExpression = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsUpperCase(_ value: String) -> Bool {
        let reqularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func checkForValidForm() {
        if emailError.isHidden && passwordError.isHidden {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
    
    @objc private func submitAction() {
        
        guard let email = emailTF.text, let password = passwordTF.text else { return }
        Service.shared.createNewUser(RegistrationModel(email: email, password: password)) { [weak self] code in
            guard let self = self else { return }
            switch code.code {
            case 0:
                self.alertOk(title: "Ошибка регистрации", message: "Проверьте данные и попробуйте снова.")
                print("Ошибка регистрации")
            case 1:
                self.alertOk(title: "Успешная регистрация", message: "Вы зарегистрированы. На ваш email отправлено оповещение, в котором вы сможете подтвердить регистрацию.")
                Service.shared.sendEmailConfirmation()
            default:
                print("unknown error")
            }
        }
      //  resetForm()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 430),
            emailTF.widthAnchor.constraint(equalToConstant: 340),
            emailTF.heightAnchor.constraint(equalToConstant: 50),
            
            emailError.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailError.topAnchor.constraint(equalTo: emailTF.bottomAnchor),
            emailError.widthAnchor.constraint(equalToConstant: 340),
            emailError.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTF.topAnchor.constraint(equalTo: emailError.bottomAnchor, constant: 10),
            passwordTF.widthAnchor.constraint(equalToConstant: 340),
            passwordTF.heightAnchor.constraint(equalToConstant: 50),
            
            passwordError.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordError.topAnchor.constraint(equalTo: passwordTF.bottomAnchor),
            passwordError.widthAnchor.constraint(equalToConstant: 340),
            passwordError.heightAnchor.constraint(equalToConstant: 50),
            
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
