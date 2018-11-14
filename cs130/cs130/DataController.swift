//
//  DataController.swift
//  cs130
//
//  Created by Evan Kim on 11/13/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

//Class for read/write of data
import Foundation
import UIKit
import FirebaseDatabase

class DataController {
    var ref: DatabaseReference!
    
    init(){
        ref = Database.database().reference()
    }
}
