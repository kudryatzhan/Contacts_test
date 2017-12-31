//
//  Contact.swift
//  Contacts_test
//
//  Created by Kudryatzhan Arziyev on 12/31/17.
//  Copyright © 2017 Kudryatzhan Arziyev. All rights reserved.
//

import Foundation

struct Contact: Codable {
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case gender = "gender"
        case ipAddress = "ip_address"
        case photoURLAsString = "photo"
        case employment = "employment"
    }
    
    let firstName: String
    let lastName: String
    let email: String
    let gender: String
    let ipAddress: String
    let photoURLAsString: String
    let employment: [String: String]
}
