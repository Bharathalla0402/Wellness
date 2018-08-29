//
//  SearchLocationViewController.swift
//  Wellness
//
//  Created by think360 on 09/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class SearchLocationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SecondDelegate {
    
    @IBOutlet weak var LocationView: UIView!
    @IBOutlet weak var LocationName: UILabel!
    
    @IBOutlet weak var SearchItemBar: UISearchBar!
    @IBOutlet weak var SearchItemTabl: UITableView!
    @IBOutlet weak var SearchItemTablConstant: NSLayoutConstraint!
    @IBOutlet weak var SuggestionTabl: UITableView!
    @IBOutlet weak var SuggestionTablConstant: NSLayoutConstraint!
    
    @IBOutlet weak var LocationNameHeightConstant: NSLayoutConstraint!
    
    var SearchItemlistArray : NSMutableArray = ["Alberta","Nunavut"]
    var SuggestionlistArray : NSMutableArray = ["Manitoba","New Brunswick","Newfoundland and Labrador","Northwest Territories","Nova Scotia","Nunavut"]
    
    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
        LocationNameHeightConstant.constant = self.view.frame.size.width - 120

         SearchItemTabl.tableFooterView = UIView()
         SuggestionTabl.tableFooterView = UIView()
        SearchItemTablConstant.constant = CGFloat((SearchItemlistArray.count)*50)
        SuggestionTablConstant.constant = CGFloat((SuggestionlistArray.count)*50)
        
        // Do any additional setup after loading the view.
        
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
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    // MARK:  CurrentlocationButtClicked
    
    @IBAction func CurrentlocationButtClicked(_ sender: UIButton)
    {
        
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
        
    }
    
    
    // MARK:  TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == SearchItemTabl
        {
            return SearchItemlistArray.count
        }
        else
        {
            return SuggestionlistArray.count
        }
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
        SuggestionTabl.separatorStyle = .none
        SuggestionTabl.separatorColor = UIColor.clear
        
        if tableView == SearchItemTabl
        {
            Cell?.textLabel?.text = SearchItemlistArray.object(at: indexPath.row) as? String
        }
        else
        {
            Cell?.textLabel?.text = SuggestionlistArray.object(at: indexPath.row) as? String
        }
        return Cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag == 2
        {
          
        }
        else
        {
            
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
