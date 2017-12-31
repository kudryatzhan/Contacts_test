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
    
    // FilteredContacts
    var filteredContacts = [Contact]()
    
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
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredContacts.count
        } else {
            return contacts.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let contact = isFiltering() ? filteredContacts[indexPath.row] : contacts[indexPath.row]
        
        // Configure the cell...
        cell.textLabel?.text = "\(contact.lastName) \(contact.firstName)"
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContactDetailVC",
            let indexPath = tableView.indexPathForSelectedRow,
            let destinationVC = segue.destination as? ContactDetailTableViewController {
            
            destinationVC.contact = isFiltering() ? filteredContacts[indexPath.row] : contacts[indexPath.row]
            
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
