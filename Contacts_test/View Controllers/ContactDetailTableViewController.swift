//
//  ContactDetailTableViewController.swift
//  Contacts_test
//
//  Created by Kudryatzhan Arziyev on 12/31/17.
//  Copyright © 2017 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit

class ContactDetailTableViewController: UITableViewController {
    
    var contact: Contact?
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var jobPositionLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let contact = contact else { return }
        
        self.title = contact.ipAddress
        
        fullNameLabel.text = "\(contact.lastName) \(contact.firstName)"
        emailLabel.text = contact.email
        companyNameLabel.text = contact.employment["name"]
        jobPositionLabel.text = contact.employment["position"]
        
        ContactController.image(forURLAsString: contact.photoURLAsString) { (photoImage) in
            DispatchQueue.main.async {
                self.photoImageView.image = photoImage
            }
        }
    }
}
