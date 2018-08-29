//
//  BookingsViewController.swift
//  Wellness
//
//  Created by think360 on 06/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class BookingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SecondDelegate {

     @IBOutlet weak var TopViewHeight: NSLayoutConstraint!
    @IBOutlet weak var NotificationCount: UILabel!
    @IBOutlet weak var NotificationButt: UIButton!
    
    @IBOutlet weak var BookingsSegCtrl: UISegmentedControl!
    @IBOutlet weak var BookingsTabl: UITableView!
    
    var Cell1:BookingCell!
    var Cell2:PastBookingCell!
    var Cell3:PastBookingCell!
    
    var Stringlab = UILabel()
    var myArray = NSDictionary()
    var strUserID = String()
    var OrderId = String()
    
    var strProductId = String()

    var strPage1 = String()
    var strPage2 = String()
    var strPage3 = String()
    
    var BookingsArray = NSMutableArray()
    var PastBookingsArray = NSMutableArray()
    var CancelledBookingsArray = NSMutableArray()
    
    var strSegment = String()
    
    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.Notificationmethod), name: NSNotification.Name(rawValue: "Notification"), object: nil)
        
        Stringlab.frame = CGRect(x:self.view.frame.size.width/2-100, y:self.view.frame.size.height/2-10, width:200, height:20)
        Stringlab.backgroundColor = UIColor.clear
        Stringlab.text="No List"
        Stringlab.font =  UIFont(name:"Helvetica-Bold", size: 16)
        Stringlab.textColor=UIColor.black
        Stringlab.textAlignment = .center
        Stringlab.isHidden=true;
        self.view.addSubview(Stringlab)
        
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        
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
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                TopViewHeight.constant = 23
            default:
                TopViewHeight.constant = 0
            }
        }

        // Do any additional setup after loading the view.
        
        NotificationCount.layer.cornerRadius = 12.5
        NotificationCount.clipsToBounds = true
        
        strSegment = "1"
        BookingsTabl.tag = 1
        BookingsTabl.rowHeight = UITableViewAutomaticDimension
        BookingsTabl.estimatedRowHeight = 210
        BookingsTabl.tableFooterView = UIView()
    }
    
    func Notificationmethod()
    {
        if UserDefaults.standard.object(forKey: "NCount") != nil
        {
            let data = UserDefaults.standard.object(forKey: "NCount") as! NSNumber
            let orderInt  = data.intValue
            NotificationCount.text = String(describing: orderInt)
        }
    }
    
    
    // MARK:  Notification Butt Clicked
    
    @IBAction func NotificationButtClicked(_ sender: Any)
    {
        var localTimeZoneName: String { return TimeZone.current.identifier }
         self.NotificationsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&time_zone=%@",Constants.mainURL,"user_notification",strUserID,localTimeZoneName))
    }
    
    @objc private   func NotificationsAPIMethod (baseURL:String)
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
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationListViewController") as? NotificationListViewController
                    myVC?.NotificatonListArray = ((responceDic.object(forKey: "data") as! NSDictionary).value(forKey: "notification") as? NSMutableArray)!
                    if let quantity = (responceDic.object(forKey: "data") as! NSDictionary).value(forKey: "nextPage") as? NSNumber
                    {
                        myVC?.strpage = String(describing: quantity)
                    }
                    else if let quantity = (responceDic.object(forKey: "data") as! NSDictionary).value(forKey: "nextPage") as? String
                    {
                        myVC?.strpage = quantity
                    }
                    myVC?.hidesBottomBarWhenPushed = true
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
    
    func responsewithToken2()
    {
       // AFWrapperClass.svprogressHudDismiss(view: self)
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
       // AFWrapperClass.svprogressHudDismiss(view: self)
    }
    
    // MARK:  View Will Appear
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
       
        
        if UserDefaults.standard.object(forKey: "front") != nil
        {
            UserDefaults.standard.removeObject(forKey: "front")
        }
        else
        {
             self.classObject.checkLoginStatus()
            
            strSegment = "1"
            BookingsSegCtrl.selectedSegmentIndex = 0
            BookingsTabl.tag = 1
            self.BookingsItemList()
        }
        
     //   AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
      
    }
    
    func BookingsItemList ()
    {
         self.UserBookingsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&order_type=1",Constants.mainURL,"user_order",strUserID))
        // self.UserPastBookingsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&order_type=2",Constants.mainURL,"user_order",strUserID))
      //   self.UserCancelledBookingsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&order_type=3",Constants.mainURL,"user_order",strUserID))
    }
    
    
    // MARK:  User Booking Api
    
    @objc private   func UserBookingsAPIMethod (baseURL:String)
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
                    self.BookingsArray.removeAllObjects()
                    self.BookingsArray = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "order") as? NSMutableArray)!
                  
                    if let quantity = (responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "notificationCount") as? NSNumber
                    {
                        self.NotificationCount.text = String(describing: quantity)
                    }
                    else if let quantity = (responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "notificationCount") as? String
                    {
                        self.NotificationCount.text = quantity
                    }
                    
                    if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? NSNumber
                    {
                        self.strPage1 = String(describing: quantity)
                    }
                    else if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? String
                    {
                        self.strPage1 = quantity
                    }
                    
                    if self.BookingsArray.count == 0
                    {
                        self.Stringlab.text="No List"
                        self.Stringlab.isHidden=false
                        self.BookingsTabl.isHidden=true
                    }
                    else
                    {
                        self.Stringlab.isHidden=true
                        self.BookingsTabl.isHidden=false
                    }
                    
                     self.BookingsTabl.reloadData()
                    
                     // self.classObject.checkLoginStatus()
                }
                else
                {
                    self.Stringlab.text="No List"
                    self.Stringlab.isHidden=false
                    self.BookingsTabl.isHidden=true
                    
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                    
                 //   AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                 //   self.classObject.checkLoginStatus()
                }
            }
            
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    
    // MARK:  User Bookings API
    
    @objc private   func UserPastBookingsAPIMethod (baseURL:String)
    {
       AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.PastBookingsArray.removeAllObjects()
                    self.PastBookingsArray = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "order") as? NSMutableArray)!
                    
                    if let quantity = (responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "notificationCount") as? NSNumber
                    {
                        self.NotificationCount.text = String(describing: quantity)
                    }
                    else if let quantity = (responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "notificationCount") as? String
                    {
                        self.NotificationCount.text = quantity
                    }
                    
                    
                    if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? NSNumber
                    {
                        self.strPage2 = String(describing: quantity)
                    }
                    else if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? String
                    {
                        self.strPage2 = quantity
                    }
                    
                    if self.PastBookingsArray.count == 0
                    {
                        self.Stringlab.text="No List"
                        self.Stringlab.isHidden=false
                        self.BookingsTabl.isHidden=true
                    }
                    else
                    {
                        self.Stringlab.isHidden=true
                        self.BookingsTabl.isHidden=false
                    }
                    
                     self.BookingsTabl.reloadData()
                }
                else
                {
                    self.Stringlab.text="No List"
                    self.Stringlab.isHidden=false
                    self.BookingsTabl.isHidden=true
                    
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
    
    
     // MARK:  User Cancelled API
    
    @objc private   func UserCancelledBookingsAPIMethod (baseURL:String)
    {
       AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.CancelledBookingsArray.removeAllObjects()
                    self.CancelledBookingsArray = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "order") as? NSMutableArray)!
                    
                    if let quantity = (responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "notificationCount") as? NSNumber
                    {
                        self.NotificationCount.text = String(describing: quantity)
                    }
                    else if let quantity = (responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "notificationCount") as? String
                    {
                        self.NotificationCount.text = quantity
                    }
                    
                    
                    
                    if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? NSNumber
                    {
                        self.strPage3 = String(describing: quantity)
                    }
                    else if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? String
                    {
                        self.strPage3 = quantity
                    }
                    
                    if self.CancelledBookingsArray.count == 0
                    {
                        self.Stringlab.text="No List"
                        self.Stringlab.isHidden=false
                        self.BookingsTabl.isHidden=true
                    }
                    else
                    {
                        self.Stringlab.isHidden=true
                        self.BookingsTabl.isHidden=false
                    }
                    
                    self.BookingsTabl.reloadData()
                }
                else
                {
                    self.Stringlab.text="No List"
                    self.Stringlab.isHidden=false
                    self.BookingsTabl.isHidden=true
                    
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
    
    
     // MARK:  Booking Segment Changed
    
    @IBAction func BookSegmentChanged(_ sender: UISegmentedControl)
    {
        if BookingsSegCtrl.selectedSegmentIndex == 0
        {
            strSegment = "1"
            BookingsSegCtrl.selectedSegmentIndex = 0
            BookingsTabl.tag = 1
            self.UserBookingsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&order_type=1",Constants.mainURL,"user_order",strUserID))
        }
        else if BookingsSegCtrl.selectedSegmentIndex == 1
        {
            strSegment = "2"
            BookingsSegCtrl.selectedSegmentIndex = 1
            BookingsTabl.tag = 2
            self.UserPastBookingsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&order_type=2",Constants.mainURL,"user_order",strUserID))
        
           // self.UserPastBookingsAPIMethod(baseURL: String(format:"%@%@?user_id=45&order_type=2",Constants.mainURL,"user_order"))
        }
        else
        {
            strSegment = "3"
            BookingsSegCtrl.selectedSegmentIndex = 2
            BookingsTabl.tag = 3
            self.UserCancelledBookingsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&order_type=3",Constants.mainURL,"user_order",strUserID))
        }
    }
    
    // MARK:  TableView Delegate Methods
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 1
        {
            return BookingsArray.count
        }
        else if tableView.tag == 2
        {
            return PastBookingsArray.count
        }
        else
        {
            return CancelledBookingsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag == 2
        {
            let identifier = "PastBookingCell"
            Cell2 = tableView.dequeueReusableCell(withIdentifier: identifier) as? PastBookingCell
            if Cell2 == nil
            {
                tableView.register(UINib(nibName: "PastBookingCell", bundle: nil), forCellReuseIdentifier: identifier)
                Cell2 = tableView.dequeueReusableCell(withIdentifier: identifier) as? PastBookingCell
            }
            Cell2.selectionStyle = UITableViewCellSelectionStyle.none
            BookingsTabl.separatorStyle = .none
            BookingsTabl.separatorColor = UIColor.clear
            
            Cell2.BookingDate.layer.borderWidth = 2.0
            Cell2.BookingDate.layer.borderColor = #colorLiteral(red: 0.3333333333, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
            
            Cell2.BookingTime.layer.borderWidth = 2.0
            Cell2.BookingTime.layer.borderColor = #colorLiteral(red: 0.3333333333, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
            
            Cell2.PreScheduleBookButt.setTitle("Book Your Next Appointment", for: .normal)
            Cell2.PreScheduleBookButt.tag = indexPath.row
            Cell2.PreScheduleBookButt.addTarget(self, action: #selector(self.NextBookingAppointmentClicked), for: .touchUpInside)
            
            
            let imageURL: String = (((self.PastBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "image") as? String ?? ""
            if imageURL == "" || imageURL == "0"
            {
                Cell2.BookingImage.image = UIImage(named: "Placeholder")
            }
            else
            {
                let url = NSURL(string:imageURL)
                Cell2.BookingImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
            }
            
            Cell2.BookingStoreName.text = (((self.PastBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "name") as? String ?? ""
            Cell2.BookingName.text = (((self.PastBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "vandor") as? String ?? ""
            
            Cell2.BookingDate.isHidden = false
            Cell2.BookingTime.isHidden = false
            Cell2.BookingDate.text = (self.PastBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "booking_date") as? String ?? ""
            Cell2.BookingTime.text = (self.PastBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "booking_time") as? String ?? ""
            
//            if let quantity = (((self.PastBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "price") as? NSNumber
//            {
//                let strval = String(describing: quantity)
//                Cell2.BookingPrice.text = String(format:"$ %@", strval)
//            }
//            else if let quantity = (((self.PastBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "price") as? String
//            {
//                Cell2.BookingPrice.text = String(format:"$ %@", quantity)
//            }
            
            if let quantity = (self.PastBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_total") as?  NSNumber
            {
                let strval = String(describing: quantity)
                Cell2.BookingPrice.text = String(format:"$ %@", strval)
            }
            else if let quantity = (self.PastBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_total") as? String
            {
                Cell2.BookingPrice.text = String(format:"$ %@", quantity)
            }
            
            return Cell2
        }
        else if tableView.tag == 3
        {
            let identifier = "PastBookingCell"
            Cell3 = tableView.dequeueReusableCell(withIdentifier: identifier) as? PastBookingCell
            if Cell3 == nil
            {
                tableView.register(UINib(nibName: "PastBookingCell", bundle: nil), forCellReuseIdentifier: identifier)
                Cell3 = tableView.dequeueReusableCell(withIdentifier: identifier) as? PastBookingCell
            }
            Cell3.selectionStyle = UITableViewCellSelectionStyle.none
            BookingsTabl.separatorStyle = .none
            BookingsTabl.separatorColor = UIColor.clear
            
            Cell3.BookingDate.layer.borderWidth = 2.0
            Cell3.BookingDate.layer.borderColor = #colorLiteral(red: 0.3333333333, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
            
            Cell3.BookingTime.layer.borderWidth = 2.0
            Cell3.BookingTime.layer.borderColor = #colorLiteral(red: 0.3333333333, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
            
            Cell3.PreScheduleBookButt.setTitle("Reschedule Appointment", for: .normal)
            Cell3.PreScheduleBookButt.tag = indexPath.row
            Cell3.PreScheduleBookButt.addTarget(self, action: #selector(self.ReScheduleBookingClicked), for: .touchUpInside)
            
            
            let imageURL: String = (((self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "image") as? String ?? ""
            if imageURL == "" || imageURL == "0"
            {
                Cell3.BookingImage.image = UIImage(named: "Placeholder")
            }
            else
            {
                let url = NSURL(string:imageURL)
                Cell3.BookingImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
            }
            
            Cell3.BookingStoreName.text = ((((self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "name") as? String)!
            Cell3.BookingName.text = (((self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "vandor") as? String ?? ""
            
            
            let strbookingdate = (self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "booking_date") as? String ?? ""
            if strbookingdate == ""
            {
                Cell3.BookingDate.isHidden = true
            }
            else
            {
                Cell3.BookingDate.isHidden = false
                Cell3.BookingDate.text = (self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "booking_date") as? String ?? ""
            }
            
            let strbookingtime = (self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "booking_time") as? String ?? ""
            if strbookingtime == ""
            {
                Cell3.BookingTime.isHidden = true
            }
            else
            {
                Cell3.BookingTime.isHidden = false
                Cell3.BookingTime.text = (self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "booking_time") as? String ?? ""
            }
        
            
//            if let quantity = (((self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "price") as? NSNumber
//            {
//                let strval = String(describing: quantity)
//                Cell3.BookingPrice.text = String(format:"$ %@", strval)
//            }
//            else if let quantity = (((self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "price") as? String
//            {
//                 Cell3.BookingPrice.text = String(format:"$ %@", quantity)
//            }
            
            
            if let quantity = (self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_total") as?  NSNumber
            {
                let strval = String(describing: quantity)
                Cell3.BookingPrice.text = String(format:"$ %@", strval)
            }
            else if let quantity = (self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_total") as? String
            {
               Cell3.BookingPrice.text = String(format:"$ %@", quantity)
            }
            
            return Cell3
        }
        else
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
            Cell1.BookingDate.layer.borderColor = #colorLiteral(red: 0.3333333333, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
            
            Cell1.BookingTime.layer.borderWidth = 2.0
            Cell1.BookingTime.layer.borderColor = #colorLiteral(red: 0.3333333333, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
            
            Cell1.BookingDeleteButt.tag = indexPath.row
            Cell1.BookingDeleteButt.addTarget(self, action: #selector(self.BookingDeleteClicked), for: .touchUpInside)
            
            
            let imageURL: String = (((self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "image") as? String ?? ""
            if imageURL == "" || imageURL == "0"
            {
                Cell1.BookingImage.image = UIImage(named: "Placeholder")
            }
            else
            {
                let url = NSURL(string:imageURL)
                Cell1.BookingImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
            }
            
            Cell1.BookingStoreName.text = (((self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "name") as? String ?? ""
            Cell1.BookingName.text = (((self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "vandor") as? String ?? ""
            
            let strbookingdate = (self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "booking_date") as? String ?? ""
            if strbookingdate == ""
            {
                Cell1.BookingDate.isHidden = true
            }
            else
            {
                Cell1.BookingDate.isHidden = false
               
                
                
                Cell1.BookingDate.text = (self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "booking_date") as? String ?? ""
            }
            
            let strbookingtime = (self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "booking_time") as? String ?? ""
            if strbookingtime == ""
            {
                Cell1.BookingTime.isHidden = true
            }
            else
            {
                Cell1.BookingTime.isHidden = false
                 Cell1.BookingTime.text = (self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "booking_time") as? String ?? ""
            }
            
           
            
//            if let quantity = (((self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "price") as? NSNumber
//            {
//                let strval = String(describing: quantity)
//                Cell1.BookingPrice.text = String(format:"$ %@", strval)
//            }
//            else if let quantity = (((self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "price") as? String
//            {
//                Cell1.BookingPrice.text = String(format:"$ %@", quantity)
//            }
            
            if let quantity = (self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_total") as?  NSNumber
            {
                let strval = String(describing: quantity)
                Cell1.BookingPrice.text = String(format:"$ %@", strval)
            }
            else if let quantity = (self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_total") as? String
            {
                Cell1.BookingPrice.text = String(format:"$ %@", quantity)
            }
        
            
            return Cell1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag == 2
        {
            if let quantity = (self.PastBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_id") as? NSNumber
            {
                OrderId = String(describing: quantity)
            }
            else if let quantity = (self.PastBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_id") as? String
            {
                OrderId = quantity
            }
            
            self.UserOrderDetailsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&order_id=%@",Constants.mainURL,"user_order_detail",strUserID,OrderId))
        }
        else if tableView.tag == 3
        {
            if let quantity = (self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_id") as? NSNumber
            {
                OrderId = String(describing: quantity)
            }
            else if let quantity = (self.CancelledBookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_id") as? String
            {
                OrderId = quantity
            }
            
            self.UserOrderDetailsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&order_id=%@",Constants.mainURL,"user_order_detail",strUserID,OrderId))
        }
        else
        {
            if let quantity = (self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_id") as? NSNumber
            {
                OrderId = String(describing: quantity)
            }
            else if let quantity = (self.BookingsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_id") as? String
            {
                OrderId = quantity
            }
            
            self.UserOrderDetailsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&order_id=%@",Constants.mainURL,"user_order_detail",strUserID,OrderId))
        }
    }
    
    
    @objc private   func UserOrderDetailsAPIMethod (baseURL:String)
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
                    let OrderDic = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "order") as? NSDictionary)!
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController
                    myVC?.OrderDetailDic = OrderDic
                    myVC?.strBack = "1"
                    myVC?.hidesBottomBarWhenPushed = true
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
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath)
    {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if (indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex) {
            
            if tableView.tag == 1
            {
                if (strPage1 == "0") {
                    //  loadLbl.text = "No More List"
                    //  actInd.stopAnimating()
                }
                else if (strPage1 == "") {
                    //  loadLbl.text = "No More List"
                    //  actInd.stopAnimating()
                }
                else
                {
                    let baseURL: String  =  String(format:"%@%@?user_id=%@&order_type=1&page=%@",Constants.mainURL,"user_order",strUserID,self.strPage1)
                    print(baseURL)
                    AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
                        
                        DispatchQueue.main.async {
                            AFWrapperClass.svprogressHudDismiss(view: self)
                            let responceDic:NSDictionary = jsonDic as NSDictionary
                            print(responceDic)
                            if (responceDic.object(forKey: "status") as! NSNumber) == 1
                            {
                                self.responsewithToken7(responceDic)
                            }
                            else
                            {
                                
                            }
                        }
                    }) { (error) in
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                        //print(error.localizedDescription)
                    }
                }
            }
            else if tableView.tag == 2
            {
                if (strPage2 == "0") {
                    //  loadLbl.text = "No More List"
                    //  actInd.stopAnimating()
                }
                else if (strPage2 == "") {
                    //  loadLbl.text = "No More List"
                    //  actInd.stopAnimating()
                }
                else
                {
                    let baseURL: String  =  String(format:"%@%@?user_id=%@&order_type=2&page=%@",Constants.mainURL,"user_order",strUserID,self.strPage2)
                    print(baseURL)
                    AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
                        DispatchQueue.main.async {
                            AFWrapperClass.svprogressHudDismiss(view: self)
                            let responceDic:NSDictionary = jsonDic as NSDictionary
                            print(responceDic)
                            if (responceDic.object(forKey: "status") as! NSNumber) == 1
                            {
                                self.responsewithToken8(responceDic)
                            }
                            else
                            {
                                
                            }
                        }
                    }) { (error) in
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                        //print(error.localizedDescription)
                    }
                }
            }
            else
            {
                if (strPage3 == "0") {
                    //  loadLbl.text = "No More List"
                    //  actInd.stopAnimating()
                }
                else if (strPage3 == "") {
                    //  loadLbl.text = "No More List"
                    //  actInd.stopAnimating()
                }
                else
                {
                    let baseURL: String  =  String(format:"%@%@?user_id=%@&order_type=3&page=%@",Constants.mainURL,"user_order",strUserID,self.strPage3)
                    print(baseURL)
                    AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
                        DispatchQueue.main.async {
                            AFWrapperClass.svprogressHudDismiss(view: self)
                            let responceDic:NSDictionary = jsonDic as NSDictionary
                            print(responceDic)
                            if (responceDic.object(forKey: "status") as! NSNumber) == 1
                            {
                                self.responsewithToken9(responceDic)
                            }
                            else
                            {
                                
                            }
                        }
                    }) { (error) in
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                        //print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    func responsewithToken7(_ responseDict: NSDictionary)
    {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        
        var arr = NSMutableArray()
        arr = ((responseDict.object(forKey: "data") as? NSDictionary)?.object(forKey: "order") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.BookingsArray.addObjects(from: arr as [AnyObject])
        
        if let quantity = ((responseDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? NSNumber
        {
            self.strPage1 = String(describing: quantity)
            
        }
        else if let quantity = ((responseDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? String
        {
            self.strPage1 = quantity
        }
        
        BookingsTabl.reloadData()
    }
    
    func responsewithToken8(_ responseDict: NSDictionary)
    {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        
        var arr = NSMutableArray()
        arr = ((responseDict.object(forKey: "data") as? NSDictionary)?.object(forKey: "order") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.PastBookingsArray.addObjects(from: arr as [AnyObject])
        
        if let quantity = ((responseDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? NSNumber
        {
            self.strPage2 = String(describing: quantity)
            
        }
        else if let quantity = ((responseDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? String
        {
            self.strPage2 = quantity
        }
        
        BookingsTabl.reloadData()
    }
    
    func responsewithToken9(_ responseDict: NSDictionary)
    {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        
        var arr = NSMutableArray()
        arr = ((responseDict.object(forKey: "data") as? NSDictionary)?.object(forKey: "order") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.CancelledBookingsArray.addObjects(from: arr as [AnyObject])
        
        if let quantity = ((responseDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? NSNumber
        {
            self.strPage3 = String(describing: quantity)
        }
        else if let quantity = ((responseDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? String
        {
            self.strPage3 = quantity
        }
        
        BookingsTabl.reloadData()
    }
    
    
    
    
    
    
    //MARK: Booking Delete Clicked
    
    @IBAction func BookingDeleteClicked(_ sender: UIButton)
    {
        if let quantity = (self.BookingsArray.object(at: sender.tag) as! NSDictionary).object(forKey: "order_id") as? NSNumber
        {
            OrderId = String(describing: quantity)
        }
        else if let quantity = (self.BookingsArray.object(at: sender.tag) as! NSDictionary).object(forKey: "order_id") as? String
        {
            OrderId = quantity
        }
        
        
        let optionMenu = UIAlertController(title: "Wellness", message: "Are you sure you want to cancel Booking?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        
        let confirmAction = UIAlertAction(title: "Yes", style: .default, handler:
        {(alert: UIAlertAction!) -> Void in
            
            self.UserBookingCancelAPIMethod(baseURL: String(format:"%@%@?order_id=%@",Constants.mainURL,"user_order_cancel",self.OrderId))
            
        })
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(confirmAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    @objc private   func UserBookingCancelAPIMethod (baseURL:String)
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
                    self.UserBookingsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&order_type=1",Constants.mainURL,"user_order",self.strUserID))
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
    
    //MARK: Next Booking Appointment Clicked
    
    @IBAction func NextBookingAppointmentClicked(_ sender: UIButton)
    {
        if strSegment == "2"
        {
            if let quantity = (((self.PastBookingsArray.object(at: sender.tag) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "id")  as? NSNumber
            {
                strProductId = String(describing: quantity)
            }
            else if let quantity = (((self.PastBookingsArray.object(at: sender.tag) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "id") as? String
            {
                strProductId = quantity
            }
            
            self.ProductDetailsAPIMethod(baseURL: String(format:"%@%@?product_id=%@",Constants.mainURL,"product_detail",strProductId))
        }
    }
    
    //MARK: ReSchedule Booking Clicked
    
    @IBAction func ReScheduleBookingClicked(_ sender: UIButton)
    {
        if strSegment == "3"
        {
            if let quantity = (((self.CancelledBookingsArray.object(at: sender.tag) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "id")  as? NSNumber
            {
                strProductId = String(describing: quantity)
            }
            else if let quantity = (((self.CancelledBookingsArray.object(at: sender.tag) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "id") as? String
            {
                strProductId = quantity
            }
            
            
            let optionMenu = UIAlertController(title: "Reschedule Booking", message: "Are you sure you want to Reschedule Booking?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
            })
            
            let confirmAction = UIAlertAction(title: "Yes", style: .default, handler:
            {(alert: UIAlertAction!) -> Void in
                
                self.ProductDetailsAPIMethod(baseURL: String(format:"%@%@?product_id=%@",Constants.mainURL,"product_detail",self.strProductId))
                
            })
            optionMenu.addAction(cancelAction)
            optionMenu.addAction(confirmAction)
            
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    @objc private   func ProductDetailsAPIMethod (baseURL:String)
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
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailCategoryViewController") as? DetailCategoryViewController
                    myVC?.hidesBottomBarWhenPushed = true
                    myVC?.ProductDetail = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "product") as? NSDictionary)!
                    let strimage = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "product") as? NSDictionary)?.object(forKey: "image") as? String ?? ""
                    let imageArray = NSMutableArray()
                    imageArray.add(strimage)
                    myVC?.imagesArray = imageArray
                    myVC?.strProductId = self.strProductId
                    myVC?.strBack = "1"
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
