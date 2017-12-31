//
//  ContactController.swift
//  Contacts_test
//
//  Created by Kudryatzhan Arziyev on 12/31/17.
//  Copyright © 2017 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit

class ContactController {
    
    // static base URL
    static let baseURL = URL(string: "http://www.mocky.io/v2/")
    
    // static function for getting contacts
    static func getContact(completion: @escaping ([Contact]) -> Void) {
        
        // url
        guard let requestUrl = baseURL?.appendingPathComponent("5a488f243000004c15c3c57e") else { completion([]); return }
        
        // request
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        // data task
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else { completion([]); return }
            
            let decoder = JSONDecoder()
            
            guard let contacts = try? decoder.decode([Contact].self, from: data) else { completion([]); return }
            
            completion(contacts)
        }
        
        dataTask.resume()
    }
    
    // static function for images
    static func image(forURLAsString urlAsString: String, completion: @escaping (UIImage?) -> Void) {
        
        // url
        guard let requestURL = URL(string: urlAsString) else { completion(nil); return }
        
        // request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        // data task
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else { completion(nil); return }
            
            let image = UIImage(data: data)
            completion(image)
        }
        dataTask.resume()
    }
}
