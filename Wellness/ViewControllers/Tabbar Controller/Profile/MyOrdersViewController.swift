//
//  MyOrdersViewController.swift
//  Wellness
//
//  Created by think360 on 21/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class MyOrderCell: UITableViewCell
{
    @IBOutlet weak var OrderImage: UIImageView!
    @IBOutlet weak var OrderStoreName: UILabel!
    @IBOutlet weak var OrderSellerName: UILabel!
    @IBOutlet weak var OrderDate: UILabel!
    
}

class MyOrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SecondDelegate {

    @IBOutlet weak var OrderTabl: UITableView!
    var Cell:MyOrderCell!
    
    var OrderArray = NSMutableArray()
    
    var OrderId = String()
    var strPage = String()
    
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

        // Do any additional setup after loading the view.
        
        OrderTabl.rowHeight = UITableViewAutomaticDimension
        OrderTabl.estimatedRowHeight = 123
        OrderTabl.tableFooterView = UIView()
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
        return OrderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "MyOrderCell"
        Cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyOrderCell
        if Cell == nil
        {
            tableView.register(UINib(nibName: "MyOrderCell", bundle: nil), forCellReuseIdentifier: identifier)
            Cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyOrderCell
        }
        Cell.selectionStyle = UITableViewCellSelectionStyle.none
        OrderTabl.separatorStyle = .none
        OrderTabl.separatorColor = UIColor.clear
        
        let imageURL: String = (((self.OrderArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "image") as? String ?? ""
        if imageURL == "" || imageURL == "0"
        {
            Cell.OrderImage.image = UIImage(named: "Placeholder")
        }
        else
        {
            let url = NSURL(string:imageURL)
            Cell.OrderImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
        }
        
        Cell.OrderStoreName.text = (((self.OrderArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "name") as? String ?? ""
        Cell.OrderSellerName.text = (((self.OrderArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "product") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "vandor") as? String ?? ""
        
      
        let strDate = (self.OrderArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_date") as? String ?? ""
        let str = "Order Date : "
        Cell.OrderDate.text = str+strDate
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if let quantity = (self.OrderArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_id") as? NSNumber
        {
            OrderId = String(describing: quantity)
        }
        else if let quantity = (self.OrderArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_id") as? String
        {
            OrderId = quantity
        }
        
        self.UserOrderDetailsAPIMethod(baseURL: String(format:"%@%@?user_id=%@&order_id=%@",Constants.mainURL,"user_order_detail",strUserID,OrderId))
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
            if (strPage == "0") {
                //  loadLbl.text = "No More List"
                //  actInd.stopAnimating()
            }
            else if (strPage == "") {
                //  loadLbl.text = "No More List"
                //  actInd.stopAnimating()
            }
            else
            {
                let baseURL: String  =  String(format:"%@%@?user_id=%@&order_type=2&page=%@",Constants.mainURL,"user_order",strUserID,self.strPage)
                
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
                       
                            }
                            else
                            {
                               self.responsewithToken7(responceDic)
                            }
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
        arr = ((responseDict.object(forKey: "data") as? NSDictionary)?.object(forKey: "order") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.OrderArray.addObjects(from: arr as [AnyObject])
        
        if let quantity = ((responseDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? NSNumber
        {
            self.strPage = String(describing: quantity)
            
        }
        else if let quantity = ((responseDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? String
        {
            self.strPage = quantity
        }
        
        OrderTabl.reloadData()
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
