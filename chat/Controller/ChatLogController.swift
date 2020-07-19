//
//  ChatLogController.swift
//  chat
//
//  Created by Fraol on 2/2/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit
import Firebase
class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate{
    
    let cellID = "cellID"
    var outerHeightConstraint: NSLayoutConstraint?
    var outerHeight: CGFloat?
    var navTitle: user? {
        didSet{
            navigationItem.title = navTitle?.name
            observeMessage()
        }
    }
    var MessageArr = [message]()
    func observeMessage(){
        guard let uid = Auth.auth().currentUser?.uid, let toid = navTitle?.id  else {
            return
        }
        let usermessageref = Database.database().reference().child("user-Message").child(uid).child(toid)
        usermessageref.observe(.childAdded) { (DataSnapshot) in
            let MessageKeyvalue = DataSnapshot.key
            let messageRef = Database.database().reference().child("Message").child(MessageKeyvalue)
            messageRef.observeSingleEvent(of: .value) { (Snapshot) in
                guard let messageValue = Snapshot.value as? [String:AnyObject] else{
                    return
                }
                let Message1 = message()
                Message1.setValuesForKeys(messageValue)
                
                print("check the text", Message1.text)
                self.MessageArr.append(Message1)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
              
            }
            
        }
        
    }
        
