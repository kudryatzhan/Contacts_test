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
                self.createContactsDictionary()
                self.tableView.reloadData()
            }
        }
    }
    
    // Filtered Contacts
    var filteredContacts = [Contact]()
    
    
    // Contacts indexes
    var contactsDictionary = [String: [Contact]]()
    var contactSectionTitles = [String]()
    
    // Search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Seach contacts"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        ContactController.getContact { (contacts) in
            self.contacts = contacts.sorted(by: { (contactA, contactB) -> Bool in
                return contactA.lastName < contactB.lastName
            })
        }
    }
    
    // MARK: - Private methods
    
    // Returns true if text is empty or nil
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchTerm(_ searchTerm: String) {
        filteredContacts = contacts.filter({ (contact) -> Bool in
            return contact.lastName.lowercased().contains(searchTerm.lowercased()) || contact.firstName.lowercased().contains(searchTerm.lowercased())
        })
        
        tableView.reloadData()
    }
    
    // Returns status if searchController is active and searchBar is not empty
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - Helper methods
    func createContactsDictionary() {
        for contact in contacts {
            // Get the first letter of contact's last name
            let firstLetterIndex = contact.lastName.startIndex
            let contactKey = String(contact.lastName[firstLetterIndex])
            
            if var contactValues = contactsDictionary[contactKey] {
                contactValues.append(contact)
                contactsDictionary[contactKey] = contactValues
            } else {
                contactsDictionary[contactKey] = [contact]
            }
        }
        
        // Get section titles from dictionary's keys and sort ascending
        contactSectionTitles = [String](contactsDictionary.keys)
        contactSectionTitles = contactSectionTitles.sorted { $0 < $1 }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return isFiltering() ? 1 : contactSectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isFiltering() ? nil : contactSectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredContacts.count
        } else {
            let contactKey = contactSectionTitles[section]
            guard let contactValues = contactsDictionary[contactKey] else { return 0 }
            
            return contactValues.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        // Configure the cell...
        
        if isFiltering() {
            let contact = filteredContacts[indexPath.row]
            cell.textLabel?.text = "\(contact.lastName) \(contact.firstName)"
        } else {
            let contactKey = contactSectionTitles[indexPath.section]
            if let contactValues = contactsDictionary[contactKey] {
                let contact = contactValues[indexPath.row]
                cell.textLabel?.text = "\(contact.lastName) \(contact.firstName)"
            }
        }
        
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return isFiltering() ? nil : contactSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        
        headerView.textLabel?.textColor = UIColor.purple
        headerView.textLabel?.font = UIFont(name: "Avenir", size: 22.0)
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContactDetailVC",
            let indexPath = tableView.indexPathForSelectedRow,
            let destinationVC = segue.destination as? ContactDetailTableViewController {
            
            if isFiltering() {
                destinationVC.contact = filteredContacts[indexPath.row]
            } else {
                let contactKey = contactSectionTitles[indexPath.section]
                let contact = contactsDictionary[contactKey]?[indexPath.row]
                destinationVC.contact = contact
            }
        }
    }
    
}

extension ContactListTableViewController: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        if let searchTerm = searchController.searchBar.text {
            filterContentForSearchTerm(searchTerm)
        }
    }
}
