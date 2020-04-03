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
    
    var contact: Contact?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
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
            contact.phoneNumber = phoneNumberTextField.text ?? ""
            contact.emailAddress = emailTextField.text ?? ""
            
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
            ContactController.shared.saveContact(
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumberTextField.text ?? "",
                emailAddress: emailTextField.text ?? "") { (result) in
                    
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
        phoneNumberTextField.text = contact.phoneNumber
        emailTextField.text = contact.emailAddress
    }
    
}
