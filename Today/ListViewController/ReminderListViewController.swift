//
//  ReminderListViewController.swift
//  Today
//
//  Created by Gabriel Chammas on 30/04/2022.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    
    var dataSource: DataSource! // ONLY IMPLICITLY UNWRAP OPTIONALS IF WE KNOW THAT THEY WOULD ALWAYS HAVE A VALUE!
    var reminders: [Reminder] = Reminder.sampleData

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        // This will allow us to configure the cells in the collection view controller
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        // This will make sure to reuse the configured cells to show all the data from the dataSource in to the collection view
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        updateSnapShot() // Apply updated snapshot
        
        
        collectionView.dataSource = dataSource // Use dataSource as the data source of the collection view
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

}

