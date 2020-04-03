//
//  ContactDetailTableViewController.swift
//  Contacts
//
//  Created by Theo Vora on 4/3/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import UIKit

class ContactDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var contact: Contact? {
        didSet {
            updateView()
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            !firstName.isEmpty,
            !lastName.isEmpty
            else { return }
        
        if let contact = contact {
            // UPDATE existing contact

            contact.firstName = firstName
            contact.lastName = lastName
            
            ContactController.shared.update(contact: contact) { (result) in
                switch result {
                case .success:
                    print("Updated contact.")
                case .failure:
                    print("Failed to update contact.")
                }
            }
        } else {
            // CREATE new contact
            ContactController.shared.saveContact(firstName: firstName, lastName: lastName, phoneNumber: "", emailAddress: "") { (result) in
                switch result {
                case .success:
                    print("Created contact.")
                case .failure:
                    print("Failed to create contact.")
                }
            }
        }
        navigationController?.popViewController(animated: true)
    } // end saveButtonTapped
    
    
    // MARK: - Helper Functions
    
    func updateView() {
        guard let contact = contact else { return }
        firstNameTextField.text = contact.firstName
        lastNameTextField.text = contact.lastName
    }

}
