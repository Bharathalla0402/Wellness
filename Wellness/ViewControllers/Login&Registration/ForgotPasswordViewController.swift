//
//  ForgotPasswordViewController.swift
//  Wellness
//
//  Created by think360 on 05/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import RaisePlaceholder

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var txtEmail: ACFloatingTextfield!
   // @IBOutlet weak var txtEmail: RaisePlaceholder!
    @IBOutlet weak var BackButt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailView.clipsToBounds = true
        EmailView.layer.borderWidth = 1.0
        EmailView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

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
        
        self.txtEmail.inputAccessoryView = doneToolbar
    }
    
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
     // MARK:  Back Butt Clicked
    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:  Submit Butt Clicked
    
    @IBAction func SubmitButtClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        var message = String()
        if (txtEmail.text?.isEmpty)!
        {
            message = "Please Enter Email Id"
        }
        else if !AFWrapperClass.isValidEmail(txtEmail.text!)
        {
            message = "Please Enter Proper Email Id"
        }
        
        if message.characters.count > 1
        {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
            self.ForgotAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"forget_password") , params: "email=\(txtEmail.text!)")
        }
    }
    
    @objc private   func ForgotAPIMethod (baseURL:String , params: String)
    {
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    let optionMenu = UIAlertController(title: "Wellness", message: responceDic.object(forKey: "message") as? String, preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "Ok", style: .default, handler:
                    {(alert: UIAlertAction!) -> Void in
                       self.navigationController?.popViewController(animated: true)
                    })
                    optionMenu.addAction(confirmAction)
                    self.present(optionMenu, animated: true, completion: nil)
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
