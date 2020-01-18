//
//  CompositionalViewController.swift
//  DropDownMenu
//
//  Created by Алексей Пархоменко on 18.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class OutlineItem: Hashable {
    let title: String
    let indentLevel: Int
    let subitems: [OutlineItem]
    let name: String?
    private let identifier = UUID()

    var isExpanded = false

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    init(title: String,
         indentLevel: Int = 0,
         name: String? = nil,
         subitems: [OutlineItem] = []) {
        self.title = title
        self.indentLevel = indentLevel
        self.subitems = subitems
        self.name = name
    }
    
    var isGroup: Bool {
        return self.name == nil
    }
}

class CompositionalViewController: UIViewController {
    
    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>! = nil
    var outlineCollectionView: UICollectionView! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Int>! = nil
    
//    private lazy var menuItems: [OutlineItem] = [
//        OutlineItem(title: "First Level 1", indentLevel: 0, subitems: [
//            OutlineItem(title: "Second level 1", indentLevel: 1, name: "1"),
//            OutlineItem(title: "Second level 2", indentLevel: 1, name: "2")]
//        ),
//        OutlineItem(title: "First Level 2", indentLevel: 0)
//    ]
    
    private lazy var menuItems: [OutlineItem] = [
        OutlineItem(title: "write text", indentLevel: 0, name: "0.0"),
        OutlineItem(title: "user name", indentLevel: 0, name: "0.1"),
        OutlineItem(title: "enlarge arrow", indentLevel: 0, subitems: [
            OutlineItem(title: "user info", indentLevel: 1, name: "1.0")]
        ),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List"
        configureHierarchy()
        configureDataSource()
    }
    
    private func configureHierarchy() {
        outlineCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        outlineCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        outlineCollectionView.backgroundColor = .systemBackground
        outlineCollectionView.register(OutlineItemCell.self, forCellWithReuseIdentifier: OutlineItemCell.reuseIdentifier)
        view.addSubview(outlineCollectionView)
        outlineCollectionView.delegate = self
        
    }
    
    func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource
            <Section, OutlineItem>(collectionView: outlineCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, menuItem: OutlineItem) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OutlineItemCell.reuseIdentifier,
                for: indexPath) as? OutlineItemCell else { fatalError("Could not create new cell") }
            cell.label.text = menuItem.title
            cell.indentLevel = menuItem.indentLevel
            cell.isGroup = menuItem.isGroup
            cell.isExpanded = menuItem.isExpanded
            return cell
        }

        // load our initial data
        let snapshot = snapshotForCurrentState()
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, OutlineItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, OutlineItem>()
        snapshot.appendSections([Section.main])
        
        menuItems.forEach { (menuItem) in
            snapshot.appendItems([menuItem])
            if menuItem.isExpanded {
                menuItem.subitems.forEach { (subMenuItem) in
//                    snapshot.appendItems([subMenuItem])
                    snapshot.insertItems([subMenuItem], beforeItem: menuItem)
                 
                }
            }
        }
       
//        func addItems(_ menuItem: OutlineItem) {
//            
//            snapshot.appendItems([menuItem])
//            if menuItem.isExpanded {
//                menuItem.subitems.forEach { addItems($0) }
//            }
//        }
//        menuItems.forEach { addItems($0) }
        return snapshot
    }
    
    func updateUI() {
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemHeightDimension = NSCollectionLayoutDimension.absolute(44)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: itemHeightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: itemHeightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

extension CompositionalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print(indexPath)
        
        guard let menuItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if menuItem.isGroup {
            menuItem.isExpanded.toggle()
            if let cell = collectionView.cellForItem(at: indexPath) as? OutlineItemCell {
                UIView.animate(withDuration: 0.3) {
                    cell.isExpanded = menuItem.isExpanded
                    self.updateUI()
                }
            }
        } else {
            if let name = menuItem.name {
                print(name)
            }
        }
    }
}
