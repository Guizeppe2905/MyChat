//
//  Alerts + extention.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit
import FirebaseAuth

extension UIViewController {
    
    func alertOkCancel(title: String, message: String?, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(ok)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func alertOk(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ОК", style: .default)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func alertDismiss(title: String, message: String?, completionHandler: @escaping () -> Void) {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "ОК", style: .default) { _ in
                completionHandler()
            }
            alertController.addAction(ok)
            
            present(alertController, animated: true, completion: nil)
        }
    
    func alertForgotPassword(cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                             actionHandler: ((_ text: String?) -> Void)? = nil) {
        let title = "Забыли или хотите сменить пароль?"
        let subtitle = "Введите в поле ваш email."
        let okButtonTitle = "Сменить пароль"
        let cancelButtonTitle = "Отмена"
        let placeholder = "Email в формате email@email.com"
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = placeholder
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .done
        }
        
        alert.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { (action: UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertChangeNickname(cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                             actionHandler: ((_ text: String?) -> Void)? = nil) {
        let title = "Вы хотите изменить никнэйм?"
        let subtitle = "Введите в поле ваш новый ник"
        let okButtonTitle = "Сменить ник"
        let cancelButtonTitle = "Отмена"
        let placeholder = "Введите новый никнейм"
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = placeholder
            textField.keyboardType = .default
            textField.returnKeyType = .done
        }
        
        alert.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { (action: UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertPhotoLibrary(completionHandler: @escaping (UIImagePickerController.SourceType) -> Void) {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let photoLibrary = UIAlertAction(title: "Фотогалерея", style: .default) { _ in
                let photoLibrary = UIImagePickerController.SourceType.photoLibrary
                completionHandler(photoLibrary)
            }
        
        let photoCamera = UIAlertAction(title: "Камера", style: .default) { _ in
            let photoCamera = UIImagePickerController.SourceType.camera
            completionHandler(photoCamera)
        }
            
            let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(photoCamera)
            alertController.addAction(photoLibrary)
            alertController.addAction(cancel)
            
            present(alertController, animated: true)
        }
    
    func alertLogOut(cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                             actionHandler: ((_ text: String?) -> Void)? = nil) {
        let title = "Выйти из аккунта"
        let subtitle = "Вы действительно хотите покинуть аккаунт?"
        let okButtonTitle = "Да"
        let cancelButtonTitle = "Отмена"
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
   
        alert.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { (action: UIAlertAction) in
            Router.shared.navigateToVC(EntranceViewController())
            do {
                try FirebaseAuth.Auth.auth().signOut()
            } catch {
                print(error.localizedDescription)
            }
        }))
        
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertResetSettings(cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                             actionHandler: ((_ text: String?) -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let nickname = UIAlertAction(title: "Сменить никнейм", style: .default) { _ in
            self.alertChangeNickname(actionHandler: { nickname in
                guard let nickname = nickname else { return }
                guard let userID = Auth.auth().currentUser?.uid else { return }
                Service.shared.updateNickName(withID: userID, newNickName: nickname, completion: { [weak self] results in
                    guard let self = self else { return }
                   
                    switch results.code {
                    case 0:
                        self.alertOk(title: "Никнейм изменен", message: "Новый ник успешно сохранен.")
                        

                    case 1:
                        self.alertOk(title: "Не удалось изменить никнейм.", message: "Попробуйте снова.")
                       
                    default:
                  break
                    }
                })
            })
        }
    
    let password  = UIAlertAction(title: "Сменить пароль", style: .default) { _ in

        
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
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(nickname)
        alertController.addAction(password)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }


}

