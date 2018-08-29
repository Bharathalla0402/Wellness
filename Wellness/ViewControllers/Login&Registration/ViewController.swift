//
//  ViewController.swift
//  Wellness
//
//  Created by think360 on 05/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import RaisePlaceholder

class ViewController: UIViewController,UIWebViewDelegate
{
    @IBOutlet weak var TermsLab: UILabel!
    @IBOutlet weak var UsernameView: UIView!
    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var txtUsername: ACFloatingTextfield!
   // @IBOutlet var txtUsername: RaisePlaceholder!
    @IBOutlet weak var txtPassword: ACFloatingTextfield!
   // @IBOutlet var txtPassword: RaisePlaceholder!
    
    var userData = NSDictionary()
    var DeviceToken=String()
    var DeviceType=String()
   
    var popview = UIView()
    var footerView = UIView()
    var termsView = UIWebView()
    var htmlstring=String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DeviceType = "ios"
        
        UserDefaults.standard.set("Yes", forKey: "Installed")
        
        let mutableAttributedString = NSMutableAttributedString()
        let regularAttribute = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 13),
            NSForegroundColorAttributeName: #colorLiteral(red: 0.3764362037, green: 0.3764933348, blue: 0.3764182329, alpha: 1)
            ] as [String : Any]
        let boldAttribute = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13),
            NSForegroundColorAttributeName: #colorLiteral(red: 0.3764362037, green: 0.3764933348, blue: 0.3764182329, alpha: 1)
            ] as [String : Any]
        let regularAttributedString = NSAttributedString(string: "By booking your appointment through WellnessWrx you confirm that you accept our ", attributes: regularAttribute)
        let boldAttributedString = NSAttributedString(string: "Terms of Use", attributes: boldAttribute)
        mutableAttributedString.append(regularAttributedString)
        mutableAttributedString.append(boldAttributedString)
        TermsLab.attributedText = mutableAttributedString
        
      //  txtUsername.underLineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      //  txtPassword.underLineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        UsernameView.clipsToBounds = true
        UsernameView.layer.borderWidth = 1.0
        UsernameView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        PasswordView.clipsToBounds = true
        PasswordView.layer.borderWidth = 1.0
        PasswordView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
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
        
        self.txtUsername.inputAccessoryView = doneToolbar
        self.txtPassword.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    
    
    // MARK:  Terms of Use
    
    func TermsConditions() -> Void
    {
        popview.isHidden=false
        footerView.isHidden=false
        
        popview.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview.backgroundColor=UIColor(patternImage: UIImage(named: "BGM")!)
        self.view.addSubview(popview)
        
        footerView.frame = CGRect(x:10, y:40, width:popview.frame.size.width-20, height:popview.frame.size.height-80)
        footerView.backgroundColor = UIColor.white
        popview.addSubview(footerView)
        
        let Headview = UIView()
        Headview.frame = CGRect(x:0, y:0, width:footerView.frame.size.width, height:50)
        Headview.backgroundColor=#colorLiteral(red: 0.3333333333, green: 0.2, blue: 0.5450980392, alpha: 1)
        footerView.addSubview(Headview)
        
        let titlelab = UILabel()
        titlelab.frame = CGRect(x:Headview.frame.size.width/2-100, y:5, width:200, height:40)
        titlelab.text="Terms and Conditions"
        titlelab.font =  UIFont(name:"Helvetica-Bold", size: 18)
        titlelab.textColor=UIColor.white
        titlelab.textAlignment = .center
        Headview.addSubview(titlelab)
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:Headview.frame.size.width-35, y:15, width:25, height:25)
        crossbutt.setImage( UIImage.init(named: "CircleCross"), for: .normal)
        crossbutt.addTarget(self, action: #selector(self.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:Headview.frame.size.width-50, y:0, width:50, height:50)
        crossbutt2.addTarget(self, action: #selector(self.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt2)
        
        termsView.frame = CGRect(x:0, y:50, width:footerView.frame.size.width, height:footerView.frame.size.height-50)
        termsView.delegate = self
        termsView.backgroundColor=UIColor.white
        footerView.addSubview(termsView)
        //let htmlString: String = "<font face='Times New Roman' size='3'>\(htmlstring)"
        let url = NSURL (string: "https://wellnesswrx.ca/terms-of-use/")
        var requestObj = URLRequest(url: url! as URL)
        requestObj.cachePolicy = .returnCacheDataElseLoad
       // termsView.isUserInteractionEnabled = false
        termsView.loadRequest(requestObj);
       // termsView.loadHTMLString(htmlstring, baseURL: nil)
    }
    
    // MARK:  UIWebView Delegates
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        AFWrapperClass.svprogressHudDismiss(view: self)
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.fontFamily =\"-apple-system\"")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        AFWrapperClass.svprogressHudDismiss(view: self)
    }
    
    // MARK:  WebView Delegate Methods.
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
    
    
    
    func CloseButtonAction(_ sender: UIButton!)
    {
        popview.isHidden=true
        footerView.isHidden=true
    }
    
    
    
     // MARK:  ForgotPassword Butt Clicked
    
    @IBAction func ForgotPasswordButtClicked(_ sender: UIButton)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    // MARK:  LogIn Butt Clicked
    
    @IBAction func LogInButtClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        var message = String()
        if (txtUsername.text?.isEmpty)!
        {
            message = "Please Enter User Name"
        }
        else if !AFWrapperClass.isValidEmail(txtUsername.text!)
        {
            message = "Please Enter Proper UserName (Email Id)"
        }
        else if (txtPassword.text?.isEmpty)!
        {
            message = "Please Enter Password"
        }
        
        if message.count > 1
        {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
            if UserDefaults.standard.object(forKey: "DeviceToken") != nil
            {
                DeviceToken=UserDefaults.standard.object(forKey: "DeviceToken") as! String
            }
            else
            {
                DeviceToken = "1452645231"
            }
            
            self.LoginAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"user_login") , params: "email=\(txtUsername.text!)&password=\(txtPassword.text!)&device_id=\(DeviceToken)&device_type=\(DeviceType)")
        }
    }
    
    @objc private   func LoginAPIMethod (baseURL:String , params: String)
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
    
    // MARK:  Privacy Butt Clicked
    
    @IBAction func PrivacyButtClicked(_ sender: UIButton)
    {
        TermsConditions()
    }
    
    // MARK:  SignIn Butt Clicked
    
    @IBAction func SignInButtClicked(_ sender: UIButton)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    // MARK:  Textfield End Editing
    
    @IBAction func endEditingTextField()
    {
        if txtUsername.becomeFirstResponder() {
            txtUsername.endEditing(true)
        } else {
            txtPassword.endEditing(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

