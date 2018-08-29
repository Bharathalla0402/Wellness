//
//  SearchSortItemViewController.swift
//  Wellness
//
//  Created by think360 on 09/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class SearchtextCell: UITableViewCell
{
    @IBOutlet weak var SearchItem: UILabel!
    
}


class SearchSortItemViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SecondDelegate {

    @IBOutlet weak var SearchItemBar: UISearchBar!
    @IBOutlet weak var SortTabl: UITableView!
    @IBOutlet weak var SearchTabl: UITableView!
    
    @IBOutlet weak var SearchTablHeight: NSLayoutConstraint!
    var strSearchText = String()
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    
     var encodeUrl = String()
    
     var SortlistArray : NSMutableArray = ["Closest to me","Price High-Low","Price Low-High"]
    
    var strSort = String()
    var strSearchType = String()
    
    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
        SearchTablHeight.constant = 0
        
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

        // Do any additional setup after loading the view.
         SortTabl.tableFooterView = UIView()
        SearchItemBar.showsCancelButton = true
        
        if let cancelButton = SearchItemBar.value(forKey: "cancelButton") as? UIButton
        {
             cancelButton.isEnabled = true
        }
       
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
        if let cancelButton = SearchItemBar.value(forKey: "cancelButton") as? UIButton
        {
            cancelButton.isEnabled = true
        }
        
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
         searchBar.setShowsCancelButton(true, animated: true)
        
        if let cancelButton = SearchItemBar.value(forKey: "cancelButton") as? UIButton
        {
            cancelButton.isEnabled = true
        }
        
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        SearchItemBar?.resignFirstResponder()
          _ = self.navigationController?.popViewController(animated: false)
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
        return SortlistArray.count
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
        SortTabl.separatorStyle = .none
        SortTabl.separatorColor = UIColor.clear
   
        Cell?.textLabel?.text = SortlistArray.object(at: indexPath.row) as? String
        
        return Cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let strlat = "\(currentLatitude)"
        let strlong = "\(currentLongitude)"
        
        if indexPath.row == 0
        {
            strSort = "%5B%22location%22%2C%22ASC%22%5D"
            self.ListItemsAPIMethod(baseURL: String(format:"%@%@?category_id=%@&text=%@&lat=%@&long=%@&sort=%@",Constants.mainURL,"product_list","",strSearchText,strlat,strlong,strSort))
        }
        else if indexPath.row == 1
        {
            strSort = "%5B%22price%22%2C%22DESC%22%5D"
            self.ListItemsAPIMethod(baseURL: String(format:"%@%@?category_id=%@&text=%@&lat=%@&long=%@&sort=%@",Constants.mainURL,"product_list","",strSearchText,strlat,strlong,strSort))
        }
        else if indexPath.row == 2
        {
            strSort = "%5B%22price%22%2C%22ASC%22%5D"
            self.ListItemsAPIMethod(baseURL: String(format:"%@%@?category_id=%@&text=%@&lat=%@&long=%@&sort=%@",Constants.mainURL,"product_list","",strSearchText,strlat,strlong,strSort))
        }
    }
    

    @objc private   func ListItemsAPIMethod (baseURL:String)
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
                    myVC?.strSort = self.strSort
                    myVC?.strSearchtxt = self.SearchItemBar.text!
                    myVC?.strSearchType = self.strSearchType
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
