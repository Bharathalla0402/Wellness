//
//  RegistrationViewController.swift
//  Wellness
//
//  Created by think360 on 05/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import RaisePlaceholder
import Alamofire

class RegistrationViewController: UIViewController
{
   
    @IBOutlet weak var FirstNameView: UIView!
    @IBOutlet weak var LastNameView: UIView!
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var ConfirmPasswordView: UIView!
    
   
    @IBOutlet weak var txtFirstName: ACFloatingTextfield!
   // @IBOutlet weak var txtFirstName: RaisePlaceholder!
    @IBOutlet weak var txtLastName: ACFloatingTextfield!
   // @IBOutlet weak var txtLastName: RaisePlaceholder!
    @IBOutlet weak var txtEmailAddress: ACFloatingTextfield!
    //@IBOutlet weak var txtEmailAddress: RaisePlaceholder!
    @IBOutlet weak var txtPassword: ACFloatingTextfield!
   // @IBOutlet weak var txtPassword: RaisePlaceholder!
    @IBOutlet weak var txtConfirmPassword: ACFloatingTextfield!
   // @IBOutlet weak var txtConfirmPassword: RaisePlaceholder!
    
     var userData = NSDictionary()
    
    var DeviceToken=String()
    var DeviceType=String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         DeviceType = "ios"
        
        FirstNameView.clipsToBounds = true
        FirstNameView.layer.borderWidth = 1.0
        FirstNameView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        LastNameView.clipsToBounds = true
        LastNameView.layer.borderWidth = 1.0
        LastNameView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        EmailView.clipsToBounds = true
        EmailView.layer.borderWidth = 1.0
        EmailView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        PasswordView.clipsToBounds = true
        PasswordView.layer.borderWidth = 1.0
        PasswordView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        ConfirmPasswordView.clipsToBounds = true
        ConfirmPasswordView.layer.borderWidth = 1.0
        ConfirmPasswordView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

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
        self.txtEmailAddress.inputAccessoryView = doneToolbar
        self.txtPassword.inputAccessoryView = doneToolbar
        self.txtConfirmPassword.inputAccessoryView = doneToolbar
    }
    
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
      // MARK:  SignUp Butt Clicked
    
    @IBAction func SignUpButtClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let str1: String = txtPassword.text!
        let str2: String = txtConfirmPassword.text!
        
        var message = String()
        if (txtFirstName.text?.isEmpty)!
        {
            message = "Please Enter First Name"
        }
        else if (txtLastName.text?.isEmpty)!
        {
            message = "Please Enter Last Name"
        }
        else if (txtEmailAddress.text?.isEmpty)!
        {
            message = "Please Enter Email Id"
        }
        else if !AFWrapperClass.isValidEmail(txtEmailAddress.text!)
        {
            message = "Please Enter Valid Email"
        }
        else if (txtPassword.text?.isEmpty)!
        {
            message = "Please Enter Your Password"
        }
        else if (str1 != str2)
        {
            message = "Password and Confirm Password is Not Matching"
        }
        if message.count > 1
        {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
//            let parameters = [
//                "first_name": txtFirstName.text!,"last_name": txtLastName.text!,"email": txtEmailAddress.text!,"password": txtPassword.text!
//            ]
//            self.RegisterAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"user_register") , params: parameters)
            
            if UserDefaults.standard.object(forKey: "DeviceToken") != nil
            {
                DeviceToken=UserDefaults.standard.object(forKey: "DeviceToken") as! String
            }
            else
            {
                DeviceToken = "1452645231"
            }
            
             self.RegisterAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"user_register") , params: "first_name=\(txtFirstName.text!)&last_name=\(txtLastName.text!)&email=\(txtEmailAddress.text!)&password=\(txtPassword.text!)&device_id=\(DeviceToken)&device_type=\(DeviceType)")
        }

    }
    
    
    @objc private   func RegisterAPIMethod (baseURL:String , params: String)
    {
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                   // UserDefaults.standard.setValue("Yes", forKey: "FLogin")
                    
                    self.userData = (responceDic.object(forKey: "data") as? NSDictionary)!
                    let currentDefaults: UserDefaults? = UserDefaults.standard
                    let data = NSKeyedArchiver.archivedData(withRootObject: self.userData)
                    currentDefaults?.set(data, forKey: "UserId")
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as? TabsViewController
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
    
    
//    @objc private   func RegisterAPIMethod (baseURL:String , params: [String : String]?)
//    {
//        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (jsonDic) in
//
//            DispatchQueue.main.async {
//                AFWrapperClass.svprogressHudDismiss(view: self)
//                let responceDic:NSDictionary = jsonDic as NSDictionary
//                print(responceDic)
//                if  (responceDic.object(forKey: "status") as! NSNumber) == 1
//                {
//                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as? TabsViewController
//                    self.navigationController?.pushViewController(myVC!, animated: true)
//                }
//                else
//                {
//                    AFWrapperClass.svprogressHudDismiss(view: self)
//                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.value(forKey: "message") as! String, view: self)
//                }
//            }
//
//        }) { (error) in
//
//            AFWrapperClass.svprogressHudDismiss(view: self)
//            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
//            //print(error.localizedDescription)
//        }
//    }
    
     // MARK:  LogIn Butt Clicked
    
    @IBAction func LogInButtClicked(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
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
