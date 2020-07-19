//
//  UserCell.swift
//  chat
//
//  Created by Fraol on 3/15/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit
import Firebase
class UserCell: UITableViewCell {
    var namecheck = [String]()
    var message1: message?{
        didSet{
           SetupNameAndProfileImage()
                detailTextLabel?.text = message1?.text
                if let second = message1?.TimeStamp?.doubleValue{
                    //let timeStampDate = Date(timeIntervalSinceReferenceDate: second)
                    let timeStampDate = NSDate(timeIntervalSince1970: second)
                    let Date_formatter = DateFormatter()
                    
                    // formats the date 12 hour time. Depending on what you want."h" - 12 hours
                    Date_formatter.dateFormat = "h:mm:ssa"
                    timeStamp.text = Date_formatter.string(from: timeStampDate as Date)

                
            }
        }
    }
    
    var trackProfile = [String: Any]()
    
    // sets up the profile image, the latest text, latest time, and the name of the user
    
    func SetupNameAndProfileImage(){
        if let toId = message1?.chatpartnerId(){
                //print("shit",toId)
             let ref = Database.database().reference().child("users").child(toId)
               // print("cat")
             ref.observeSingleEvent(of: .value, with: { (DataSnapshot) in
                      //print(DataSnapshot)
             if let Dictionary = DataSnapshot.value as? [String: Any]{
                     //   print("inner pro:", Dictionary)
                     self.textLabel?.text = Dictionary["name"] as? String
                         if let profileImage = Dictionary["profileImageURL"] {
                             self.profileImage.loadcache(urlstring:profileImage as! String)
                                 }
                                                
                         }
             }, withCancel: nil)
        }
            
    }
    
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 27
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let timeStamp: UILabel = {
        let second = UILabel()
        second.translatesAutoresizingMaskIntoConstraints = false
        
        return second
    }()
   
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 75, y: (textLabel?.frame.origin.y)!-2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 75, y: (detailTextLabel?.frame.origin.y)!+2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImage)
        addSubview(timeStamp)
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 55).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        //constriants for the label
        timeStamp.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        //timeStamp.centerYAnchor.constraint(equalTo: detailTextLabel!.centerYAnchor).isActive = true
        timeStamp.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        timeStamp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeStamp.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

