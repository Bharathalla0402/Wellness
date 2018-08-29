//
//  NotificationListViewController.swift
//  Wellness
//
//  Created by think360 on 21/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell
{
    @IBOutlet weak var NotificationImage: UIImageView!
    @IBOutlet weak var NotificationText: UILabel!
    @IBOutlet weak var NotificationBookingId: UILabel!
    @IBOutlet weak var NotificationTime: UILabel!
    
}

class NotificationListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SecondDelegate {

    @IBOutlet weak var NotificationTabl: UITableView!
    var Cell:NotificationCell!
    
    var NotificatonListArray = NSMutableArray()
    var NotificationCount = NSNumber()
    
    var myArray = NSDictionary()
    var strUserID = String()
    
    var strpage = String()
    
    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.Notificationmethod), name: NSNotification.Name(rawValue: "Notification"), object: nil)
        
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

        // Do any additional setup after loading the view.
        
        NotificationTabl.rowHeight = UITableViewAutomaticDimension
        NotificationTabl.estimatedRowHeight = 123
        NotificationTabl.tableFooterView = UIView()
        
        NotificationCount = 0
        UserDefaults.standard.set(NotificationCount, forKey: "NCount")
        
        let notificationName = Notification.Name("Notification")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func Notificationmethod()
    {
        if UserDefaults.standard.object(forKey: "NCount") != nil
        {
            var localTimeZoneName: String { return TimeZone.current.identifier }
            self.NotificationsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&time_zone=%@",Constants.mainURL,"user_notification",strUserID,localTimeZoneName))
        }
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
                    self.NotificatonListArray.removeAllObjects()
                    self.NotificatonListArray = ((responceDic.object(forKey: "data") as! NSDictionary).value(forKey: "notification") as? NSMutableArray)!
                    
                    if let quantity = (responceDic.object(forKey: "data") as! NSDictionary).value(forKey: "nextPage") as? NSNumber
                    {
                        self.strpage = String(describing: quantity)
                    }
                    else if let quantity = (responceDic.object(forKey: "data") as! NSDictionary).value(forKey: "nextPage") as? String
                    {
                        self.strpage = quantity
                    }
                    
                    self.NotificationTabl.reloadData()
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
    
    // MARK:  Back Butt Clicked
    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
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

    
    
    // MARK:  TableView Delegate Methods
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return NotificatonListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "NotificationCell"
        Cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotificationCell
        if Cell == nil
        {
            tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: identifier)
            Cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotificationCell
        }
        Cell.selectionStyle = UITableViewCellSelectionStyle.none
        NotificationTabl.separatorStyle = .none
        NotificationTabl.separatorColor = UIColor.clear
        
        Cell.NotificationText.text = (self.NotificatonListArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "text") as? String ?? ""
        Cell.NotificationBookingId.text = ""
        Cell.NotificationTime.text = (self.NotificatonListArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "date") as? String ?? ""
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath)
    {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if (indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex) {
            if (strpage == "0") {
                //  loadLbl.text = "No More List"
                //  actInd.stopAnimating()
            }
            else if (strpage == "") {
                //    loadLbl.text = "No More List"
                //   actInd.stopAnimating()
            }
            else
            {
                
                var localTimeZoneName: String { return TimeZone.current.identifier }
                let baseURL: String  = String(format:"%@%@?user_id=%@&time_zone=%@&page=%@",Constants.mainURL,"user_notification",strUserID,localTimeZoneName,strpage)
                
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
        
    }
    
    
    func responsewithToken7(_ responseDict: NSDictionary)
    {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        
        var arr = NSMutableArray()
        arr = ((responseDictionary.object(forKey: "data") as! NSDictionary).value(forKey: "notification") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.NotificatonListArray.addObjects(from: arr as [AnyObject])
        
        if let quantity = (responseDictionary.object(forKey: "data") as! NSDictionary).value(forKey: "nextPage") as? NSNumber
        {
            self.strpage = String(describing: quantity)
        }
        else if let quantity = (responseDictionary.object(forKey: "data") as! NSDictionary).value(forKey: "nextPage") as? String
        {
            self.strpage = quantity
        }
        
        self.NotificationTabl.reloadData()
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
