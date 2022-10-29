//
//  RegistrationViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit

class RegistrationViewController: OnboardingVM {
    
    private var passwordIsVisible: Bool = false
    private var passwordConfirmationIsVisible: Bool = false
    
    lazy var nicknameTF: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.placeholder = "Введите никнэйм или имя"
        return textField
    }()
    
    private lazy var nicknameError: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 12)
        label.textColor = .systemPink
        return label
    }()
    
    private lazy var emailTF: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
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
    
    private lazy var buttonLock: UIButton = {
        let buttonLock = UIButton(type: .custom)
        buttonLock.setImage(UIImage(systemName: "lock.slash.fill"), for: .normal)
        buttonLock.tintColor = .systemYellow
        return buttonLock
    }()
    
    private lazy var confirmationButtonLock: UIButton = {
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
    
    private lazy var passwordError: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 12)
        label.textColor = .systemPink
        return label
    }()
    
    private lazy var repeatPasswordTF: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.placeholder = "Повторите пароль"
        textField.isSecureTextEntry = true
        textField.rightViewMode = .unlessEditing
        textField.rightView = confirmationButtonLock
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var repeatPasswordError: UILabel = {
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
        view.addSubview(nicknameTF)
        view.addSubview(emailTF)
        view.addSubview(emailError)
        view.addSubview(passwordTF)
        view.addSubview(passwordError)
        view.addSubview(submitButton)
        view.addSubview(enterButton)
        view.addSubview(nicknameError)
        view.addSubview(repeatPasswordTF)
        view.addSubview(repeatPasswordError)
        resetForm()
        setupConstraints()
        buttonLock.addTarget(self, action: #selector(didTapButtonLock), for: .touchUpInside)
        confirmationButtonLock.addTarget(self, action: #selector(didTapConfirmationButtonLock), for: .touchUpInside)
        nicknameTF.addTarget(self, action: #selector(nicknameDidChange), for: .editingChanged)
        emailTF.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        repeatPasswordTF.addTarget(self, action: #selector(repeatPasswordDidChange), for: .editingChanged)
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(didTapEnterButton), for: .touchUpInside)
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
    
    @objc private func didTapConfirmationButtonLock(_ sender: Any) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        if (sender as! UIButton).isSelected {
            passwordConfirmationIsVisible = true
            confirmationButtonLock.setImage(UIImage(systemName: "lock.fill"), for: .normal)
            repeatPasswordTF.isSecureTextEntry = false
        } else {
            passwordConfirmationIsVisible = false
            confirmationButtonLock.setImage(UIImage(systemName: "lock.slash.fill"), for: .normal)
            repeatPasswordTF.isSecureTextEntry = true
        }
    }
    
    @objc private func didTapEnterButton() {
        Router.shared.navigateToVC(LoginViewController())
    }
    
    private func resetForm() {
        submitButton.isEnabled = false
        nicknameError.isHidden = false
        emailError.isHidden = false
        passwordError.isHidden = false
        repeatPasswordError.isHidden = false
        nicknameError.text = "Обазательное поле"
        emailError.text = "Обазательное поле"
        passwordError.text = "Обазательное поле"
        repeatPasswordError.text = "Обазательное поле"
        nicknameTF.text = ""
        emailTF.text = ""
        passwordTF.text = ""
        repeatPasswordTF.text = ""
    }
    
    @objc private func nicknameDidChange(_ textField: UITextField) {
        if let nick = nicknameTF.text {
            if let errorMessage = invalidNickname(nick) {
                nicknameError.text = errorMessage
                nicknameError.isHidden = false
            } else {
                nicknameError.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    private func invalidNickname(_ value: String) -> String? {
        if value.count < 6 {
            return "Никнэйм должен содержать не менее 6 знаков"
        }
        if containsDigit(value) {
            return "Ник также должен содержать как минимум 1 цифру"
        }
        
        if value.count > 8 {
            return "Ник не должен превышать 8 знаков"
        }
    
        return nil
    }
    
    @objc private func emailDidChange(_ textField: UITextField) {
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
    
    private func invalidEmail(_ value: String) -> String? {
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value) {
            return "Неправильный ввод"
        }
        return nil
    }
    
   @objc private func passwordDidChange(_ textField: UITextField) {
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
    
    private func invalidPassword(_ value: String) -> String? {
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
    
    @objc private func repeatPasswordDidChange(_ textField: UITextField) {
        if let repeatPassword = repeatPasswordTF.text {
            if let errorMessage = invalidPasswordConfirmation(repeatPassword) {
                repeatPasswordError.text = errorMessage
                repeatPasswordError.isHidden = false
            } else {
                repeatPasswordError.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    private func invalidPasswordConfirmation(_ value: String) -> String? {
        if passwordTF.text != repeatPasswordTF.text {
            return "Пароли не совпадают"
        } else {
            return "Пароль подтвержден"
        }
      
    }
    
    private func containsDigit(_ value: String) -> Bool {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    private func containsLowerCase(_ value: String) -> Bool {
        let reqularExpression = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    private func containsUpperCase(_ value: String) -> Bool {
        let reqularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    private func checkForValidForm() {
        if emailError.isHidden && passwordError.isHidden {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
    
    @objc private func submitAction() {
 
        guard let nick = nicknameTF.text, let email = emailTF.text, let password = passwordTF.text else { return }
        
        let photoURL = "ava1"
        
        Service.shared.createNewUser(RegistrationModel(nickname: nick, email: email, password: password, photoURL: photoURL)) { [weak self] code in
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
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            nicknameTF.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            nicknameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameTF.widthAnchor.constraint(equalToConstant: 340),
            nicknameTF.heightAnchor.constraint(equalToConstant: 50),
            
            nicknameError.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameError.topAnchor.constraint(equalTo: nicknameTF.bottomAnchor),
            nicknameError.widthAnchor.constraint(equalToConstant: 340),
            nicknameError.heightAnchor.constraint(equalToConstant: 20),
            
            emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTF.topAnchor.constraint(equalTo: nicknameError.bottomAnchor),
            emailTF.widthAnchor.constraint(equalToConstant: 340),
            emailTF.heightAnchor.constraint(equalToConstant: 50),
            
            emailError.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailError.topAnchor.constraint(equalTo: emailTF.bottomAnchor),
            emailError.widthAnchor.constraint(equalToConstant: 340),
            emailError.heightAnchor.constraint(equalToConstant: 20),
            
            passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTF.topAnchor.constraint(equalTo: emailError.bottomAnchor),
            passwordTF.widthAnchor.constraint(equalToConstant: 340),
            passwordTF.heightAnchor.constraint(equalToConstant: 50),
            
            passwordError.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordError.topAnchor.constraint(equalTo: passwordTF.bottomAnchor),
            passwordError.widthAnchor.constraint(equalToConstant: 340),
            passwordError.heightAnchor.constraint(equalToConstant: 20),
            
            repeatPasswordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repeatPasswordTF.topAnchor.constraint(equalTo: passwordError.bottomAnchor),
            repeatPasswordTF.widthAnchor.constraint(equalToConstant: 340),
            repeatPasswordTF.heightAnchor.constraint(equalToConstant: 50),

            repeatPasswordError.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repeatPasswordError.topAnchor.constraint(equalTo: repeatPasswordTF.bottomAnchor),
            repeatPasswordError.widthAnchor.constraint(equalToConstant: 340),
            repeatPasswordError.heightAnchor.constraint(equalToConstant: 20),
            
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
