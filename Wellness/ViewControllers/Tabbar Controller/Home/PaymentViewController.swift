//
//  PaymentViewController.swift
//  Wellness
//
//  Created by think360 on 28/05/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController,UITextFieldDelegate,STPPaymentCardTextFieldDelegate,SecondDelegate {

    var strAmount = String()
    var myArray = NSDictionary()
    var strUserID = String()
    var OrderID = String()
    
  
    @IBOutlet weak var TotalView: UIView!
    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var YearView: UIView!
    @IBOutlet weak var CVVView: UIView!
    
    
    @IBOutlet weak var txtAmount: UILabel!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtCvv: UITextField!
    @IBOutlet weak var PayButt: UIButton!
    
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    
    var strMonth = Int()
    var strYear = Int()
    
    var param: STPCardParams?
    var paymentTextField: STPPaymentCardTextField?
    var amountStr = ""
    var invoice = ""
    
    var StrProfile = String()
    var StrProductId = String()
    var StrDays = String()
  

    
    
    
    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self

        // Do any additional setup after loading the view.
        
        TotalView.layer.cornerRadius = 4.0
        TotalView.layer.borderWidth = 1.0
        TotalView.layer.borderColor = #colorLiteral(red: 0.8077743649, green: 0.8078885674, blue: 0.807738483, alpha: 1)
        TotalView.clipsToBounds = true
        
        CardView.layer.cornerRadius = 4.0
        CardView.layer.borderWidth = 1.0
        CardView.layer.borderColor = #colorLiteral(red: 0.8077743649, green: 0.8078885674, blue: 0.807738483, alpha: 1)
        CardView.clipsToBounds = true
        
        YearView.layer.cornerRadius = 4.0
        YearView.layer.borderWidth = 1.0
        YearView.layer.borderColor = #colorLiteral(red: 0.8077743649, green: 0.8078885674, blue: 0.807738483, alpha: 1)
        YearView.clipsToBounds = true
        
        CVVView.layer.cornerRadius = 4.0
        CVVView.layer.borderWidth = 1.0
        CVVView.layer.borderColor = #colorLiteral(red: 0.8077743649, green: 0.8078885674, blue: 0.807738483, alpha: 1)
        CVVView.clipsToBounds = true
        
        
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
        
        strAmount = strAmount.trimmingCharacters(in: .whitespaces)
        
        //  txtMonthYear.delegate = self
        //   txtMonthYear.addTarget(self, action: #selector(self.textFieldEditingChanged), for: .editingChanged)
        
        let str3 = "$"
        txtAmount.text = str3+strAmount
        
        let str1 = "Pay $"
        let str2 = str1+strAmount
        PayButt.setTitle(str2, for: .normal)
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
        
        self.txtCardNumber.inputAccessoryView = doneToolbar
        self.txtMonth.inputAccessoryView = doneToolbar
        self.txtYear.inputAccessoryView = doneToolbar
        self.txtCvv.inputAccessoryView = doneToolbar
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
    
    
    
    //MARK: Back Butt Clicked
    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func PayNowButtClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        var message = String()
        
        if (txtCardNumber.text?.isEmpty)!
        {
            message = "Please Enter Card Number"
        }
        else if (txtMonth.text?.isEmpty)!
        {
            message = "Please Enter Month"
        }
        else if (txtYear.text?.isEmpty)!
        {
            message = "Please Enter Expiry"
        }
        else if (txtCvv.text?.isEmpty)!
        {
            message = "Please Enter CVV"
        }
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            
            // let a = txtMonthYear.text!
            //  let last4 = a.substring(from:a.index(a.endIndex, offsetBy: -2))
            //  let count = Int(last4)
            // print(count!)
            
            // strMonth = txtMonth.text
            //  strYear = txtYear.text
            
            print(txtCvv.text!)
            
            let myInteger = Int(txtYear.text!)! + 2000
            
            param = STPCardParams()
            param?.number = txtCardNumber.text
            param?.cvc = txtCvv.text!
            param?.expMonth = UInt(txtMonth.text!)!
            param?.expYear = UInt(myInteger)
            
            print(param ?? "")
            
            STPAPIClient.shared().createToken(withCard: param!, completion: { (token, error) -> Void in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    self.handleError(error! as NSError)
                    return
                }
                
                print(token!)
                
                if self.StrProfile == "1"
                {
                   // self.AddPostAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"product_bost_payment") , params: "user_id=\(self.strUserID)&token=\(token!)&amount=\(self.strAmount)&product_id=\(self.StrProductId)&days=\(self.StrDays)")
                }
                else
                {
                  //  self.AddPostAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"order_payment") , params: "order_id=\(self.OrderID)&token=\(token!)&amount=\(self.strAmount)")
                }
                
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SuccessPaymentViewController") as? SuccessPaymentViewController
                self.navigationController?.pushViewController(myVC!, animated: true)
                
            })
            
        }
    }
    func handleError(_ error: NSError) {
        
         AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
    }
    
    
    @objc private   func AddPostAPIMethod (baseURL:String , params: String)
    {
        print(params);
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                  
                }
                else
                {
                    
                }
            }
            
        }) { (error) in
            
            
            // AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }
    
    
    
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldEditingChanged(_ textField: UITextField)
    {
        // print(txtMonthYear.dateComponents.year ?? "")
        //   print(txtMonthYear.dateComponents.month ?? "")
        
        //        if (txtMonthYear.dateComponents.month != nil)
        //        {
        //            strMonth = txtMonthYear.dateComponents.month!
        //        }
        //        else if (txtMonthYear.dateComponents.year != nil)
        //        {
        //            strYear = txtMonthYear.dateComponents.year!
        //        }
    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    //    {
    //        if textField == txtMonth
    //        {
    //           let str = txtMonth.text
    //
    //
    //
    //        }
    //    }

    
    
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
