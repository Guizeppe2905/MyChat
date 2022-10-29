//
//  ContactsViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 26.10.2022.
//

import UIKit

class ContactsViewController: UIViewController {
    
    var users = [CurrentUserModel]()

    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ContactCellModel>! = nil
    var collectionView: UICollectionView! = nil
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    private lazy var contactsTitleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 22)
        label.textColor = .systemPink
        label.text = "Выберите пользователя и начните с ним личный чат"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var navImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "horizontalBack")
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.addSubview(contactsTitleLabel)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.bounds

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 20) as Any]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        
        getUsers()
        view.addSubview(navImageView)
        setupConstraints()
    }
    private func getUsers() {
        Service.shared.getListOfUsers { [weak self] users in
            self?.users = users
            self?.configureHierarchy()
            self?.configureDataSource()
            self?.collectionView.delegate = self
            self?.collectionView.reloadData()

        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            navImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -120),
            navImageView.heightAnchor.constraint(equalToConstant: 250),
            
            contactsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            contactsTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            contactsTitleLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 60),
            contactsTitleLabel.heightAnchor.constraint(equalToConstant: 80),
            
        ])
    }
}

extension ContactsViewController {
    private func createLayout(isLandscape: Bool = false, size: CGSize) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnv) -> NSCollectionLayoutSection? in
            let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                         heightDimension: .fractionalHeight(1.0))
            let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .fractionalHeight(0.3))
            let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let trailingLeftGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 2)
            
            let trailingRightGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 2)
            let fractionalHeight = NSCollectionLayoutDimension.fractionalHeight(0.4)
            let groupDimensionHeight: NSCollectionLayoutDimension = fractionalHeight
            
            let rightGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupDimensionHeight),
                subitems: [leadingItem, trailingLeftGroup, trailingRightGroup])
            
            let leftGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupDimensionHeight),
                subitems: [trailingRightGroup, trailingLeftGroup, leadingItem])
            
            let height = size.height / 1.25
            let megaGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(height)),
                subitems: [rightGroup, leftGroup])
            
            let section = NSCollectionLayoutSection(group: megaGroup)
            return section
        }
    }
}

extension ContactsViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout(size: view.bounds.size))
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundView = UIImageView(image: UIImage(named: "background"))
        collectionView.register(ContactTableViewCell.self, forCellWithReuseIdentifier: ContactTableViewCell.reuseIdentifier)
        view.addSubview(collectionView)
        view.bringSubviewToFront(collectionView)
        view.bringSubviewToFront(navImageView)
      
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ContactCellModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, model: ContactCellModel) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ContactTableViewCell.reuseIdentifier,
                for: indexPath) as? ContactTableViewCell else { fatalError("Не получилось создать новую ячейку") }
            cell.image = ContactsViewModel.produce(using: .random)
            let nickCell = self.users[indexPath.row]
            cell.configure(viewModel: nickCell)
            cell.imageContentMode = .scaleAspectFill
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ContactCellModel>()
        snapshot.appendSections([.main])
        
        func produceImage() -> UIImage {
            guard let image = ContactsViewModel.produce(using: .random) else {
                fatalError("Ошибка с загрузкой картинки...")
            }
            return image
        }
        
        let models = (0..<users.count).map { _ in ContactCellModel(image: produceImage()) }
        snapshot.appendItems(models)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ContactsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userID = users[indexPath.row].id
        let userAva = users[indexPath.row].photoURL
        let userNick = users[indexPath.row].nickname
        let vc = ChatViewController()
        vc.userAva = userAva
        vc.otherUserID = userID
        vc.userNick = userNick
        vc.otherUserVM = users[indexPath.row]
        Service.shared.getChatID(userID: userID) { chatID in
            vc.chatID = chatID
        }
            vc.otherUserID = userID
            self.navigationController?.pushViewController(vc, animated: true)
     
    }
}
