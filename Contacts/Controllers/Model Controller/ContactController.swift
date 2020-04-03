//
//  ContactController.swift
//  Contacts
//
//  Created by Theo Vora on 4/3/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import CloudKit

class ContactController {
    
    // MARK: - Source of Truth and Shared Instance
    
    static let shared = ContactController()
    var contacts: [Contact] = []
    let privateDB = CKContainer.default().privateCloudDatabase
    
    
    // MARK: - CRUD Functions
    
    func saveContact(firstName: String,
                     lastName: String,
                     phoneNumber:String,
                     emailAddress: String,
                     completion: @escaping (Result<Contact?, ContactError>) -> Void) {
        
        let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, emailAddress: emailAddress)
        
        let record = CKRecord(contact: contact)
        
        privateDB.save(record) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
            let contact = Contact(ckRecord: record) else {
                return completion(.failure(.couldNotUnwrap))
            }
            
            self.contacts.insert(contact, at: 0)
            return completion(.success(contact))
        }
    }
    
    func fetchAllContacts( completion: @escaping (Result<Bool, ContactError>) -> Void ) {
        let predicate = NSPredicate(value: true) // return all records
        
        let query = CKQuery(recordType: ContactConstants.recordType, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
        
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else {
                return completion(.failure(.couldNotUnwrap))
            }
            
            let contactsFromCK: [Contact] = records.compactMap(Contact.init(ckRecord: ))
            
            self.contacts = contactsFromCK
            return completion(.success(true))
        }
    }
    
    func update(contact: Contact, completion: @escaping (Result<Contact?, ContactError>) -> Void) {
        let record = CKRecord(contact: contact)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print(error.localizedDescription + " --> \(error)")
                completion(.failure(.ckError(error)))
                return
            }
            
            guard let record = records?.first,
            let updatedContact = Contact(ckRecord: record)
                else { completion(.failure(.couldNotUnwrap)); return }
            
            completion(.success(updatedContact))
        }
        
        privateDB.add(operation)
    }
    
    func delete(contact: Contact, completion: @escaping (Result<Bool, ContactError>) -> Void) {
        
    }
    
} // end class
