//
//  SuccessPaymentViewController.swift
//  Wellness
//
//  Created by think360 on 13/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class SuccessPaymentViewController: UIViewController,SecondDelegate {

    var StrOrderId = String()
    @IBOutlet weak var OrderLab: UILabel!
    
    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
        let str1 = "Your session has been book, (#"
        let str2 = ")"
        
         OrderLab.text = str1+StrOrderId+str2
        

        // Do any additional setup after loading the view.
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
        
      //  AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
      //  classObject.checkLoginStatus()
    }
    
    
    //MARK: Return to Home Butt Clicked
    
    @IBAction func ReturnHomeButtClicked(_ sender: UIButton)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as? TabsViewController
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    //MARK: More Sage Clicked
    
    @IBAction func MoreSageButtClicked(_ sender: UIButton)
    {
         self.ProfessionalAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"professional_services"))
    }
    
    @objc private   func ProfessionalAPIMethod (baseURL:String)
    {
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MorePlusViewController") as? MorePlusViewController
                    myVC?.hidesBottomBarWhenPushed = true
                    myVC?.MoreCatArray = (responceDic.object(forKey: "data") as? NSMutableArray)!
                    myVC?.strtest = "1"
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
