//
//  message.swift
//  chat
//
//  Created by Fraol on 3/11/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit
import Firebase
class message: NSObject {
    @objc var fromId: String?
    @objc var text: String?
    @objc var toId: String?
    @objc var TimeStamp: NSNumber?
    func chatpartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
