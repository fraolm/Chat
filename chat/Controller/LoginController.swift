//
//  LoginController.swift
//  chat
//
//  Created by Fraol on 1/16/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit
import Firebase
// This is the view conrroller login page
// Uses email and password authentication main Firebase
class LoginController: UIViewController {
    
    let loginEmailcontainer: UIView = {
        let email = UIView()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.layer.cornerRadius = 20
        email.layer.borderColor = UIColor().color(r: 230, g: 76, b: 0).cgColor
        email.layer.borderWidth = 3
        return email
    }()
    let loginemail: UITextField = {
        let email = UITextField()
        email.placeholder = "email"
        email.backgroundColor = .white
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    let passwordcontainer: UIView = {
        let password = UIView()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.layer.borderColor = UIColor().color(r: 230, g: 76, b: 0).cgColor
        password.layer.cornerRadius = 20
        password.layer.borderWidth = 3
        password.backgroundColor = .white
        return password
    }()
    
    let loginpassword: UITextField = {
        let password = UITextField()
        password.placeholder = "Password"
        password.backgroundColor = .white
        password.translatesAutoresizingMaskIntoConstraints = false
        password.isSecureTextEntry = true
        return password
    }()
    let loginbutton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.shadowOpacity = 0.25
        button.backgroundColor = UIColor().color(r: 230, g: 70, b: 0)
        button.addTarget(self, action: #selector(LoginMainPage), for: .touchUpInside)
        
        return button
    }()
        
    var VCsignedIn: SignedInViewController?
    @objc func LoginMainPage(){
        guard let email = loginemail.text, let password = loginpassword.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (authresult, Error) in
            if Error != nil{
                print("An error has occured")
                print(Error!.localizedDescription)
                return
            }
            print("done... loging in")
            
            //dissmisses the two viewcontrollers
            self.VCsignedIn?.handelreloadmessage()
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            
            
        }
    }
    // The sign in text
    let SignInTextfeild: UILabel = {
        let signin = UILabel()
        signin.text = "Sign In"
        signin.font = UIFont(name: "Times New Roman", size: 20)
        signin.translatesAutoresizingMaskIntoConstraints = false
        signin.font = UIFont.boldSystemFont(ofSize: 16)
        return signin
        
    }()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(loginEmailcontainer)
        view.addSubview(loginemail)
        view.addSubview(passwordcontainer)
        view.addSubview(loginpassword)
        view.addSubview(loginbutton)
        view.addSubview(SignInTextfeild)
        
        constriantForloginemail()
        constriantForloginEmailcontainer()
        constriantForpasswordcontainer()
        constriantForloginpassword()
        constriantForLoginButton()
        constriantForSiginText()
        
    }
    //constriant for the signin text display
    func constriantForSiginText(){
        SignInTextfeild.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        SignInTextfeild.bottomAnchor.constraint(equalTo: loginEmailcontainer.topAnchor, constant: -20).isActive = true
        SignInTextfeild.widthAnchor.constraint(equalTo: loginEmailcontainer.widthAnchor, multiplier: 1/3).isActive = true
        SignInTextfeild.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    //constriant for the login button
    func constriantForLoginButton(){
        loginbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginbutton.topAnchor.constraint(equalTo: passwordcontainer.bottomAnchor, constant: 25).isActive = true
        loginbutton.widthAnchor.constraint(equalTo: passwordcontainer.widthAnchor, multiplier: 1.5/3).isActive = true
        loginbutton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    // constriants for the password login
    func constriantForloginpassword(){
        loginpassword.centerXAnchor.constraint(equalTo: passwordcontainer.centerXAnchor).isActive = true
        loginpassword.centerYAnchor.constraint(equalTo: passwordcontainer.centerYAnchor).isActive = true
        loginpassword.widthAnchor.constraint(equalTo: loginemail.widthAnchor).isActive = true
        loginpassword.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    //constriants for the password container
    func constriantForpasswordcontainer(){
        // x, y, width, height
        passwordcontainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordcontainer.topAnchor.constraint(equalTo: loginEmailcontainer.bottomAnchor, constant: 16).isActive = true
        passwordcontainer.widthAnchor.constraint(equalTo: loginEmailcontainer.widthAnchor).isActive = true
        passwordcontainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    //constraint for login email container
    
    func constriantForloginEmailcontainer(){
        // x, y, width, height
        loginEmailcontainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginEmailcontainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginEmailcontainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        loginEmailcontainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    func constriantForloginemail(){
        loginemail.centerXAnchor.constraint(equalTo: loginEmailcontainer.centerXAnchor).isActive = true
        loginemail.centerYAnchor.constraint(equalTo: loginEmailcontainer.centerYAnchor).isActive = true
        loginemail.leftAnchor.constraint(equalTo: loginEmailcontainer.leftAnchor, constant: 12).isActive = true
        loginemail.rightAnchor.constraint(equalTo: loginEmailcontainer.rightAnchor, constant: -12).isActive = true
        loginemail.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}
