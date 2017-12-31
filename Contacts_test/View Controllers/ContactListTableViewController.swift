//
//  ContactListTableViewController.swift
//  Contacts_test
//
//  Created by Kudryatzhan Arziyev on 12/31/17.
//  Copyright © 2017 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    var contacts = [Contact]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ContactController.getContact { (contacts) in
            self.contacts = contacts.sorted(by: { (contactA, contactB) -> Bool in
                return contactA.lastName < contactB.lastName
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let contact = contacts[indexPath.row]
        
        // Configure the cell...
        cell.textLabel?.text = "\(indexPath.row + 1) \(contact.lastName) \(contact.firstName)"
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContactDetailVC",
            let indexPath = tableView.indexPathForSelectedRow,
            let destinationVC = segue.destination as? ContactDetailTableViewController {
            
            destinationVC.contact = contacts[indexPath.row]
        }
    }
}
