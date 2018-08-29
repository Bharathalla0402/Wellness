//
//  PaymentSelectViewController.swift
//  Wellness
//
//  Created by think360 on 13/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class PaymentSelectViewController: UIViewController, PayPalPaymentDelegate,SecondDelegate {
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var resultText = "" // empty
    var payPalConfig = PayPalConfiguration() // def {

    @IBOutlet weak var PaypalView: UIView!
    @IBOutlet weak var PayPalSelectImage: UIImageView!
    @IBOutlet weak var StripeView: UIView!
    @IBOutlet weak var StripeImage: UIImageView!
   
    var myArray = NSDictionary()
    var strUserID = String()
    
    var StrProYearId = Int()
    var StrProMonthId = Int()
    
    
    var strSelect = String()
    
    var strProductId = String()
    var ProductDetail = NSDictionary()
    var strCouponId = String()
    var StrProductPrice = String()
    var StrProductDate = String()
    var StrProducttime = String()
    var StrProductMonthName = String()
    var StrProductYear = String()
    var StrProductname = String()
    var StrProductMonthId = String()
    
    var classObject = MultipartViewController()
    var StrPageCheck = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
        StrPageCheck = "1"
        
         StrProductname = ProductDetail.value(forKey: "name") as? String ?? ""
         print(strProductId)
         print(strCouponId)
         print(StrProductPrice)
         print(StrProductDate)
         print(StrProducttime)
         print(StrProductYear)
         print(StrProductMonthName)
         print(StrProductMonthId)
         print(StrProductname)
        
        
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
        
        
        StripeView.isHidden = true

        
        strSelect = ""
        
        PaypalView.layer.borderWidth = 0.5
        PaypalView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        StripeView.layer.borderWidth = 0.5
        StripeView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        // Do any additional setup after loading the view.
        
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "Wellness"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;
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
        
        if StrPageCheck == "1"
        {
           AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
           classObject.checkLoginStatus()
        }
    }
    
    // MARK:  Back Butt Clicked
    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:  Paypal Butt Clicked
    
    @IBAction func PayPalButtClicked(_ sender: UIButton)
    {
        strSelect = "1"
        PayPalSelectImage.image = UIImage(named: "Check")
        StripeImage.image = UIImage(named: "Uncheck")
    }
    
     // MARK:  Stripe Butt Clicked
    
    @IBAction func StripeButtClicked(_ sender: UIButton)
    {
        strSelect = "2"
        PayPalSelectImage.image = UIImage(named: "Uncheck")
        StripeImage.image = UIImage(named: "Check")
    }
    
    
    //MARK: Pay Now Butt Clicked
    
    @IBAction func PayNowButtClicked(_ sender: UIButton)
    {
        
        if strSelect == ""
        {
            AFWrapperClass.alert(Constants.applicationName, message: "Please Select the Payment Method", view: self)
        }
        else if strSelect == "1"
        {
            self.BookingAvailableAPIMethod(baseURL: String(format:"%@%@?product_id=%@&year=%d&month=%d&day=%@&time=%@",Constants.mainURL,"check_booking_availabilty",strProductId,StrProYearId,StrProMonthId,StrProductDate,StrProducttime))
        }
        else
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController
            myVC?.hidesBottomBarWhenPushed = true
            myVC?.strAmount = StrProductPrice
            self.navigationController?.pushViewController(myVC!, animated: true)
        }
        
      // _ = self.tabBarController?.selectedIndex = 0
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
                    self.StrPageCheck = "2"
                    self.view.isUserInteractionEnabled = false
                    //  AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                    
                    // Remove our last completed payment, just for demo purposes.
                    self.resultText = ""
                    
                    // Note: For purposes of illustration, this example shows a payment that includes
                    //       both payment details (subtotal, shipping, tax) and multiple items.
                    //       You would only specify these if appropriate to your situation.
                    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
                    //       and simply set payment.amount to your total charge.
                    
                    // Optional: include multiple items
                    let item1 = PayPalItem(name: "Requi Session", withQuantity: 1, withPrice: NSDecimalNumber(string: self.StrProductPrice), withCurrency: "USD", withSku: self.strProductId)
                    // let item2 = PayPalItem(name: "Free rainbow patch", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "Hip-00066")
                    // let item3 = PayPalItem(name: "Long-sleeve plaid shirt (mustache not included)", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "Hip-00291")
                    
                    let items = [item1]
                    let subtotal = PayPalItem.totalPrice(forItems: items)
                    
                    // Optional: include payment details
                    let shipping = NSDecimalNumber(string: "0.0")
                    let tax = NSDecimalNumber(string: "0.0")
                    let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
                    
                    let total = subtotal.adding(shipping).adding(tax)
                    
                    let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Wellness", intent: .sale)
                    
                    payment.items = items
                    payment.paymentDetails = paymentDetails
                    
                    if (payment.processable) {
                        let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: self.payPalConfig, delegate: self)
                        self.present(paymentViewController!, animated: true, completion: nil)
                    }
                    else {
                        self.view.isUserInteractionEnabled = true
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        // This particular payment will always be processable. If, for
                        // example, the amount was negative or the shortDescription was
                        // empty, this payment wouldn't be processable, and you'd want
                        // to handle that here.
                        print("Payment not processalbe: \(payment)")
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
    
    
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController)
    {
         self.view.isUserInteractionEnabled = true
         AFWrapperClass.svprogressHudDismiss(view: self)
        print("PayPal Payment Cancelled")
        resultText = ""
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
//    func paymentFailed(withCorrelationID correlationID: String, andErrorCode errorCode: String, andErrorMessage errorMessage: String)
//    {
//         AFWrapperClass.svprogressHudDismiss(view: self)
//    }
//
   

    
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
             var strInvoicenum = String()
             if let aps = completedPayment.confirmation["response"] as? [String: Any]
             {
                strInvoicenum = aps["id"] as! String
             }
            print(strInvoicenum)
            let straddress = ""
            let strFname = ""
            let strLname = ""
            let strStatus = "approved"
            
            
            self.BookingAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"post_booking") , params: "product_id=\(self.strProductId)&booking_year=\(self.StrProductYear)&booking_month=\(self.StrProductMonthId)&booking_day=\(self.StrProductDate)&booking_time=\(self.StrProducttime)&coupon_id=\(self.strCouponId)&user_id=\(self.strUserID)&txn_id=\(strInvoicenum)&paypal_address=\(straddress)&paypal_first_name=\(strFname)&paypal_last_name=\(strLname)&paypal_status=\(strStatus)")
            
            
           // self.showSuccess()
        })
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
                     self.view.isUserInteractionEnabled = true
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
                     self.view.isUserInteractionEnabled = true
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                }
            }
            
        }) { (error) in
             self.view.isUserInteractionEnabled = true
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    
    
    // MARK: Paypal Payment Success
    
    func showSuccess() {
       
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
