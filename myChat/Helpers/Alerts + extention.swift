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
        let title = "Забыли пароль?"
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
    
    func alertPhotoLibrary(completionHandler: @escaping (UIImagePickerController.SourceType) -> Void) {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let photoLibrary = UIAlertAction(title: "Фотогалерея", style: .default) { _ in
                let photoLibrary = UIImagePickerController.SourceType.photoLibrary
                completionHandler(photoLibrary)
            }
            
            let cancel = UIAlertAction(title: "Отмена", style: .cancel)
            
            alertController.addAction(photoLibrary)
            alertController.addAction(cancel)
            
            present(alertController, animated: true)
        }
}

