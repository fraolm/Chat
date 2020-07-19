//
//  ViewController.swift
//  chat
//
//  Created by Fraol on 1/14/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    var SignedInVC: SignedInViewController?
    
    let ViewInputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    let registerbutton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = UIColor().color(r: 61, g: 91, b: 151)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
      //button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleDatabaseStoragebutton), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // handels the new user registration
    @objc func handleDatabaseStoragebutton(){
      
       
        // The email, password, name are optional values
        guard let email = emailtextfield.text, let password = passwordtextfield.text, let name = textfield.text  else {
            print("form is not valid")
            return
        }
        
       //setting up the firebase authentication and database
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            if error != nil {
                print("an error has occured")
                print(error?.localizedDescription as Any)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            // Unique name for the images
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageName).jpeg")
            guard let UploadData = self.imageview.image?.jpegData(compressionQuality: 0.1) else {
                return
            }
            storageRef.putData(UploadData, metadata: nil) { (StorageMetadata, Error) in
                if Error != nil {
                    print(Error!.localizedDescription)
                    return
                }
                
                // Gets the URL for the image and inputs it in the database
                // Registers the a new user
                storageRef.downloadURL { (url, Error) in
                    guard let downloadURL = url?.absoluteString else {
                        print("An error has occured downloadUrl")
                        return}
                    let value = ["name": name, "email": email, "profileImageURL": downloadURL] as [String: AnyObject]
                    // Rester new user
                    self.RegisterNewUserToDatabase(value)
                    
                }
            }
        }
    }
    // private function registers new users to the database
    private func RegisterNewUserToDatabase(_ value: [String: AnyObject]){
        
        
        
        // creating a reference variable and also reference for the current user.
        
        var ref: DatabaseReference!
        guard let user = Auth.auth().currentUser else { return }
                  
        //database part "make sure the rule in the database is changed to true"
        // Creating a JSON format
        
        ref = Database.database().reference()
        let reference = ref.child("users").child(user.uid)
        reference.updateChildValues(value) {(err, ref) in
        if err != nil{
            print(err?.localizedDescription as Any)
            return
        }
        
        
        print("Registration saved Sucessfully")
            
        }
    }
    
    let textfield: UITextField = {
       let textf = UITextField()
        textf.placeholder = "Name"
        textf.translatesAutoresizingMaskIntoConstraints = false
        return textf
    }()
    
    let textsepareter: UIView = {
        let textSep = UIView()
        textSep.translatesAutoresizingMaskIntoConstraints = false
        textSep.backgroundColor = UIColor().color(r: 220, g: 220, b: 220)
        return textSep
    }()
    
    let emailtextfield: UITextField = {
       let textf = UITextField()
        textf.placeholder = "Email address"
        textf.translatesAutoresizingMaskIntoConstraints = false
        return textf
    }()

    let Emailtextsepareter: UIView = {
        let textSep = UIView()
        textSep.translatesAutoresizingMaskIntoConstraints = false
        textSep.backgroundColor = UIColor().color(r: 220, g: 220, b: 220)
        return textSep
    }()
    let passwordtextfield: UITextField = {
        let textf = UITextField()
        textf.placeholder = "Password"
        textf.translatesAutoresizingMaskIntoConstraints = false
        textf.isSecureTextEntry = true
        return textf
       }()
    
    // For the gestures features; tap the icon on the register page
    
    lazy var imageview: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icons8-contacts-50")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        
        // used to access images from the phone for profile photos; editing is also possible
        // The function for the gesture feature is on the extension of this swift file
        let imageviewGesture = UITapGestureRecognizer(target: self, action: #selector(HandlerFortheImageStorage))
        imageView.addGestureRecognizer(imageviewGesture)
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
   
    
    // Button that will direct the user to the login page
    let loginbutton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Already have an account?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(loginpage), for: UIControl.Event.touchDragInside)
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().color(r: 0, g: 102, b: 204)
        view.addSubview(ViewInputContainer)
        view.addSubview(registerbutton)
        view.addSubview(imageview)
        view.addSubview(loginbutton)
        constriantForLoginButton()
        ConstraintViewinputContainer()
        constraintbuttonview()
        constriantForImageView()

        
    }
    func handleWillShow(){
    }
    //Login method that directs it to the loginContoller page
    
    @objc func loginpage(){
        let login = LoginController()
        login.VCsignedIn = SignedInVC
        show(login, sender: self)
        
        
    }
    func constriantForLoginButton(){
        loginbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginbutton.topAnchor.constraint(equalTo: registerbutton.bottomAnchor, constant: 24).isActive = true
        loginbutton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginbutton.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    func constriantForImageView(){
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageview.bottomAnchor.constraint(equalTo: ViewInputContainer.topAnchor, constant: -15).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func constraintbuttonview() {
        // x, y , width , height constraints
        registerbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerbutton.topAnchor.constraint(equalTo:ViewInputContainer.bottomAnchor , constant: 12).isActive = true
        registerbutton.widthAnchor.constraint(equalTo: ViewInputContainer.widthAnchor).isActive = true
        registerbutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //Constraint the input container
    func ConstraintViewinputContainer() {
        
        ViewInputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor ).isActive = true
        ViewInputContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        ViewInputContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        ViewInputContainer.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        ViewInputContainer.addSubview(textfield)
        ViewInputContainer.addSubview(textsepareter)
        ViewInputContainer.addSubview(emailtextfield)
        ViewInputContainer.addSubview(Emailtextsepareter)
        ViewInputContainer.addSubview(passwordtextfield)
        constriantsForTextfield()
        constriantForTextSeparater()
        constriantEmailTextfield()
        constriantEmailsepareter()
        constriantpasswordTextfield()
        // x, y, width, height constriants

        
    }
    
    func constriantsForTextfield(){
        // x, y, width, height constriants
        
        textfield.leftAnchor.constraint(equalTo: ViewInputContainer.leftAnchor, constant: 12).isActive = true
        textfield.topAnchor.constraint(equalTo: ViewInputContainer.topAnchor).isActive = true
        textfield.widthAnchor.constraint(equalTo: ViewInputContainer.widthAnchor).isActive = true
        textfield.heightAnchor.constraint(equalTo: ViewInputContainer.heightAnchor, multiplier: 1/3).isActive = true
        
    }
    
    func constriantForTextSeparater(){
         textsepareter.leftAnchor.constraint(equalTo: ViewInputContainer.leftAnchor).isActive = true
         textsepareter.topAnchor.constraint(equalTo: textfield.bottomAnchor).isActive = true
         textsepareter.widthAnchor.constraint(equalTo: ViewInputContainer.widthAnchor).isActive = true
         textsepareter.heightAnchor.constraint(equalToConstant: 1).isActive = true
         
         
     }

    func constriantEmailTextfield(){
        
        emailtextfield.leftAnchor.constraint(equalTo: ViewInputContainer.leftAnchor, constant: 12).isActive = true
        emailtextfield.topAnchor.constraint(equalTo: textsepareter.bottomAnchor).isActive = true
        emailtextfield.widthAnchor.constraint(equalTo: ViewInputContainer.widthAnchor).isActive = true
        emailtextfield.heightAnchor.constraint(equalTo: ViewInputContainer.heightAnchor, multiplier: 1/3).isActive = true
        
    }
    
    func constriantEmailsepareter(){
        
        Emailtextsepareter.leftAnchor.constraint(equalTo: ViewInputContainer.leftAnchor).isActive = true
        Emailtextsepareter.topAnchor.constraint(equalTo: emailtextfield.bottomAnchor).isActive = true
        Emailtextsepareter.widthAnchor.constraint(equalTo: ViewInputContainer.widthAnchor).isActive = true
        Emailtextsepareter.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    func constriantpasswordTextfield(){
        passwordtextfield.leftAnchor.constraint(equalTo: ViewInputContainer.leftAnchor, constant: 12).isActive = true
        passwordtextfield.topAnchor.constraint(equalTo: Emailtextsepareter.bottomAnchor).isActive = true
        passwordtextfield.widthAnchor.constraint(equalTo: ViewInputContainer.widthAnchor).isActive = true
        passwordtextfield.heightAnchor.constraint(equalTo: ViewInputContainer.heightAnchor, multiplier: 1/3).isActive = true
    }


        
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }


}

extension UIColor {
    func color(r:CFloat, g: CFloat, b: CFloat) -> UIColor {
        return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: 1)
    }
}
