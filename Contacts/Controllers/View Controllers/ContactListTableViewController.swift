//
//  ContactListTableViewController.swift
//  Contacts
//
//  Created by Theo Vora on 4/3/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.shared.contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let contact = ContactController.shared.contacts[indexPath.row]
        
        cell.textLabel?.text = contact.fullName
        
        return cell
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContactDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ContactDetailTableViewController
                else { return }
            
            let selectedContact = ContactController.shared.contacts[indexPath.row]
            
            destinationVC.contact = selectedContact
        }
    }
    
    
    
    // MARK: - Helper Functions
    
    func loadContacts() {
        ContactController.shared.fetchAllContacts { (result) in
            switch result {
            case .success(let success):
                if success {
                    DispatchQueue.main.async {
                        self.updateViews()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
