//
//  OrderDetailViewController.swift
//  Wellness
//
//  Created by think360 on 21/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit


class OrderDetailCell: UITableViewCell
{
    @IBOutlet var ProductStoreImage: UIImageView!
    @IBOutlet var ProductStoreName: UILabel!
    @IBOutlet var ProductSellerName: UILabel!
    @IBOutlet var ProductPrice: UILabel!
}



class OrderDetailViewController: UIViewController,SecondDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var OrderDate: UILabel!
    @IBOutlet weak var OrderNo: UILabel!
    @IBOutlet weak var OrderTotal: UILabel!
    
    @IBOutlet var OrderTabl: UITableView!
    @IBOutlet var OrderTablHeight: NSLayoutConstraint!
    @IBOutlet weak var ProductStoreImage: UIImageView!
    @IBOutlet weak var ProductStoreName: UILabel!
    @IBOutlet weak var ProductSellerName: UILabel!
    @IBOutlet weak var ProductPrice: UILabel!
    
    @IBOutlet weak var PaymentMethod: UILabel!
    @IBOutlet weak var PaymentAddress: UILabel!
    
    @IBOutlet weak var ProductTotal: UILabel!
    @IBOutlet weak var CouponDiscount: UILabel!
    @IBOutlet weak var SubTotal: UILabel!
    @IBOutlet weak var HstTax: UILabel!
    @IBOutlet weak var TotalPayable: UILabel!

    var Cell:OrderDetailCell!
    
    
    var OrderDetailDic = NSDictionary()
    var myArray = NSDictionary()
    var strUserID = String()
    
    var strBack = String()
    
    var classObject = MultipartViewController()
    
    var OrderlistArray = NSMutableArray()
    
    var Devval = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ( UIDevice.current.model.range(of: "iPad") != nil)
        {
            Devval = 156.0
        }
        else
        {
            Devval = 126.0
        }
        
        classObject.delegate = self
        
        let str1 = "$ "
        let str18 = OrderDetailDic.object(forKey: "order_total") as? String ?? ""
        
        OrderDate.text =  OrderDetailDic.object(forKey: "order_date") as? String ?? ""
        OrderNo.text =  OrderDetailDic.object(forKey: "order_id") as? String ?? ""
        OrderTotal.text =  str1+str18
        
        OrderlistArray = (OrderDetailDic.object(forKey: "product") as? NSMutableArray)!
        
        var str6 = String()
        var str5 = String()
        
        var ProTotal:Float = 0.0
        
        var Totalval:CGFloat = 0
        var strName = String()
        var sellerName = String()
        var proPrice = String()
        for i in 0..<OrderlistArray.count
        {
            var height = CGFloat()
            var height2 = CGFloat()
            var height3 = CGFloat()
            
            let strPSname = ((OrderDetailDic.object(forKey: "product") as? NSMutableArray)?.object(at: i) as? NSDictionary)?.object(forKey: "name") as? String ?? ""
            let strPS = ((OrderDetailDic.object(forKey: "product") as? NSMutableArray)?.object(at: i) as? NSDictionary)?.object(forKey: "category") as? String ?? ""
            let strps1 = " ( "
            let strps2 = " )"
            strName = strPSname + strps1 + strPS + strps2
            
           
            let font =  UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
            let font2 =  UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightSemibold)
            height = heightForView(text: strName, font: font, width: self.view.frame.size.width-Devval)
            
            
            
            
            
            let str3 = ((OrderDetailDic.object(forKey: "product") as? NSMutableArray)?.object(at: i) as? NSDictionary)?.object(forKey: "vandor") as? String ?? ""
            let str4 = " | "
           
            if let quantity = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "city") as? NSNumber
            {
                str5 = String(describing: quantity)
            }
            else if let quantity = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "city") as? String
            {
                str5 = quantity
            }
            str6 = "\n"
            
            var str7 = String()
            if let quantity = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "phone") as? NSNumber
            {
                str7 = String(describing: quantity)
            }
            else if let quantity = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "phone") as? String
            {
                str7 = quantity
            }
            
            var str8 = String()
            if let quantity = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "email") as? NSNumber
            {
                str8 = String(describing: quantity)
            }
            else if let quantity = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "email") as? String
            {
                str8 = quantity
            }
            
            if str3 == ""
            {
                if str7 == ""
                {
                    sellerName = str5+str6+str6+str8+str6
                    height2 = heightForView(text: sellerName, font: font2, width: self.view.frame.size.width-Devval)
                }
                else
                {
                    sellerName = str5+str6+str6+str7+str6+str6+str8+str6
                    height2 = heightForView(text: sellerName, font: font2, width: self.view.frame.size.width-Devval)
                }
            }
            else
            {
                if str7 == ""
                {
                    sellerName = str3+str4+str5+str6+str6+str8+str6
                    height2 = heightForView(text: sellerName, font: font2, width: self.view.frame.size.width-Devval)
                }
                else
                {
                    sellerName = str3+str4+str5+str6+str6+str7+str6+str6+str8+str6
                    height2 = heightForView(text: sellerName, font: font2, width: self.view.frame.size.width-Devval)
                }
            }
            
            
            
            
            
            var str2 = String()
            if let quantity = ((OrderDetailDic.object(forKey: "product") as? NSMutableArray)?.object(at: i) as? NSDictionary)?.object(forKey: "price") as? NSNumber
            {
                str2 = String(describing: quantity)
            }
            else if let quantity = ((OrderDetailDic.object(forKey: "product") as? NSMutableArray)?.object(at: i) as? NSDictionary)?.object(forKey: "price") as? String
            {
                str2 = quantity
            }
            
            str2 = str2.replacingOccurrences(of: ",", with: "")
            
            ProTotal = ProTotal + Float(str2)!
           
            print(ProTotal)
           
            
            proPrice = str1+str2
            height3 = heightForView(text: proPrice, font: font, width: self.view.frame.size.width-Devval)
            
            
            Totalval = Totalval+height+height2+height3+61
            
        }
        
        OrderTablHeight.constant = Totalval
        
        OrderTabl.rowHeight = UITableViewAutomaticDimension
        OrderTabl.estimatedRowHeight = 250
        OrderTabl.tableFooterView = UIView()
        
