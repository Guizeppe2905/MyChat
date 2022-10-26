//
//  ContactTableViewCell.swift
//  myChat
//
//  Created by Мария Хатунцева on 26.10.2022.
//

import UIKit

class ContactTableViewCell: UICollectionViewCell, ReuseIdentifiable {
    
    var users = [CurrentUserModel]()
    let avatars = ["ava1", "ava2", "ava3", "ava4", "ava5", "ava6"]
    var inset: Int = 25
    // MARK: - Properties
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
     //   label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 10)
        //UIFont(name: "Avenir", size: 10)
        label.textColor = .systemYellow
      //  label.text = "HOHOH"
        label.backgroundColor = .systemPink
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.contentMode = .center
        
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
      
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = imageContentMode
        
        return imageView
    }()
    var imageContentMode: UIImageView.ContentMode = .scaleAspectFit {
        didSet {
            imageView.contentMode = imageContentMode
        }
    }
    var image: UIImage? = .init() {
        didSet {
            imageView.image = image
        //   nicknameLabel.text = "HOHOH"
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // configure(viewModel: users)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: CurrentUserModel) {
        nicknameLabel.text = viewModel.nickname
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        guard let image = avatars.randomElement() else { return }
        avatarImageView.image = UIImage(named: image)
        contentView.addSubview(imageView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nicknameLabel)

        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),

            nicknameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nicknameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            nicknameLabel.widthAnchor.constraint(equalToConstant: 250),
                                                    //contentView.frame.size.width),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 25)
                                                    //contentView.frame.size.height / 4)
            ])
    }
    
}


//extension ImageCell: Configurable {
//    func configure(viewModel: CurrentUserModel) {
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(imageView)
//        contentView.addSubview(nicknameLabel)
//
//        let inset: CGFloat = 0.0
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
//            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
//
//            nicknameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            nicknameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3.0),
//            nicknameLabel.widthAnchor.constraint(equalToConstant: contentView.frame.size.width - 2),
//            nicknameLabel.heightAnchor.constraint(equalToConstant: contentView.frame.size.height / 3)
//            ])
//    }
//}
