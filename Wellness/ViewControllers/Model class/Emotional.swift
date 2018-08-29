//
//  Emotional.swift
//  Wellness
//
//  Created by think360 on 09/05/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class Emotional: NSObject,NSCoding {

    //MARK: Properties
     var EmotionalArray: NSMutableArray?
    
    
   // var MentalArray: NSMutableArray?
   // var PhysicalArray: NSMutableArray?
   // var SpiritualArray: NSMutableArray?
    
    //MARK: Initialization
    init(EmotionalArray: NSMutableArray) {
        // Initialize stored properties
        self.EmotionalArray = EmotionalArray
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(EmotionalArray, forKey: "EmotionalArray")
    }
    
    required init(coder decoder: NSCoder)
    {
        self.EmotionalArray = decoder.decodeObject(forKey: "EmotionalArray") as? NSMutableArray
    }
    
}
