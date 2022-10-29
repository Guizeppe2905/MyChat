//
//  ProfileViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 26.10.2022.
//

import UIKit
import Combine
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    private var flagAvatarImage = false
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        return imageView
    }()

    private lazy var downloadPicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Сменить аватарку", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.textColor = .white
        return button
    }()
    
    private lazy var filterPicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Применить фильтр к фото", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.textColor = .white
        return button
    }()
    
    private lazy var changeUserDataButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Изменить личные данные", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.textColor = .white
        return button
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
      let image = UIImage(named: "ava1")
        imageView.image = image
        imageView.layer.cornerRadius = 100
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.bounds
        view.addSubview(downloadPicButton)
        view.addSubview(filterPicButton)
        view.addSubview(changeUserDataButton)
        view.addSubview(avatarImageView)
        setupConstraints()
        downloadPicButton.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
        filterPicButton.addTarget(self, action: #selector(filterItButtonPressed), for: .touchUpInside)
        changeUserDataButton.addTarget(self, action: #selector(changeUserDataButtonPressed), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сменить аккаунт", style: .plain, target: self, action: #selector(logOutButtonPressed))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 16) as Any], for: .normal)
    }
    
    @objc func logOutButtonPressed(controller: UIViewController) {
        alertLogOut()
    }
    
    @objc func changeUserDataButtonPressed(controller: UIViewController) {
        alertResetSettings()
    }
    
    @objc private func didTapDownloadButton() {
        presetPhotoActionSheet()
    }
    
    @objc private func filterItButtonPressed() {
        guard let originalImage = self.avatarImageView.image else { return }
        applyRandomFilters(to: originalImage) { [weak self] filteredImage in
            self?.avatarImageView.image = filteredImage
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
      
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            avatarImageView.widthAnchor.constraint(equalToConstant: 200),
            avatarImageView.heightAnchor.constraint(equalToConstant: 200),
            
            downloadPicButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            downloadPicButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 50),
            downloadPicButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            downloadPicButton.heightAnchor.constraint(equalToConstant: 60),
            
            filterPicButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterPicButton.topAnchor.constraint(equalTo: downloadPicButton.bottomAnchor, constant: 40),
            filterPicButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterPicButton.heightAnchor.constraint(equalToConstant: 60),
            
            changeUserDataButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            changeUserDataButton.topAnchor.constraint(equalTo: filterPicButton.bottomAnchor, constant: 40),
            changeUserDataButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            changeUserDataButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presetPhotoActionSheet() {
        alertPhotoLibrary { [weak self] source in
            guard let self = self else { return }
            self.chooseImagePicker(source: source)
        }
    }
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[.editedImage] as? UIImage
        avatarImageView.image = image
        flagAvatarImage = true
        picker.dismiss(animated: true)
        
        guard let img = image else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        
        let fileName = "\(email)_profIMG.png"
        
        Service.shared.updateUser(withEmail: email, image: img, filename: fileName, completion: { [weak self] results in
            guard let self = self else { return }
           
            switch results.code {
            case 0:
                self.alertOk(title: "Не удалось изменить данные", message: "Попробуйте снова.")

            case 1:
                self.alertOk(title: "Аватар изменен", message: "Новая аватарка успешно сохранена")
               
            default:
          break
            }
        })
    }
}
extension ProfileViewController: ObsevableSelectImage {
    
    func selectObservableImage(_ image: UIImage) {
        self.avatarImageView.image = image
        
 
        
        
//        guard let email = Auth.auth().currentUser?.email else { return }
//        Service.shared.userExists(with: email, completion: { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case true:
//                <#code#>
//            case false:
//                break
//
//            }})
        
        
      
        
       // Service.shared.createNewUser(<#T##data: RegistrationModel##RegistrationModel#>, completion: <#T##(ResponseCode) -> ()#>)
    }
}
