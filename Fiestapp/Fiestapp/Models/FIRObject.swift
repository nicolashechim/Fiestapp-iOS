//
//  FIRObject.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 27/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import Foundation
import Firebase

class FIRObject : NSObject {
    
    let snapshot: FIRDataSnapshot
    var ref: FIRDatabaseReference { return snapshot.ref }
    
    init(snapshot: FIRDataSnapshot) {
        
        self.snapshot = snapshot
        
        super.init()
        
        for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
            if responds(to: Selector(child.key)) {
                setValue(child.value, forKey: child.key)
            }
            else{
                
                    if child.key != "Funcionalidades" {
                        let newobj = child.children
                        while let rest1 = newobj.nextObject() as? FIRDataSnapshot {
                            setValue(rest1.value ?? nil, forKey: child.key + "["+rest1.key+"]")
                    }
                }
            }
        }
    }
}
