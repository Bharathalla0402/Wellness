//
//  Place.swift
//  Wellness
//
//  Created by think360 on 09/05/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class Place: NSObject,NSCoding
{
    //MARK: Properties
    var name: String?
    var Address: String?
    var Currentlat: Double?
    var CurrentLong: Double?
   
    //MARK: Initialization
    init(name: String, Address: String, Currentlat: Double, CurrentLong: Double)
    {
        // Initialize stored properties
        self.name = name
        self.Address = Address
        self.Currentlat = Currentlat
        self.CurrentLong = CurrentLong
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(Address, forKey: "Address")
        aCoder.encode(Currentlat, forKey: "Currentlat")
        aCoder.encode(CurrentLong, forKey: "CurrentLong")
    }
    
    required init(coder decoder: NSCoder)
    {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.Address = decoder.decodeObject(forKey: "Address") as? String ?? ""
        self.Currentlat = decoder.decodeObject(forKey: "Currentlat") as? Double ?? 0.0
        self.CurrentLong = decoder.decodeObject(forKey: "CurrentLong") as? Double ?? 0.0
    }
}
