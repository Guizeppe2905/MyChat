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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        navigationItem.title = "Начните чат с другом"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 20) as Any]
        navigationController?.navigationBar.backgroundColor = .systemPink
     //   navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemYellow, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 20) as Any], for: .normal)
   
        
        getUsers()
       
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
}

extension ContactsViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // In order to get the corrent size for the view, we need get the size of the container view when the animation happens or finishes (so we autolayout computes the final sizes)
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let `self` = self else { return }
            let size = context.containerView.bounds.size
            
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                let layout = self.createLayout(isLandscape: true, size: size)
                self.collectionView.setCollectionViewLayout(layout, animated: true, completion: nil)
                self.collectionView.collectionViewLayout = layout
            case .portrait, .portraitUpsideDown:
                let layout = self.createLayout(isLandscape: false, size: size)
                self.collectionView.setCollectionViewLayout(layout, animated: true, completion: nil)
            default:
                return
            }
        })
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
            
            let fractionalHeight = isLandscape ? NSCollectionLayoutDimension.fractionalHeight(0.8) : NSCollectionLayoutDimension.fractionalHeight(0.4)
            let groupDimensionHeight: NSCollectionLayoutDimension = fractionalHeight
            
            let rightGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupDimensionHeight),
                subitems: [leadingItem, trailingLeftGroup, trailingRightGroup])
            
            let leftGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupDimensionHeight),
                subitems: [trailingRightGroup, trailingLeftGroup, leadingItem])
            
            let height = isLandscape ? size.height / 0.9 : size.height / 1.25
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
        collectionView.backgroundColor = .systemGray3
        collectionView.register(ContactTableViewCell.self, forCellWithReuseIdentifier: ContactTableViewCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ContactCellModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, model: ContactCellModel) -> UICollectionViewCell? in
            
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ContactTableViewCell.reuseIdentifier,
                for: indexPath) as? ContactTableViewCell else { fatalError("Could not create new cell") }
            cell.image = ContactCellViewModel.produce(using: .random)
            let nickCell = self.users[indexPath.row]
            cell.configure(viewModel: nickCell)
//            cell.nicknameLabel.text = self.users[indexPath.row].nickname
            cell.imageContentMode = .scaleAspectFill
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            
            return cell
        }
        
        // Initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, ContactCellModel>()
        snapshot.appendSections([.main])
        
        func produceImage() -> UIImage {
            guard let image = ContactCellViewModel.produce(using: .random) else {
                fatalError("Could not generate an UIImage instance by using the ImageFactory struct")
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
        let vc = ChatViewController()
        vc.chatID = "temporary_id"
        vc.otherUserID = userID
     //   self.navigationController?.pushViewController(vc, animated: true)
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 30
        }
        present(vc, animated: true, completion: nil)
        
    }
}
