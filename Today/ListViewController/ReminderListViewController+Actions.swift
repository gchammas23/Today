//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Gabriel Chammas on 10/05/2022.
//

import UIKit

extension ReminderListViewController {
    
    // Will be called when the done button is pressed
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return } // Get the id of the reminder from the sender
        completeReminder(with: id) // Update the reminder (Complete or not)
    }
}
