//
//  ContactError.swift
//  Contacts
//
//  Created by Theo Vora on 4/3/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import Foundation

enum ContactError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    
    var errorDescription: String? {
        switch self {
            
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to unwrap this contact."
        }
    } // end errorDescription
} // end enum
