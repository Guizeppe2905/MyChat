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
 
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 10)
        label.textColor = .systemYellow
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
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nicknameLabel)
        setupConstrints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: CurrentUserModel) {
        nicknameLabel.text = viewModel.nickname
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        if let imgString = viewModel.photoURL {
            Service.shared.loadImage(stringUrl: imgString, completion: { [weak self] (image) in
                self?.avatarImageView.image = image
            })
        } else if ((viewModel.photoURL?.contains("ava1")) != nil) || viewModel.photoURL == "" {
            guard let image = avatars.randomElement() else { return }
            avatarImageView.image = UIImage(named: image)
        } else {
            guard let image = avatars.randomElement() else { return }
            avatarImageView.image = UIImage(named: image)
        }
    }
        
    func setupConstrints() {
        
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
            nicknameLabel.heightAnchor.constraint(equalToConstant: 25)
            ])
    }
    
}

