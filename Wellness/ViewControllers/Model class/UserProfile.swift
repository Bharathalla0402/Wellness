//
//  UserProfile.swift
//  Wellness
//
//  Created by think360 on 11/05/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class UserProfile: NSObject,NSCoding
{
    //MARK: Properties
    var FirstName: String?
    var LastName: String?
    var EmailId: String?
    var Phone: String?
    var ImageUrl: String?
    
    
    //MARK: Initialization
    init(FirstName: String, LastName: String,  EmailId: String,  Phone: String, ImageUrl: String) {
        
        // Initialize stored properties
        self.FirstName = FirstName
        self.LastName = LastName
        self.EmailId = EmailId
        self.Phone = Phone
        self.ImageUrl = ImageUrl
    }
    
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(FirstName, forKey: "FirstName")
        aCoder.encode(LastName, forKey: "LastName")
        aCoder.encode(EmailId, forKey: "EmailId")
        aCoder.encode(Phone, forKey: "Phone")
        aCoder.encode(ImageUrl, forKey: "ImageUrl")
    }
    
    required init(coder decoder: NSCoder)
    {
        self.FirstName = decoder.decodeObject(forKey: "FirstName") as? String ?? ""
        self.LastName = decoder.decodeObject(forKey: "LastName") as? String ?? ""
        self.EmailId = decoder.decodeObject(forKey: "EmailId") as? String ?? ""
        self.Phone = decoder.decodeObject(forKey: "Phone") as? String ?? ""
        self.ImageUrl = decoder.decodeObject(forKey: "ImageUrl") as? String ?? ""
    }
}