        lazy var textfield: UITextView = {
        let textfield = UITextView()
        textfield.delegate = self
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.isScrollEnabled = false
        textfield.backgroundColor = .white
        textfield.layer.cornerRadius = 14
        textfield.layer.borderWidth = 3
        textfield.font = UIFont.boldSystemFont(ofSize: 16)
        textfield.layer.borderColor = UIColor.black.cgColor
        
        return textfield
    }()
    lazy var innerTextfield: UITextView = {
        let textfield = UITextView()
        textfield.delegate = self
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.isScrollEnabled = false
        textfield.backgroundColor = .white
        textfield.layer.cornerRadius = 14
        textfield.layer.borderWidth = 0
        textfield.font = UIFont.boldSystemFont(ofSize: 16)
        return textfield
    }()
    
    
    let sendbutton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handlesend), for: .touchUpInside)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return button
    }()
    
    lazy var imageview: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "keyboard-right-arrow-button(1)")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .brown
        
        
        // used to access images from the phone for profile photos; editing is also possible
        // The function for the gesture feature is on the extension of this swift file
        let imageviewGesture = UITapGestureRecognizer(target: self, action: #selector(handlesend))
        imageView.addGestureRecognizer(imageviewGesture)
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    // able to use "enter" to send messages
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlesend()
        return true
    }
    
    
    @objc func handlesend(){
        // creat a new tree for the messages
        let ref = Database.database().reference().child("Message")
        let childref = ref.childByAutoId()
        let toId = navTitle?.id
        let fromId = Auth.auth().currentUser?.uid
        let DateRef = Date()
        let timeStamp = DateRef.timeIntervalSince1970
        let value = ["text": innerTextfield.text!,"toId": toId!, "fromId": fromId!, "TimeStamp": timeStamp] as [String : Any]
        if innerTextfield.text! != "" {
        childref.updateChildValues(value) { (error, ref) in
            if !(error == nil){
                print(error as Any)
                return
            }
            
            self.innerTextfield.text = nil
            self.textViewDidChange(self.innerTextfield)
            
            // for updating the user-message node to get all the messages send through the current user
            let userMessageref = Database.database().reference().child("user-Message").child(fromId!).child(toId!)
            let messageId = childref.key!
            userMessageref.updateChildValues([ messageId: 1])
            
            let recipiantUserMessage = Database.database().reference().child("user-Message").child(toId!).child(fromId!)
            recipiantUserMessage.updateChildValues([messageId : 1])
            
        }
    }
    }
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 30, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.backgroundColor = .white
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        //setupthisShit()
        //setupthecomponent()
        //setupKeyboard()
    }
    func setupKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleWillShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func handleWillShowKeyboard(notification: NSNotification){
        print("first trail")
    }
    func setupthisShit(){
        //view.addSubview(textfield)
        let view1 = UIView()
        view1.backgroundColor = .brown
        view1.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(view1)
        view1.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        view1.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view1.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        view1.heightAnchor.constraint(equalToConstant: 46).isActive = true
//        outerHeightConstraint = self.textfield.heightAnchor.constraint(equalToConstant: 37)
//        [self.textfield.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
//         self.textfield.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -9),
//         self.textfield.widthAnchor.constraint(equalToConstant: 355),
//         outerHeightConstraint!].forEach { (NSLayoutConstraint) in
//                   NSLayoutConstraint.isActive = true
//               }
//        let test = UIView()
//        test.translatesAutoresizingMaskIntoConstraints = false
//        test.backgroundColor = .white
//        view.addSubview(test)
//
//        test.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
//        test.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -13).isActive = true
//        test.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        test.heightAnchor.constraint(equalToConstant: 29).isActive = true
////
//        test.addSubview(imageview)
//        imageview.centerXAnchor.constraint(equalTo: test.centerXAnchor).isActive = true
//        imageview.centerYAnchor.constraint(equalTo: test.centerYAnchor).isActive = true
//        imageview.widthAnchor.constraint(equalTo: test.widthAnchor).isActive = true
//        imageview.heightAnchor.constraint(equalTo: test.heightAnchor).isActive = true
//
//        view.addSubview(innerTextfield)
//        innerTextfield.rightAnchor.constraint(equalTo: test.leftAnchor).isActive = true
//        innerTextfield.bottomAnchor.constraint(equalTo: textfield.bottomAnchor, constant: -1).isActive = true
//        innerTextfield.widthAnchor.constraint(equalToConstant: 319).isActive = true
//        innerTextfield.heightAnchor.constraint(equalToConstant: 34).isActive = true
//
//

        
        
        //collectionView.addSubview(test)
//        textfield.addSubview(imageview)
//        imageview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
//        imageview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        imageview.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        imageview.heightAnchor.constraint(equalToConstant: 30).isActive = true


    }
    override var shouldAutorotate: Bool {
        get{
            return false
        }
    }
    
    lazy var inputcontainerView: UIView = {
        
        let view1 = UIView()
        view1.backgroundColor = .white
        view1.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        view1.addSubview(self.textfield)
        outerHeightConstraint = self.textfield.heightAnchor.constraint(equalToConstant: 41)
        [self.textfield.leftAnchor.constraint(equalTo: view1.leftAnchor, constant: 10),
        self.textfield.bottomAnchor.constraint(equalTo: view1.bottomAnchor, constant: -7),
        self.textfield.widthAnchor.constraint(equalToConstant: view.frame.width-20),
        outerHeightConstraint!].forEach { (NSLayoutConstraint) in
                NSLayoutConstraint.isActive = true
            }
        
        let sendButton = UIView()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.backgroundColor = .white
        view1.addSubview(sendButton)
        
        sendButton.trailingAnchor.constraint(equalTo: view1.trailingAnchor, constant: -17).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: view1.bottomAnchor, constant: -13).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 29).isActive = true
        
        sendButton.addSubview(imageview)
        imageview.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor).isActive = true
        imageview.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        imageview.widthAnchor.constraint(equalTo: sendButton.widthAnchor).isActive = true
        imageview.heightAnchor.constraint(equalTo: sendButton.heightAnchor).isActive = true
        
        view1.addSubview(innerTextfield)
        innerTextfield.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        innerTextfield.bottomAnchor.constraint(equalTo: textfield.bottomAnchor, constant: -3).isActive = true
        innerTextfield.topAnchor.constraint(equalTo: textfield.topAnchor, constant: 3).isActive = true
        innerTextfield.widthAnchor.constraint(equalToConstant: 315).isActive = true
        innerTextfield.heightAnchor.constraint(equalToConstant: 35.3).isActive = true
            
        return view1
    }()
    //access the current text of the text or attributs. real time value
    func textViewDidChange(_ textView: UITextView) {
        
        // let estimatedSize = textView.sizeThatFits(size)
         let estimatedSize = textView.intrinsicContentSize
        
        innerTextfield.constraints.forEach { (NSLayoutConstraint) in
            if NSLayoutConstraint.firstAttribute == .height{
                NSLayoutConstraint.constant = estimatedSize.height
                print(estimatedSize.height)
                outerHeightConstraint?.constant = estimatedSize.height+3
            }
        }
        
            }
    override var inputAccessoryView: UIView? {
        get {
            return inputcontainerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    // it tansitions the layout based on the rotation
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCell
        let messageacc = MessageArr[indexPath.item]
        cell.textview.text = messageacc.text
        SetupCell(cell: cell, message: messageacc)
        cell.bubbleViewWidthConstraints?.constant = estimateSizeForText(text: messageacc.text!).width + 30
        return cell
    }
    
    private func SetupCell(cell: ChatMessageCell, message: message){
        
        if let username = navTitle?.profileImageURL {
            cell.profileImage.loadcache(urlstring: username)
        }
        if message.fromId == Auth.auth().currentUser?.uid{
            cell.bubbleView.backgroundColor = UIColor().color(r: 23, g: 165, b:137)
            cell.profileImage.isHidden = true
            cell.textview.textColor = .white
            // reverse this constraint values, when more messages come in the constraint will cause a problem ( put in both side of the condition value
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }
        else{
            cell.bubbleView.backgroundColor = .lightGray
            cell.textview.textColor = .black
            cell.profileImage.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        textfield.endEditing(true)
//    }
    
    // number of cells in the collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MessageArr.count
    }
    
    //size of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // intialize height
        var height: CGFloat =  80
        if let text = MessageArr[indexPath.item].text{
            height = estimateSizeForText(text: text).height + 20
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    
    private func estimateSizeForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        
    }
    //var textField
    // setting up the constraints
    func setupthecomponent(){
        
        let inputcontext = UIView()
        inputcontext.translatesAutoresizingMaskIntoConstraints = false
        inputcontext.backgroundColor = .white
        collectionView.addSubview(inputcontext)
        //x,y,w,h
        inputcontext.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputcontext.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        inputcontext.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputcontext.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let containerforInputText = UIView()
        inputcontext.addSubview(containerforInputText)
        containerforInputText.layer.borderColor = UIColor().color(r: 220, g: 220, b: 210).cgColor
        containerforInputText.layer.borderWidth = 1
        containerforInputText.layer.cornerRadius = 12
        containerforInputText.backgroundColor = .white
        containerforInputText.translatesAutoresizingMaskIntoConstraints = false
        
        //x,y,w,h
        
        containerforInputText.centerXAnchor.constraint(equalTo: inputcontext.centerXAnchor).isActive = true
        containerforInputText.topAnchor.constraint(equalTo: inputcontext.topAnchor, constant: 5).isActive = true
        containerforInputText.widthAnchor.constraint(equalToConstant: 270).isActive = true
        containerforInputText.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        

        inputcontext.addSubview(textfield)
        //x,y,w,h
        textfield.centerXAnchor.constraint(equalTo: containerforInputText.centerXAnchor).isActive = true
        textfield.centerYAnchor.constraint(equalTo: containerforInputText.centerYAnchor).isActive = true
        textfield.widthAnchor.constraint(equalToConstant: 250).isActive = true
        textfield.heightAnchor.constraint(equalToConstant: 30).isActive = true

        inputcontext.addSubview(sendbutton)

        // x,y,w,h
        sendbutton.leftAnchor.constraint(equalTo: containerforInputText.rightAnchor, constant: 12).isActive = true
        sendbutton.centerYAnchor.constraint(equalTo: inputcontext.centerYAnchor).isActive = true
        sendbutton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendbutton.heightAnchor.constraint(equalTo: containerforInputText.heightAnchor).isActive = true

        let straightline = UIView()
        straightline.translatesAutoresizingMaskIntoConstraints = false
        straightline.backgroundColor = UIColor().color(r: 220, g: 220, b: 220)
        view.addSubview(straightline)
        
        //x,y,width,height
        
        straightline.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        straightline.bottomAnchor.constraint(equalTo: inputcontext.topAnchor).isActive = true
        straightline.widthAnchor.constraint(equalTo: inputcontext.widthAnchor).isActive = true
        straightline.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
}


