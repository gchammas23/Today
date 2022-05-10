//
//  RemonderListViewController+DataSource.swift
//  Today
//
//  Created by Gabriel Chammas on 08/05/2022.
//

import UIKit

extension ReminderListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
    
    func updateSnapShot(reloading ids: [Reminder.ID] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map { $0.id })
        
        if !ids.isEmpty { // Maintain the reminders to save changes made
            snapshot.reloadItems(ids)
        }
        
        dataSource.apply(snapshot)
    }
    
    // Creates a cell to display a reminder in
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminder(for: id) // Start by getting the reminder
        
        // Set text of cell (Text and secondary text)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        // Set the done button and disclosure indicator for each cell
        var doneBtnConfiguration = doneButtonConfigurator(for: reminder)
        doneBtnConfiguration.tintColor = .todayListCellDoneButtonTint
        cell.accessibilityCustomActions = [ doneButtonAccessibilityAction(for: reminder) ]
        cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        cell.accessories = [.customView(configuration: doneBtnConfiguration), .disclosureIndicator(displayed: .always)]
        
        // Set the backgroud color of the cell
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    private func doneButtonConfigurator(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "checkmark.circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        
        let button = ReminderDoneButton()
        button.id = reminder.id // Set id of button to be the id of the reminder
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside) // Add a target when the button is clicked to run didPressDoneButton
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(with: reminder.id)
            return true
        }
        
        return action
    }
    
    func completeReminder(with id: Reminder.ID) {
        // Fetch the reminder
        var reminder = reminder(for: id)
        
        // Toggle the isComplete property of the reminder to true
        reminder.isComplete.toggle()
        
        // Update the reminders array with the update reminder
        update(reminder, for: id)
        
        // Make sure to update the snapshot
        updateSnapShot(reloading: [id])
    }
    
    // Returns the reminder with the specified id
    func reminder(for id: Reminder.ID) -> Reminder {
        let reminderIndex = reminders.indexOfReminder(with: id)
        return reminders[reminderIndex]
    }
    
    // Updates the reminder with the specified id by the reminder passed
    func update(_ reminder: Reminder, for id: Reminder.ID) {
        let indexToUpdate = reminders.indexOfReminder(with: id)
        reminders[indexToUpdate] = reminder
    }
}
