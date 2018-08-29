//
//  ProfileViewController.swift
//  Wellness
//
//  Created by think360 on 06/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,SecondDelegate {

     @IBOutlet weak var TopViewHeight: NSLayoutConstraint!
    @IBOutlet weak var UserProfileImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    
    @IBOutlet weak var AccountButt: UIButton!
    @IBOutlet weak var MyOrdersButt: UIButton!
    @IBOutlet weak var BillingButt: UIButton!
    @IBOutlet weak var TermsButt: UIButton!
    @IBOutlet weak var HelpButt: UIButton!
    @IBOutlet weak var LogoutButt: UIButton!
    
    var myArray = NSDictionary()
    var strUserID = String()
    
    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
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
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                TopViewHeight.constant = 23
            default:
                TopViewHeight.constant = 0
            }
        }
        
        AccountButt.clipsToBounds = true
        AccountButt.layer.borderWidth = 2
        AccountButt.layer.borderColor = #colorLiteral(red: 0.3254901961, green: 0.2, blue: 0.5450980392, alpha: 1)
        
        MyOrdersButt.clipsToBounds = true
        MyOrdersButt.layer.borderWidth = 2
        MyOrdersButt.layer.borderColor = #colorLiteral(red: 0.3254901961, green: 0.2, blue: 0.5450980392, alpha: 1)
        
        BillingButt.clipsToBounds = true
        BillingButt.layer.borderWidth = 2
        BillingButt.layer.borderColor = #colorLiteral(red: 0.3254901961, green: 0.2, blue: 0.5450980392, alpha: 1)
        
        TermsButt.clipsToBounds = true
        TermsButt.layer.borderWidth = 2
        TermsButt.layer.borderColor = #colorLiteral(red: 0.3254901961, green: 0.2, blue: 0.5450980392, alpha: 1)
        
        HelpButt.clipsToBounds = true
        HelpButt.layer.borderWidth = 2
        HelpButt.layer.borderColor = #colorLiteral(red: 0.3254901961, green: 0.2, blue: 0.5450980392, alpha: 1)
        
        // Do any additional setup after loading the view.
        
         self.UserDetailsAPIMethod(baseURL: String(format:"%@%@?user_id=%@",Constants.mainURL,"user_deatil",strUserID))
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
        
       
        
        if UserDefaults.standard.object(forKey: "front") != nil
        {
            UserDefaults.standard.removeObject(forKey: "front")
            self.UserDetailsAPIMethod(baseURL: String(format:"%@%@?user_id=%@",Constants.mainURL,"user_deatil",strUserID))
        }
        else
        {
//            if UserDefaults.standard.object(forKey: "FLogin") != nil
//            {
//                UserDefaults.standard.removeObject(forKey: "FLogin")
//                self.UserDetailsAPIMethod(baseURL: String(format:"%@%@?user_id=%@",Constants.mainURL,"user_deatil",strUserID))
//            }
            
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            classObject.checkLoginStatus()
        }
        
       // self.Check1(baseURL: "https://wellnesswrx.ca/demo/api/index.php/12345/product_add_to_cart?product_id=10333")
      //  self.Check2(baseURL: "https://wellnesswrx.ca/demo/api/index.php/12345/get_product_cart?product_id=10333")
        
        
        
    }
    
    @objc private   func UserDetailsAPIMethod (baseURL:String)
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
                    let str1 = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "user")) as? NSDictionary)?.object(forKey: "first_name") as? String ?? ""
                     let str2 = " "
                    let str3 = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "user")) as? NSDictionary)?.object(forKey: "last_name") as? String ?? ""
                   
                    self.UserName.text = str1+str2+str3
                    
                    let imageURL: String = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "user")) as? NSDictionary)?.object(forKey: "profile_pic") as? String ?? ""
                    if imageURL == ""
                    {
                        self.UserProfileImage.image = UIImage(named: "Placeholder")
                    }
                    else
                    {
                        let url = NSURL(string:imageURL)
                        self.UserProfileImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
                    }
                    
                    let str4 = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "user")) as? NSDictionary)?.object(forKey: "email") as? String ?? ""
                    let str5 = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "user")) as? NSDictionary)?.object(forKey: "phone") as? String ?? ""
                    let str6 = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "user")) as? NSDictionary)?.object(forKey: "profile_pic") as? String ?? ""
                    
                    let newUserData = UserProfile(FirstName: str1, LastName: str3, EmailId: str4, Phone: str5, ImageUrl: str6)
                    var newUserProfile = [UserProfile]()
                    newUserProfile.append(newUserData)
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: newUserProfile)
                    UserDefaults.standard.set(encodedData, forKey: "UserProfile")
                    
                    AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                    self.classObject.checkLoginStatus()
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                    
                    AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                    self.classObject.checkLoginStatus()
                }
            }
            
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    
    @objc private   func Check1 (baseURL:String)
    {
        print(baseURL)
        //AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    
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
    
    @objc private   func Check2 (baseURL:String)
    {
        print(baseURL)
        //AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    
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
    
    
    
    // MARK:  Account Butt Clicked
    
    @IBAction func AccountButtClicked(_ sender: UIButton)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountDetailsViewController") as? AccountDetailsViewController
        myVC?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    // MARK:  My Orders Butt Clicked
    @IBAction func MyOrdersButtClicked(_ sender: UIButton)
    {
         self.UserOrderAPIMethod(baseURL: String(format:"%@%@?user_id=%@&order_type=2",Constants.mainURL,"user_order",strUserID))
        
      //  self.UserOrderAPIMethod(baseURL: String(format:"%@%@?user_id=45&order_type=2",Constants.mainURL,"user_order"))
    }
    
    @objc private   func UserOrderAPIMethod (baseURL:String)
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
                    let OrderArray = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "order") as? NSMutableArray)!
                    
                    if OrderArray.count == 0
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: "You Don't have any Orders", view: self)
                    }
                    else
                    {
                        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController") as? MyOrdersViewController
                        myVC?.OrderArray = OrderArray
                        if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? NSNumber
                        {
                            myVC?.strPage = String(describing: quantity)
                        }
                        else if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? String
                        {
                            myVC?.strPage = quantity
                        }
                        myVC?.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(myVC!, animated: true)
                    }
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
    
    
    
    // MARK:  Billing Butt Clicked
    
    @IBAction func BillingButtClicked(_ sender: UIButton)
    {
        self.UserBillingAddressAPIMethod(baseURL: String(format:"%@%@?user_id=%@",Constants.mainURL,"user_billing_address",strUserID))
    }
    
    @objc private   func UserBillingAddressAPIMethod (baseURL:String)
    {
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "BillingAddressViewController") as? BillingAddressViewController
                    myVC?.UserBillingDic = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "user")) as? NSDictionary)!
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
    
    
    
    
    
    
    // MARK:  Terms Butt Clicked
    
    @IBAction func TermsButtClicked(_ sender: UIButton)
    {
//        guard let url = URL(string: "https://wellnesswrx.ca/support/") else {
//            return //be safe
//        }
//
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(url)
//        }
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsViewController") as? TermsViewController
        myVC?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
     // MARK:  Help Butt Clicked
    
    @IBAction func HelpButtClicked(_ sender: UIButton)
    {
//        guard let url = URL(string: "https://wellnesswrx.ca/support/") else {
//            return //be safe
//        }
//
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(url)
//        }
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "HelpViewController") as? HelpViewController
        myVC?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
     // MARK:  Logout Butt Clicked
    
    @IBAction func LogoutButtClicked(_ sender: UIButton)
    {
        let optionMenu = UIAlertController(title: "Wellness", message: "Are you sure want to logout?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler:
        {(alert: UIAlertAction!) -> Void in
            
            UserDefaults.standard.removeObject(forKey: "UserLogin")
            UserDefaults.standard.removeObject(forKey: "UserId")  
            UserDefaults.standard.removeObject(forKey: "NewPlace")
            UserDefaults.standard.removeObject(forKey: "UserProfile")
            
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            myVC?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(myVC!, animated: true)

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(confirmAction)
        
        self.present(optionMenu, animated: true, completion: nil)
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
