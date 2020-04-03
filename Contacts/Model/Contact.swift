//
//  Contact.swift
//  Contacts
//
//  Created by Theo Vora on 4/3/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import CloudKit

struct ContactConstants {
    static let recordType = "Contact"
    fileprivate static let firstNameKey = "firstName"
    fileprivate static let lastNameKey = "lastName"
    fileprivate static let phoneNumberKey = "phoneNumber"
    fileprivate static let emailAddressKey = "emailAddress"
}

class Contact {
    var firstName: String
    var lastName: String
    var phoneNumber: String?
    var emailAddress: String?
    var recordID: CKRecord.ID
    
    init(firstName: String,
         lastName: String,
         phoneNumber:String = "",
         emailAddress: String = "",
         recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.recordID = recordID
    }
}

extension Contact {
    convenience init?(ckRecord: CKRecord) {
        guard let firstName = ckRecord[ContactConstants.firstNameKey] as? String,
            let lastName = ckRecord[ContactConstants.lastNameKey] as? String,
            let phoneNumber = ckRecord[ContactConstants.phoneNumberKey] as? String,
            let emailAddress = ckRecord[ContactConstants.emailAddressKey] as? String
            else { return nil }
        
        
        self.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, emailAddress: emailAddress)
    }
}

extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: ContactConstants.recordType, recordID: contact.recordID)
        
        setValuesForKeys([
            ContactConstants.firstNameKey: contact.firstName,
            ContactConstants.lastNameKey: contact.lastName
        ])
        
        if let phoneNumber = contact.phoneNumber {
            self.setValue(phoneNumber, forKey: ContactConstants.phoneNumberKey)
        }
        
        if let emailAddress = contact.emailAddress {
            self.setValue(emailAddress, forKey: ContactConstants.emailAddressKey)
        }
    }
}


extension Contact: Equatable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.recordID == rhs.recordID
    }
}
