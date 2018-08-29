//
//  Category.swift
//  Wellness
//
//  Created by think360 on 09/05/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class Category: NSObject,NSCoding
{
    //MARK: Properties
    var EmotionalId: String?
    var MentalId: String?
    var PhysicalId: String?
    var SpiritualId: String?
    
    var EmotionalName: String?
    var MentalName: String?
    var PhysicalName: String?
    var SpiritualName: String?
   
    
    //MARK: Initialization
    init(EmotionalId: String, MentalId: String,  PhysicalId: String,  SpiritualId: String, EmotionalName: String, MentalName: String,  PhysicalName: String,  SpiritualName: String)
    {
        // Initialize stored properties
        self.EmotionalId = EmotionalId
        self.MentalId = MentalId
        self.PhysicalId = PhysicalId
        self.SpiritualId = SpiritualId
        self.EmotionalName = EmotionalName
        self.MentalName = MentalName
        self.PhysicalName = PhysicalName
        self.SpiritualName = SpiritualName
    }
    
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(EmotionalId, forKey: "EmotionalId")
        aCoder.encode(MentalId, forKey: "MentalId")
        aCoder.encode(PhysicalId, forKey: "PhysicalId")
        aCoder.encode(SpiritualId, forKey: "SpiritualId")
        aCoder.encode(EmotionalName, forKey: "EmotionalName")
        aCoder.encode(MentalName, forKey: "MentalName")
        aCoder.encode(PhysicalName, forKey: "PhysicalName")
        aCoder.encode(SpiritualName, forKey: "SpiritualName")
    }
    
    required init(coder decoder: NSCoder)
    {
        self.EmotionalId = decoder.decodeObject(forKey: "EmotionalId") as? String ?? ""
        self.MentalId = decoder.decodeObject(forKey: "MentalId") as? String ?? ""
        self.PhysicalId = decoder.decodeObject(forKey: "PhysicalId") as? String ?? ""
        self.SpiritualId = decoder.decodeObject(forKey: "SpiritualId") as? String ?? ""
        self.EmotionalName = decoder.decodeObject(forKey: "EmotionalName") as? String ?? ""
        self.MentalName = decoder.decodeObject(forKey: "MentalName") as? String ?? ""
        self.PhysicalName = decoder.decodeObject(forKey: "PhysicalName") as? String ?? ""
        self.SpiritualName = decoder.decodeObject(forKey: "SpiritualName") as? String ?? ""
    }

}
