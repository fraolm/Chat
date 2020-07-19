//
//  TableViewController.swift
//  chat
//
//  Created by Fraol on 1/23/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if Auth.auth().currentUser?.uid == nil {
            registrationVC()
            print("cat")
        }
        print("dog")
    }
    func registrationVC(){
        do{
            try Auth.auth().signOut()
        }
        catch let logouterr {
            print(logouterr)
        }
        
        //ViewController().viewWillAppear(true)
        let c = ViewController()
        present(c, animated: false, completion: nil)
    }
}
