//
//  FirebaseService.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 27/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import Firebase

class FirebaseService {
    
    static let shared = FirebaseService ()
    
    public static let ref = FIRDatabase.database().reference()
    let userIDFirebase = FIRAuth.auth()?.currentUser?.uid
    let userIdFacebook = FIRAuth.auth()?.currentUser?.providerData[0].uid
    
}
