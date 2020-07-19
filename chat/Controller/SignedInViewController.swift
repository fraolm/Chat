//
//  SignInViewController.swift
//  chat
//
//  Created by Fraol on 1/22/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit
import Firebase

class SignedInViewController:  UITableViewController{

    var MessageArr = [message]()
    let cellID = "cellID"
    var messageDictionary = [String: message]()

    override func viewDidLoad() {
       
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logOutHandler))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(HandelNewMessage))
        
        // DONT KNOW WHY I WROTE THIS HERE
        let straightline = UIView()
        straightline.translatesAutoresizingMaskIntoConstraints = false
        straightline.backgroundColor = UIColor().color(r: 220, g: 220, b: 220)
      //  view.addSubview(straightline)
        //print("running viewdidload signedinview ")
        
        checkIfUserLogedOut()
        //showMessageTableview()
        
       }
    // to move to the chat view controller
    @objc func handlemessageChat(userArr: user){
        //initalized the collectionview controller to UIcollectionciewflowlayout to display the cell 
        let chatlogincontroller = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatlogincontroller.navTitle = userArr
        
        
        navigationController?.pushViewController(chatlogincontroller, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 100
       }
    var runner = [message]()
    // loads the cell on the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let Message = MessageArr[indexPath.row]
        cell.message1 = Message
       // print("Processed the profile ")
            return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Message = MessageArr[indexPath.row]
        guard let SelctedUserId = Message.chatpartnerId() else {
            return
        }
        let ref = Database.database().reference().child("users").child(SelctedUserId)
        ref.observeSingleEvent(of: .value) { (DataSnapshot) in
            if let Dictionary = DataSnapshot.value as? [String: AnyObject]{
                let user1 = user()
                user1.setValuesForKeys(Dictionary)
                user1.id = SelctedUserId
                self.handlemessageChat(userArr: user1)
                
            }
            
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("row num",MessageArr.count)
        return MessageArr.count
    }

    // access the user-message and message and display text history of the right user
    func showUserMessage(){
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        print("user name "+uid)
        let ref = Database.database().reference().child("user-Message").child(uid)
 // "childadd" observes the values one at a time
        ref.observe(.childAdded, with: { (DataSnapshot) in
            
            let userToid = DataSnapshot.key
            let innerRef = Database.database().reference().child("user-Message").child(uid).child(userToid)
            innerRef.observe(.childAdded, with: { (DataSnapshot) in
                let messageKey = DataSnapshot.key
                Database.database().reference().child("Message").child(messageKey).observeSingleEvent(of: .value, with: { (Snapshot) in
                    //print(Snapshot)
                    if let Dictionary = Snapshot.value as? [String:AnyObject]{
                        //print("dic......", Dictionary)
                        let messageValue = message()
                        messageValue.setValuesForKeys(Dictionary)
                        
                        //self.Message.append(messageValue)
                        if let ToId = messageValue.chatpartnerId(){
                            self.messageDictionary[ToId] = messageValue
                            
                        }
                    }
                    
                    //runing the background thread. With time delay for the profileImage mismatch
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        
                        self.MessageArr = Array(self.messageDictionary.values)
                        self.MessageArr.sort { (message1, message2) -> Bool in
                            return message1.TimeStamp!.intValue > message2.TimeStamp!.intValue
                        }
                        self.tableView.reloadData()
                    }

                }, withCancel: nil)
            })

        }, withCancel: nil)
        
        // Used this reference to access the node under the user ID of the user that sent the message
        // The value of this
        //let ref = Database.database().reference().child("user-Message").child(uid)
        
    }

    @objc func HandelNewMessage (){
        
        let viewcontroller = NewContactsViewController()
        viewcontroller.newmessage = self
        let VCNavController = UINavigationController(rootViewController: viewcontroller)
        VCNavController.modalPresentationStyle = .fullScreen
        present(VCNavController, animated: true, completion: nil )
    }
    func checkIfUserLogedOut(){
        if Auth.auth().currentUser == nil{
            perform(#selector(logOutHandler), with: self, afterDelay: 0.01)
        
        }
        else{
            showUserMessage()
        }
    }
     func handelreloadmessage(){
        MessageArr.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        showUserMessage()
    }
    
    // Sign out authentication handler
    @objc func logOutHandler(){
        
        do{
            try Auth.auth().signOut()
        }
        catch let logouterr{
            print(logouterr)
        }
        print("Succusfully Loged out")
        
        let viewController = ViewController()
        viewController.SignedInVC = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
              
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
   
}
