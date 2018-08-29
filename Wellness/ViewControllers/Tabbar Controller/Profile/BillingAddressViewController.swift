//
//  BillingAddressViewController.swift
//  Wellness
//
//  Created by think360 on 13/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import RaisePlaceholder

class BillingAddressViewController: UIViewController,SecondDelegate {

    @IBOutlet weak var txtFirstName: ACFloatingTextfield!
    @IBOutlet weak var txtLastName: ACFloatingTextfield!
    @IBOutlet weak var txtCompanyName: ACFloatingTextfield!
    @IBOutlet weak var txtCountry: ACFloatingTextfield!
    @IBOutlet weak var txtStreetAddress: ACFloatingTextfield!
    @IBOutlet weak var txtTownCity: ACFloatingTextfield!
    @IBOutlet weak var txtProvince: ACFloatingTextfield!
    @IBOutlet weak var txtPostalZip: ACFloatingTextfield!
    @IBOutlet weak var txtPhoneNumber: ACFloatingTextfield!
    @IBOutlet weak var txtEmailAddress: ACFloatingTextfield!
    
    var UserBillingDic = NSDictionary()
    
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
        
        txtFirstName.text = UserBillingDic.object(forKey: "first_name") as? String ?? ""
        txtLastName.text = UserBillingDic.object(forKey: "last_name") as? String ?? ""
        txtCompanyName.text = UserBillingDic.object(forKey: "comapany_name") as? String ?? ""
        txtCountry.text = UserBillingDic.object(forKey: "country") as? String ?? ""
        txtStreetAddress.text = UserBillingDic.object(forKey: "street") as? String ?? ""
        txtTownCity.text = UserBillingDic.object(forKey: "city") as? String ?? ""
        txtProvince.text = UserBillingDic.object(forKey: "state") as? String ?? ""
        txtPostalZip.text = UserBillingDic.object(forKey: "zipcode") as? String ?? ""
        txtPhoneNumber.text = UserBillingDic.object(forKey: "phone") as? String ?? ""
        txtEmailAddress.text = UserBillingDic.object(forKey: "email") as? String ?? ""
        

        // Do any additional setup after loading the view.
         self.addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.txtFirstName.inputAccessoryView = doneToolbar
        self.txtLastName.inputAccessoryView = doneToolbar
        self.txtCompanyName.inputAccessoryView = doneToolbar
        self.txtCountry.inputAccessoryView = doneToolbar
        self.txtStreetAddress.inputAccessoryView = doneToolbar
        self.txtTownCity.inputAccessoryView = doneToolbar
        self.txtProvince.inputAccessoryView = doneToolbar
        self.txtPostalZip.inputAccessoryView = doneToolbar
        self.txtPhoneNumber.inputAccessoryView = doneToolbar
        self.txtEmailAddress.inputAccessoryView = doneToolbar
    }
    
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
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
    
    
    // MARK:  SaveChanges Butt Clicked
    
    @IBAction func SavechangesButtClicked(_ sender: UIButton)
    {
       self.view.endEditing(true)
        
        var message = String()
        if (txtFirstName.text?.isEmpty)!
        {
            message = "Please Enter First Name"
        }
        else if (txtLastName.text?.isEmpty)!
        {
            message = "Please Enter Last Name"
        }
        else if (txtCountry.text?.isEmpty)!
        {
            message = "Please Enter Country Name"
        }
        else if (txtStreetAddress.text?.isEmpty)!
        {
            message = "Please Enter Street Address"
        }
        else if (txtTownCity.text?.isEmpty)!
        {
            message = "Please Enter City/Town Name"
        }
        else if (txtProvince.text?.isEmpty)!
        {
            message = "Please Enter Province"
        }
        else if (txtPostalZip.text?.isEmpty)!
        {
            message = "Please Enter Postal Zipcode"
        }
        else if (txtPhoneNumber.text?.isEmpty)!
        {
            message = "Please Enter Phone Number"
        }
        else if (txtEmailAddress.text?.isEmpty)!
        {
            message = "Please Enter Email Id"
        }
        else if !AFWrapperClass.isValidEmail(txtEmailAddress.text!)
        {
            message = "Please Enter Valid Email"
        }

        if message.characters.count > 1
        {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
             self.UserBillingAddressUpdateAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"user_billing_address_update") , params: "first_name=\(txtFirstName.text!)&last_name=\(txtLastName.text!)&company=\(txtCompanyName.text!)&country=\(txtCountry.text!)&street=\(txtStreetAddress.text!)&city=\(txtTownCity.text!)&state=\(txtProvince.text!)&postcode=\(txtPostalZip.text!)&email=\(txtEmailAddress.text!)&phone=\(txtPhoneNumber.text!)&user_id=\(strUserID)")
        }
    }
    
    
    @objc private   func UserBillingAddressUpdateAPIMethod (baseURL:String , params: String)
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
                    _ = self.navigationController?.popViewController(animated: true)
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
