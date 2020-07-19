//
//  FirebaseController.swift
//  chat
//
//  Created by Fraol on 1/17/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit
import Firebase

class FirebaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func createuser(email: String, password: String,  completionBlock: @escaping(_ success: Bool)->Void){
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if error != nil{
                print(error)
                return
            }
            
            
        }
    }

}
