//
//  File.swift
//  chat
//
//  Created by Fraol on 1/28/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit

//extension for picking the profile image for the user.

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @objc func HandlerFortheImageStorage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
       }
    
    // for editing and picking a image for the new user
    // when we are have selected an image 
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage]{
            imageview.image = editedImage as? UIImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage]{
            imageview.image = originalImage as? UIImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
