//
//  PreviewViewController.swift
//  Wellness
//
//  Created by think360 on 13/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SecondDelegate  {
    
    @IBOutlet weak var BookingsTabl: UITableView!
    var Cell1:BookingCell!
    
    var imagesArray = NSMutableArray()
    var ProductDetail = NSDictionary()
    var strProductId = String()
    var strCouponId = String()
    var StrProductPrice = String()
    var StrProductDate = String()
    var StrProducttime = String()
    var StrProductMonthName = String()
    var StrProductMonthId = String()
    var StrProductYear = String()
    
    var StrProYearId = Int()
    var StrProMonthId = Int()
    
    var myArray = NSDictionary()
    var strUserID = String()

    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
        StrProductPrice = StrProductPrice.replacingOccurrences(of: ",", with: "")

        // Do any additional setup after loading the view.
        BookingsTabl.rowHeight = UITableViewAutomaticDimension
        BookingsTabl.estimatedRowHeight = 210
        BookingsTabl.tableFooterView = UIView()
        
        if StrProductMonthId == "1"
        {
            StrProductMonthName = "Jan"
        }
        else if StrProductMonthId == "2"
        {
            StrProductMonthName = "Feb"
        }
        else if StrProductMonthId == "3"
        {
            StrProductMonthName = "Mar"
        }
        else if StrProductMonthId == "4"
        {
            StrProductMonthName = "Apr"
        }
        else if StrProductMonthId == "5"
        {
            StrProductMonthName = "May"
        }
        else if StrProductMonthId == "6"
        {
            StrProductMonthName = "Jun"
        }
        else if StrProductMonthId == "7"
        {
            StrProductMonthName = "Jul"
        }
        else if StrProductMonthId == "8"
        {
            StrProductMonthName = "Aug"
        }
        else if StrProductMonthId == "9"
        {
            StrProductMonthName = "Sep"
        }
        else if StrProductMonthId == "10"
        {
            StrProductMonthName = "Oct"
        }
        else if StrProductMonthId == "11"
        {
            StrProductMonthName = "Nov"
        }
        else
        {
            StrProductMonthName = "Dec"
        }
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let data = UserDefaults.standard.object(forKey: "UserId") as? Data
            myArray = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSDictionary)!
            if let quantity = myArray.value(forKey: "user_id") as? NSNumber
            {
                strUserID = String(describing: quantity)
            }
            else if let quantity = myArray.value(forKey: "user_id") as? String
            {
                strUserID = quantity
            }
            print(strUserID)
        }
        
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
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK:  TableView Delegate Methods
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "BookingCell"
        Cell1 = tableView.dequeueReusableCell(withIdentifier: identifier) as? BookingCell
        if Cell1 == nil
        {
            tableView.register(UINib(nibName: "BookingCell", bundle: nil), forCellReuseIdentifier: identifier)
            Cell1 = tableView.dequeueReusableCell(withIdentifier: identifier) as? BookingCell
        }
        Cell1.selectionStyle = UITableViewCellSelectionStyle.none
        BookingsTabl.separatorStyle = .none
        BookingsTabl.separatorColor = UIColor.clear
        
        Cell1.BookingDate.layer.borderWidth = 2.0
        Cell1.BookingDate.layer.borderColor = #colorLiteral(red: 0.475771904, green: 0.3657561243, blue: 0.6547890902, alpha: 1)
        
        Cell1.BookingTime.layer.borderWidth = 2.0
        Cell1.BookingTime.layer.borderColor = #colorLiteral(red: 0.475771904, green: 0.3657561243, blue: 0.6547890902, alpha: 1)
        
        let imageURL: String = self.imagesArray.object(at: indexPath.row) as? String ?? ""
        if imageURL == "" || imageURL == "0"
        {
            Cell1.BookingImage.image = UIImage(named: "Placeholder")
        }
        else
        {
            let url = NSURL(string:imageURL)
            Cell1.BookingImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
        }
        
        Cell1.BookingStoreName.text = ProductDetail.object(forKey: "name") as? String ?? ""
        Cell1.BookingName.text = ProductDetail.object(forKey: "vandor") as? String ?? ""
        
        if StrProductDate == "1"
        {
            Cell1.BookingDate.text = StrProductDate+"st"+" "+StrProductMonthName+" "+StrProductYear
        }
        else if StrProductDate == "2"
        {
            Cell1.BookingDate.text = StrProductDate+"nd"+" "+StrProductMonthName+" "+StrProductYear
        }
        else if StrProductDate == "3"
        {
            Cell1.BookingDate.text = StrProductDate+"rd"+" "+StrProductMonthName+" "+StrProductYear
        }
        else
        {
            Cell1.BookingDate.text = StrProductDate+"th"+" "+StrProductMonthName+" "+StrProductYear
        }
       
        Cell1.BookingTime.text = StrProducttime
        Cell1.BookingPrice.text = String(format:"$ %@", StrProductPrice)
        
        Cell1.BookingDeleteButt.isHidden = true
        Cell1.BookingDeleteButt.tag = indexPath.row
        Cell1.BookingDeleteButt.addTarget(self, action: #selector(self.BookingDeleteClicked), for: .touchUpInside)
        
        return Cell1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
    }
    
    //MARK: Booking Delete Clicked
    
    @IBAction func BookingDeleteClicked(_ sender: UIButton)
    {
        
    }
    
    //MARK: Confirm Butt Clicked
    
    @IBAction func ConfirmButtClicked(_ sender: UIButton)
    {
        if StrProductPrice == "0" || StrProductPrice == "0.0" || StrProductPrice == "0.00"
        {
            let strInvoicenum = ""
            let straddress = ""
            let strFname = ""
            let strLname = ""
            let strStatus = "approved"
            
             self.BookingAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"post_booking") , params: "product_id=\(self.strProductId)&booking_year=\(self.StrProductYear)&booking_month=\(self.StrProductMonthId)&booking_day=\(self.StrProductDate)&booking_time=\(self.StrProducttime)&coupon_id=\(self.strCouponId)&user_id=\(self.strUserID)&txn_id=\(strInvoicenum)&paypal_address=\(straddress)&paypal_first_name=\(strFname)&paypal_last_name=\(strLname)&paypal_status=\(strStatus)")
        }
        else
        {
            
              self.BookingAvailableAPIMethod(baseURL: String(format:"%@%@?product_id=%@&year=%d&month=%d&day=%@&time=%@",Constants.mainURL,"check_booking_availabilty",strProductId,StrProYearId,StrProMonthId,StrProductDate,StrProducttime))
            
           
        }
    }
    
    @objc private   func BookingAvailableAPIMethod (baseURL:String)
    {
        print(baseURL)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSelectViewController") as? PaymentSelectViewController
                    myVC?.ProductDetail = self.ProductDetail
                    myVC?.strProductId = self.strProductId
                    myVC?.strCouponId = self.strCouponId
                    myVC?.StrProductPrice = self.StrProductPrice
                    myVC?.StrProductDate = self.StrProductDate
                    myVC?.StrProducttime = self.StrProducttime
                    myVC?.StrProductMonthName = self.StrProductMonthName
                    myVC?.StrProductYear = self.StrProductYear
                    myVC?.StrProductMonthId = self.StrProductMonthId
                    myVC?.StrProYearId = self.StrProYearId
                    myVC?.StrProMonthId = self.StrProMonthId
                    self.navigationController?.pushViewController(myVC!, animated: true)
                   
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                    
                }
            }
            
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    
    @objc private   func BookingAPIMethod (baseURL:String , params: String)
    {
        print(baseURL)
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SuccessPaymentViewController") as? SuccessPaymentViewController
                    if let quantity = (responceDic.value(forKey: "data") as? NSDictionary)?.value(forKey: "order_id") as? NSNumber
                    {
                        myVC?.StrOrderId = String(describing: quantity)
                    }
                    else if let quantity = (responceDic.value(forKey: "data") as? NSDictionary)?.value(forKey: "order_id") as? String
                    {
                        myVC?.StrOrderId = quantity
                    }
                    self.navigationController?.pushViewController(myVC!, animated: true)
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                }
            }
            
        }) { (error) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
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
