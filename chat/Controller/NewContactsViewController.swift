//
//  NewContactsViewController.swift
//  chat
//
//  Created by Fraol on 1/26/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit
//import Foundation
import Firebase

class NewContactsViewController: UITableViewController,  URLSessionDelegate , URLSessionTaskDelegate, URLSessionDataDelegate{
    var users = [user]()
    let cellID = "CellId"
    var newmessage: SignedInViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(HandelCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        fatchUser()
        
    }
    
    // changes to another viewcontroller when the contact is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true){
            self.newmessage?.handlemessageChat(userArr: self.users[indexPath.row])
        }
    }
    
    func fatchUser(){
        
        Database.database().reference().child("users").observe(.childAdded) { (DataSnapshot) in
            
            if let Dictionary = DataSnapshot.value as? [String: AnyObject]{
                let user1 = user()
                user1.id = DataSnapshot.key
                user1.setValuesForKeys(Dictionary)
                self.users.append(user1)
                
                // This will fail because of the background thread, to fix we use dispatch queue
                // it will return control while runing the block of code.
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func HandelCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // returns a reusable tableview cell for the specified identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let user1 = users[indexPath.row]
        cell.textLabel?.text = user1.name
        cell.detailTextLabel?.text = user1.email
        
        if let imageProfileUrl = user1.profileImageURL {
            //method for accessing download profile image
            cell.profileImage.loadcache(urlstring: imageProfileUrl)
        }
       
        
         
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}


// Create a UITableviewcell class to use the subtitle features, because we dont have this programmatically.
