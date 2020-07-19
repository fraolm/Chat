//
//  ChatMessageCell.swift
//  chat
//
//  Created by Fraol on 6/22/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    let textview: UITextView = {
        let textv = UITextView()
        textv.text = "hey hey hey hey hey"
        textv.font = UIFont.boldSystemFont(ofSize: 16)
        textv.isEditable = false
        //textv.allowsEditingTextAttributes = false
        textv.backgroundColor = .clear
        textv.translatesAutoresizingMaskIntoConstraints = false
        textv.textColor = .white
        return textv
    }()
    let bubbleView: UIView={
        let bubblev = UIView()
        bubblev.backgroundColor = .black
        bubblev.layer.cornerRadius = 16
        bubblev.translatesAutoresizingMaskIntoConstraints = false
        return bubblev
    }()
    let profileImage: UIImageView={
       let imageView = UIImageView()
        imageView.image = UIImage(named: "ContactImage")
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var bubbleViewWidthConstraints: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var textfieldHeight: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .yellow
        addSubview(bubbleView)
        addSubview(textview)
        addSubview(profileImage)
        
        //constraints x,y,w,h
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        //constraints x,y,h,w
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8)
        bubbleViewWidthConstraints = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewWidthConstraints?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //constraints
        
        textview.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        
        textview.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        
        textfieldHeight = textview.heightAnchor.constraint(equalTo: self.heightAnchor)
        textfieldHeight?.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
