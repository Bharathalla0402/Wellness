//
//  UserBooking.swift
//  Wellness
//
//  Created by think360 on 15/05/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class UserBooking: NSObject
{
    //MARK: Properties
    var ProductId: String?
    var ProductStoreName: String?
    var ProductVendorName: String?
    var ProductPrice: String?
    var ProductYear: String?
    var ProductMonth: String?
    var ProductDay: String?
    var ProductTime: String?
    
    
    //MARK: Initialization
    init(ProductId: String, ProductStoreName: String,  ProductVendorName: String,  ProductPrice: String, ProductYear: String,  ProductMonth: String,  ProductDay: String,  ProductTime: String) {
        
        // Initialize stored properties
        self.ProductId = ProductId
        self.ProductStoreName = ProductStoreName
        self.ProductVendorName = ProductVendorName
        self.ProductPrice = ProductPrice
        self.ProductYear = ProductYear
        self.ProductMonth = ProductMonth
        self.ProductDay = ProductDay
        self.ProductTime = ProductTime
    }
    
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(ProductId, forKey: "ProductId")
        aCoder.encode(ProductStoreName, forKey: "ProductStoreName")
        aCoder.encode(ProductVendorName, forKey: "ProductVendorName")
        aCoder.encode(ProductPrice, forKey: "ProductPrice")
        aCoder.encode(ProductYear, forKey: "ProductYear")
        aCoder.encode(ProductMonth, forKey: "ProductMonth")
        aCoder.encode(ProductDay, forKey: "ProductDay")
        aCoder.encode(ProductTime, forKey: "ProductTime")
    }
    
    required init(coder decoder: NSCoder)
    {
        self.ProductId = decoder.decodeObject(forKey: "ProductId") as? String ?? ""
        self.ProductStoreName = decoder.decodeObject(forKey: "ProductStoreName") as? String ?? ""
        self.ProductVendorName = decoder.decodeObject(forKey: "ProductVendorName") as? String ?? ""
        self.ProductPrice = decoder.decodeObject(forKey: "ProductPrice") as? String ?? ""
        self.ProductYear = decoder.decodeObject(forKey: "ProductYear") as? String ?? ""
        self.ProductMonth = decoder.decodeObject(forKey: "ProductMonth") as? String ?? ""
        self.ProductDay = decoder.decodeObject(forKey: "ProductDay") as? String ?? ""
        self.ProductTime = decoder.decodeObject(forKey: "ProductTime") as? String ?? ""
    }
}