//        let imageURL = ((OrderDetailDic.object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "image") as? String ?? ""
//        if imageURL == "" || imageURL == "0"
//        {
//            ProductStoreImage.image = UIImage(named: "Placeholder")
//        }
//        else
//        {
//            let url = NSURL(string:imageURL)
//            ProductStoreImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
//        }
//
       
        
       
        
        
        
      
        
        PaymentMethod.text =  OrderDetailDic.object(forKey: "payment_method") as? String ?? ""
        
        let str9 = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "address_1") as? String ?? ""
        let str10 = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "address_2") as? String ?? ""
        let str11 = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "state") as? String ?? ""
        let str12 = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "postcode") as? String ?? ""
        let str13 = " ,"
        
        if str11 == "" && str12 == ""
        {
            PaymentAddress.text = str9+str6+str10+str6+str11+str5+str12
        }
        else
        {
            if str11 == ""
            {
                if str12 == ""
                {
                    PaymentAddress.text = str9+str6+str10+str6+str11+str5+str12
                }
                else
                {
                    PaymentAddress.text = str9+str6+str10+str6+str11+str5+str13+str12
                }
            }
            else
            {
                if str12 == ""
                {
                    PaymentAddress.text = str9+str6+str10+str6+str11+str5+str12
                }
                else
                {
                    PaymentAddress.text = str9+str6+str10+str6+str11+str13+str5+str13+str12
                }
            }
            
        }
        
       
       
        
        var str16 = String()
        if let quantity = OrderDetailDic.object(forKey: "order_subtotal") as? NSNumber
        {
            str16 = String(describing: quantity)
        }
        else if let quantity = OrderDetailDic.object(forKey: "order_subtotal") as? String
        {
            str16 = quantity
        }
        //let str14 = OrderDetailDic.object(forKey: "order_total") as? String ?? ""
        
        var str15 = "0"
        if let quantity = OrderDetailDic.object(forKey: "order_discount") as? NSNumber
        {
            str15 = String(describing: quantity)
        }
        else if let quantity = OrderDetailDic.object(forKey: "order_discount") as? String
        {
            str15 = quantity
        }
        
        
        var str17 = String()
        if let quantity = OrderDetailDic.object(forKey: "order_tax") as? NSNumber
        {
            str17 = String(describing: quantity)
        }
        else if let quantity = OrderDetailDic.object(forKey: "order_tax") as? String
        {
            str17 = quantity
        }
       
       
        
        let stringval = String(format: "%.2f", ProTotal)
        ProductTotal.text = str1+stringval
        CouponDiscount.text = str1+str15
        SubTotal.text = str1+str16
        HstTax.text = str1+str17
        TotalPayable.text = str1+str18
        
        // Do any additional setup after loading the view.
    }
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    
    
    
    func responsewithToken2()
    {
        AFWrapperClass.svprogressHudDismiss(view: self)
        UserDefaults.standard.removeObject(forKey: "UserLogin")
        UserDefaults.standard.removeObject(forKey: "UserId")
        UserDefaults.standard.removeObject(forKey: "NewPlace")
        UserDefaults.standard.removeObject(forKey: "UserProfile")
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        myVC?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    func responsewithToken3()
    {
        AFWrapperClass.svprogressHudDismiss(view: self)
    }
    
    // MARK:  View Will Appear
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        classObject.checkLoginStatus()
    }
    
    
    
    // MARK:  Back Butt Clicked
    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        if strBack == "1"
        {
            UserDefaults.standard.setValue("Yes", forKey: "front")
            _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    // MARK:  TableView Delegate Methods
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return OrderlistArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "OrderDetailCell"
        Cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? OrderDetailCell
        if Cell == nil
        {
            tableView.register(UINib(nibName: "OrderDetailCell", bundle: nil), forCellReuseIdentifier: identifier)
            Cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? OrderDetailCell
        }
        Cell.selectionStyle = UITableViewCellSelectionStyle.none
        OrderTabl.separatorStyle = .none
        OrderTabl.separatorColor = UIColor.clear
        
        
        let imageURL = ((OrderDetailDic.object(forKey: "product") as? NSMutableArray)?.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "image") as? String ?? ""
        if imageURL == "" || imageURL == "0"
        {
            Cell.ProductStoreImage.image = UIImage(named: "Placeholder")
        }
        else
        {
            let url = NSURL(string:imageURL)
            Cell.ProductStoreImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
        }
        
        if ( UIDevice.current.model.range(of: "iPad") != nil)
        {
            Cell.ProductStoreImage.layer.cornerRadius = 65
            Cell.ProductStoreImage.clipsToBounds = true
        }
        else
        {
            Cell.ProductStoreImage.layer.cornerRadius = 50
            Cell.ProductStoreImage.clipsToBounds = true
        }
        
        
        
        let strPSname = ((OrderDetailDic.object(forKey: "product") as? NSMutableArray)?.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "name") as? String ?? ""
        let strPS = ((OrderDetailDic.object(forKey: "product") as? NSMutableArray)?.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "category") as? String ?? ""
        let strps1 = " ( "
        let strps2 = " )"
        Cell.ProductStoreName.text = strPSname + strps1 + strPS + strps2
        
        
        
        
        
        let str3 = ((OrderDetailDic.object(forKey: "product") as? NSMutableArray)?.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "vandor") as? String ?? ""
        let str4 = " | "
        var str5 = String()
        var str6 = String()
        if let quantity = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "city") as? NSNumber
        {
            str5 = String(describing: quantity)
        }
        else if let quantity = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "city") as? String
        {
            str5 = quantity
        }
        str6 = "\n"
        
        var str7 = String()
        if let quantity = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "phone") as? NSNumber
        {
            str7 = String(describing: quantity)
        }
        else if let quantity = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "phone") as? String
        {
            str7 = quantity
        }
        
        var str8 = String()
        if let quantity = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "email") as? NSNumber
        {
            str8 = String(describing: quantity)
        }
        else if let quantity = (OrderDetailDic.object(forKey: "order_address") as? NSDictionary)?.object(forKey: "email") as? String
        {
            str8 = quantity
        }
        
        if str3 == ""
        {
            if str7 == ""
            {
                Cell.ProductSellerName.text = str5+str6+str6+str8+str6
            }
            else
            {
                Cell.ProductSellerName.text = str5+str6+str6+str7+str6+str6+str8+str6
            }
        }
        else
        {
            if str7 == ""
            {
                Cell.ProductSellerName.text = str3+str4+str5+str6+str6+str8+str6
            }
            else
            {
                Cell.ProductSellerName.text = str3+str4+str5+str6+str6+str7+str6+str6+str8+str6
            }
        }
        
        
        
        
        let str1 = "$ "
        var str2 = String()
        if let quantity = ((OrderDetailDic.object(forKey: "product") as? NSMutableArray)?.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "price") as? NSNumber
        {
            str2 = String(describing: quantity)
        }
        else if let quantity = ((OrderDetailDic.object(forKey: "product") as? NSMutableArray)?.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "price") as? String
        {
            str2 = quantity
        }
        
        Cell.ProductPrice.text = str1+str2
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
