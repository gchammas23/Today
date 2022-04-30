//
//  ReminderListViewController.swift
//  Today
//
//  Created by Gabriel Chammas on 30/04/2022.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    var dataSource: DataSource! // ONLY IMPLICITLY UNWRAP OPTIONALS IF WE KNOW THAT THEY WOULD ALWAYS HAVE A VALUE!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        // This will allow us to configure the cells in the collection view controller
        let cellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            let reminder = Reminder.sampleData[indexPath.item]
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = reminder.title
            cell.contentConfiguration = contentConfiguration
        }
        
        // This will make sure to reuse the configured cells to show all the data from the dataSource in to the collection view
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        var snapShot = Snapshot() // Create an empty snapshot
        snapShot.appendSections([0])
        snapShot.appendItems(Reminder.sampleData.map { $0.title })
        
        dataSource.apply(snapShot) // Apply snapshot to dataSource
        
        collectionView.dataSource = dataSource // Use dataSource as the data source of the collection view
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

}

