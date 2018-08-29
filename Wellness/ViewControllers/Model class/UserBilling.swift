//
//  UserBilling.swift
//  Wellness
//
//  Created by think360 on 14/05/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class UserBilling: NSObject,NSCoding
{
    //MARK: Properties
    var FirstName: String?
    var LastName: String?
    var CompanyName: String?
    var Country: String?
    var Street: String?
    var City: String?
    var Province: String?
    var Postal: String?
    var Phone: String?
    var EmailId: String?
    
    //MARK: Initialization
    init(FirstName: String, LastName: String,  CompanyName: String,  Country: String, Street: String,  City: String,  Province: String,  Postal: String,  Phone: String,  EmailId: String) {
        
        // Initialize stored properties
        self.FirstName = FirstName
        self.LastName = LastName
        self.CompanyName = CompanyName
        self.Country = Country
        self.Street = Street
        self.City = City
        self.Province = Province
        self.Postal = Postal
        self.Phone = Phone
        self.EmailId = EmailId
    }
    
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(FirstName, forKey: "FirstName")
        aCoder.encode(LastName, forKey: "LastName")
        aCoder.encode(CompanyName, forKey: "CompanyName")
        aCoder.encode(Country, forKey: "Country")
        aCoder.encode(Street, forKey: "Street")
        aCoder.encode(City, forKey: "City")
        aCoder.encode(Province, forKey: "Province")
        aCoder.encode(Postal, forKey: "Postal")
        aCoder.encode(Phone, forKey: "Phone")
        aCoder.encode(EmailId, forKey: "EmailId")
    }
    
    required init(coder decoder: NSCoder)
    {
        self.FirstName = decoder.decodeObject(forKey: "FirstName") as? String ?? ""
        self.LastName = decoder.decodeObject(forKey: "LastName") as? String ?? ""
        self.CompanyName = decoder.decodeObject(forKey: "CompanyName") as? String ?? ""
        self.Country = decoder.decodeObject(forKey: "Country") as? String ?? ""
        self.Street = decoder.decodeObject(forKey: "Street") as? String ?? ""
        self.City = decoder.decodeObject(forKey: "City") as? String ?? ""
        self.Province = decoder.decodeObject(forKey: "Province") as? String ?? ""
        self.Postal = decoder.decodeObject(forKey: "Postal") as? String ?? ""
        self.Phone = decoder.decodeObject(forKey: "Phone") as? String ?? ""
        self.EmailId = decoder.decodeObject(forKey: "EmailId") as? String ?? ""
    }
    
    
   
}
