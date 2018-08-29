//
//  MorePlusViewController.swift
//  Wellness
//
//  Created by think360 on 09/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class MorePlusViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SecondDelegate {
    
    @IBOutlet weak var SearchItemBar: UISearchBar!
    @IBOutlet weak var SearchItemTabl: UITableView!
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    
    var MoreCatArray = NSMutableArray()
     var strtest = String()
    
    var encodeUrl = String()
    
     var SuggestionlistArray : NSMutableArray = ["Car Rental","Fitness Center","Health Food Store","Juices","Pharmacy","Restaurants"]

    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
        SearchItemBar.isHidden = true
        
        if let data = UserDefaults.standard.data(forKey: "NewPlace"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Place]
        {
            currentLatitude = (info.last?.Currentlat)!
            currentLongitude = (info.last?.CurrentLong)!
            
            print(currentLatitude)
            print(currentLongitude)
        }
        else
        {
            print("There is an issue")
        }
        
        SearchItemTabl.tableFooterView = UIView()
        self.addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.SearchItemBar.inputAccessoryView = doneToolbar
    }
    
    
    func doneButtonAction()
    {
        SearchItemBar?.resignFirstResponder()
        SearchItemBar.text = ""
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
        self.classObject.checkLoginStatus()
    }
    
    
    
    // MARK:  Back Butt Clicked
    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        if strtest == "1"
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as? TabsViewController
            self.navigationController?.pushViewController(myVC!, animated: true)
        }
        else
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK:  Searchbar Delegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        SearchItemBar?.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        if let cancelButton = SearchItemBar.value(forKey: "cancelButton") as? UIButton
        {
            cancelButton.isEnabled = true
        }
        
        let strlat = "\(currentLatitude)"
        let strlong = "\(currentLongitude)"
        
        let str = searchBar.text
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        if let escapedString = str?.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            encodeUrl = escapedString
        }
        
        self.ListItemsAPIMethod(baseURL: String(format:"%@%@?category_id=%@&text=%@&lat=%@&long=%@",Constants.mainURL,"product_list","",encodeUrl,strlat,strlong))
        
    }
    
    
    // MARK:  TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MoreCatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let CellIdentifier1 = "Cell1"
        var Cell: UITableViewCell?
        Cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier1)
        if Cell == nil {
            Cell = UITableViewCell(style: .default, reuseIdentifier: CellIdentifier1)
        }
        
        Cell?.selectionStyle = UITableViewCellSelectionStyle.none
        SearchItemTabl.separatorStyle = .none
        SearchItemTabl.separatorColor = UIColor.clear
        Cell?.accessoryView = ALCustomColoredAccessory(color: UIColor.gray, type: ALCustomColoredAccessoryTypeRight)

        Cell?.textLabel?.text = (MoreCatArray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "title") as? String
        
        return Cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let strlat = "\(currentLatitude)"
//        let strlong = "\(currentLongitude)"
//
//        let strSearchText = SuggestionlistArray.object(at: indexPath.row) as? String
//
//        let str = strSearchText
//        var encodeUrl = String()
//        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
//        if let escapedString = str?.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
//            encodeUrl = escapedString
//        }
//
//         self.ListItemsAPIMethod(baseURL: String(format:"%@%@?category_id=%@&text=%@&lat=%@&long=%@",Constants.mainURL,"product_list","",encodeUrl,strlat,strlong))
        
        let str = (MoreCatArray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "url") as? String
        
        guard let url = URL(string: str!) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
        
    }
    
    @objc private   func ListItemsAPIMethod (baseURL:String)
    {
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryItemlistViewController") as? CategoryItemlistViewController
                    myVC?.CategorylistArray = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "product") as? NSMutableArray)!
                    if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? NSNumber
                    {
                        myVC?.strPage = String(describing: quantity)
                    }
                    else if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? String
                    {
                        myVC?.strPage = quantity
                    }
                    myVC?.strSearchtxt = self.SearchItemBar.text!
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
