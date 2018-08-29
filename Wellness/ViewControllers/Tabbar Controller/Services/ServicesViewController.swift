//
//  ServicesViewController.swift
//  Wellness
//
//  Created by think360 on 06/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlacePicker

class CategoryItemsCell: UITableViewCell
{
    @IBOutlet weak var CategoryName: UILabel!
    
}

class ServicesViewController: UIViewController,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,SecondDelegate {
    
      var locationManager = CLLocationManager()
    
    @IBOutlet var NoDataLab: UILabel!
    @IBOutlet weak var TopViewHeight: NSLayoutConstraint!
    @IBOutlet weak var LocationView: UIView!
    @IBOutlet weak var LocationName: UILabel!
    @IBOutlet weak var SearchItemBar: UISearchBar!
    
    @IBOutlet weak var ServiceName: UILabel!
    @IBOutlet weak var ServicesSegment: UISegmentedControl!
    @IBOutlet weak var CategoryTabl: UITableView!
    
    var Cell:CategoryItemsCell!
    var currentLatitude = Double()
    var currentLongitude = Double()
    
    var myArray = NSDictionary()
    var strUserID = String()
    
    var strPlaceCheck = String()
    
    var EmotionalCatArray = NSMutableArray()
    var MentalCatArray = NSMutableArray()
    var PhysicalCatArray = NSMutableArray()
    var SpiritualCatArray = NSMutableArray()
    var strCategoryId = String()
     var StrCategoryTypeName = String()
    
    var strSearchText = String()
    var strPage = String()
    
    var classObject = MultipartViewController()
    
    var val:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServicesSegment.setTitle("", forSegmentAt: 0)
        ServicesSegment.setTitle("", forSegmentAt: 1)
        ServicesSegment.setTitle("", forSegmentAt: 2)
        ServicesSegment.setTitle("", forSegmentAt: 3)
        
        NoDataLab.isHidden = true
        
        classObject.delegate = self
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationReceived(_:)), name: NSNotification.Name(rawValue: "CatSelected"), object: nil)
        
      //  let Decode = UserDefaults.standard.object(forKey: "name") as? Data
      //  var info = NSKeyedUnarchiver.unarchiveObject(with: Decode!) as? Place

         strPlaceCheck = "1" // for view will appear check condition if click place selction
        
        if let data = UserDefaults.standard.data(forKey: "NewPlace"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Place]
        {
            LocationName.text = info.last?.name
            currentLatitude = (info.last?.Currentlat)!
            currentLongitude = (info.last?.CurrentLong)!
            
            print(currentLatitude)
            print(currentLongitude)
        }
        else
        {
            print("There is an issue")
        }
        
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
       
        
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
               TopViewHeight.constant = 23
            default:
                TopViewHeight.constant = 0
            }
        }
        
        CategoryTabl.rowHeight = UITableViewAutomaticDimension
        CategoryTabl.estimatedRowHeight = 51
        CategoryTabl.tableFooterView = UIView()
        CategoryTabl.tag = 1
        
        ServiceName.text = ""
       
        // Do any additional setup after loading the view.
    }
    
    
    // MARK:  Handle Notification
    
    func NotificationReceived(_ notification: NSNotification)
    {
        if let CatId = notification.userInfo?["CatId"] as? Int
        {
            if CatId == 0
            {
                if let data = UserDefaults.standard.data(forKey: "Category"),
                    let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
                {
                    ServiceName.text = (info.last?.EmotionalName)!
                }
                ServicesSegment.selectedSegmentIndex = 0
                CategoryTabl.tag = 1
                CategoryTabl.reloadData()
            }
            else if CatId == 1
            {
                if let data = UserDefaults.standard.data(forKey: "Category"),
                    let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
                {
                    ServiceName.text = (info.last?.MentalName)!
                }
                ServicesSegment.selectedSegmentIndex = 1
                CategoryTabl.tag = 2
                CategoryTabl.reloadData()
            }
            else if CatId == 2
            {
                if let data = UserDefaults.standard.data(forKey: "Category"),
                    let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
                {
                    ServiceName.text = (info.last?.PhysicalName)!
                }
                ServicesSegment.selectedSegmentIndex = 2
                CategoryTabl.tag = 3
                CategoryTabl.reloadData()
            }
            else if CatId == 3
            {
                if let data = UserDefaults.standard.data(forKey: "Category"),
                    let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
                {
                    ServiceName.text = (info.last?.SpiritualName)!
                }
                ServicesSegment.selectedSegmentIndex = 3
                CategoryTabl.tag = 4
                CategoryTabl.reloadData()
            }
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
       // AFWrapperClass.svprogressHudDismiss(view: self)
        
         self.CategoryItemList()
    }
    
    // MARK:  View Will Appear
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
         NoDataLab.isHidden = true
        
        
        if strPlaceCheck == "2"
        {
             strPlaceCheck = "1"
        }
        else
        {
            if let data = UserDefaults.standard.data(forKey: "NewPlace"),
                let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Place]
            {
                LocationName.text = info.last?.name
                currentLatitude = (info.last?.Currentlat)!
                currentLongitude = (info.last?.CurrentLong)!
            }
            else
            {
                
                locationManager.delegate=self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                
                
                if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
                {
                    if let lat = self.locationManager.location?.coordinate.latitude {
                        currentLatitude = lat
                        
                    }else {
                        
                    }
                    
                    if let long = self.locationManager.location?.coordinate.longitude {
                        currentLongitude = long
                    }else {
                        
                    }
                }
                if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
                }else{
                    let alertController = UIAlertController(title: "Wellness", message: "Location services are disabled in your App settings Please enable the Location Settings. Click Ok to go to Location Settings.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                        // UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                        alertController.dismiss(animated: true, completion: nil)
                    })
                    // let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    // alertController.addAction(cancelAction)
                    alertController.addAction(defaultAction)
                    present(alertController, animated: true, completion: nil)
                }
                
                self.locationmethod()
                
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: "NewPlace"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Place]
        {
            LocationName.text = info.last?.name
            currentLatitude = (info.last?.Currentlat)!
            currentLongitude = (info.last?.CurrentLong)!
        }
        
        // multipul lines for UISegmented control
        
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        
        ServicesSegment.tintColor = #colorLiteral(red: 0.5317639112, green: 0.7401891947, blue: 0.3162800372, alpha: 1)
        
        if self.view.frame.size.width == 320.0
        {
            let attributes = [NSForegroundColorAttributeName : #colorLiteral(red: 0.5317639112, green: 0.7401891947, blue: 0.3162800372, alpha: 1),
                              NSFontAttributeName : UIFont.systemFont(ofSize: 14)] as [String : Any];
           
            ServicesSegment.setTitleTextAttributes(attributes, for: .normal)
        }
        else
        {
            let attributes = [NSForegroundColorAttributeName : #colorLiteral(red: 0.5317639112, green: 0.7401891947, blue: 0.3162800372, alpha: 1),
                              NSFontAttributeName : UIFont.systemFont(ofSize: 16)] as [String : Any];
            
            ServicesSegment.setTitleTextAttributes(attributes, for: .normal)
        }
        
       
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        classObject.checkLoginStatus()
       
    }
    
    

    func locationmethod () -> Void
    {
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            if let lat = self.locationManager.location?.coordinate.latitude {
                currentLatitude = lat
                
            }else {
                
            }
            
            if let long = self.locationManager.location?.coordinate.longitude {
                currentLongitude = long
                
            }else {
                
            }
            self.setUsersClosestCity()
        }
        else
        {
            //  print("location method2")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.locationmethod()
            }
        }
    }
    
    // MARK:  User Current Location
    
    func setUsersClosestCity()
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        
        
        
//        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
//        let apikey = "AIzaSyAFhk1Wyc6H_13J-e2JxhTH26vb9ivVj7U"
//        
//        let url = NSURL(string: "\(baseUrl)latlng=\(currentLatitude),\(currentLongitude)&key=\(apikey)")
//        let data = NSData(contentsOf: url! as URL)
//        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
//        if let result = json["results"] as? NSArray
//        {
//            if let address = (result.object(at: 0) as? NSDictionary)?.value(forKey: "address_components") as? NSArray
//            {
//                
//                for i in 0..<address.count
//                {
//                    let strname = ((address.object(at: i) as! NSDictionary).value(forKey: "types") as? NSArray)?.object(at: 0) as? String
//                    
//                    if strname == "postal_code"
//                    {
//                        // self.StrZipCode = ((address.object(at: i) as! NSDictionary).value(forKey: "short_name") as? String)!
//                    }
//                    
//                }
//                // print(self.StrZipCode)
//            }
//            
//        }
        
        
        
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            // Print each key-value pair in a new row
            addressDict.forEach { print($0) }
            
            
            let str = addressDict["City"] as? String ?? ""
            let str2 = addressDict["SubAdministrativeArea"] as? String ?? ""
            
            if str == ""
            {
                if str2 == ""
                {
                    
                }
                else
                {
                    self.LocationName.text = str2
                }
            }
            else
            {
                self.LocationName.text = str
            }
            
            
            
            let newcoordinates = Place(name: self.LocationName.text!, Address: "", Currentlat: self.currentLatitude, CurrentLong: self.currentLongitude)
            var newPlace = [Place]()
            newPlace.append(newcoordinates)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: newPlace)
            UserDefaults.standard.set(encodedData, forKey: "NewPlace")
            
            //  self.StrCountryName = addressDict["Country"] as? String ?? ""
            //  self.StrStateName = addressDict["State"] as? String ?? ""
            //  self.StrCityName = addressDict["City"] as? String ?? ""
            //  self.StrCountryCode = addressDict["CountryCode"] as? String ?? ""
            //   self.StrStateCode = addressDict["State"] as? String ?? ""
            
        })
    }
    
    // MARK:  Loading CategoryItems
    
    func CategoryItemList ()
    {
        if let data = UserDefaults.standard.data(forKey: "Category"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
        {
            if UserDefaults.standard.object(forKey: "Tab") != nil
            {
                let strval: String = (UserDefaults.standard.object(forKey: "Tab") as? String)!
                val = Int(strval)!
            }
            
            
            
            let strEmotionalId: String = (info.last?.EmotionalId)!
            print(strEmotionalId)
            self.EmotionalAPIMethod(baseURL: String(format:"%@%@?category_id=%@",Constants.mainURL,"category",strEmotionalId))
            
            let strmentalId: String = (info.last?.MentalId)!
            print(strmentalId)
            self.MentalAPIMethod(baseURL: String(format:"%@%@?category_id=%@",Constants.mainURL,"category",strmentalId))
            
            let strPhysicalId: String = (info.last?.PhysicalId)!
            print(strPhysicalId)
            self.PhysicalAPIMethod(baseURL: String(format:"%@%@?category_id=%@",Constants.mainURL,"category",strPhysicalId))
            
            let strSpiritualId: String = (info.last?.SpiritualId)!
            print(strSpiritualId)
            self.SpiritualAPIMethod(baseURL: String(format:"%@%@?category_id=%@",Constants.mainURL,"category",strSpiritualId))
            
            ServicesSegment.setTitle((info.last?.EmotionalName)!, forSegmentAt: 0)
            ServicesSegment.setTitle((info.last?.MentalName)!, forSegmentAt: 1)
            ServicesSegment.setTitle((info.last?.PhysicalName)!, forSegmentAt: 2)
            ServicesSegment.setTitle((info.last?.SpiritualName)!, forSegmentAt: 3)
            
            
            if UserDefaults.standard.object(forKey: "Tab") != nil
            {
                let strval: String = (UserDefaults.standard.object(forKey: "Tab") as? String)!
                let intval = Int(strval)
                
                if intval == 0
                {
                    ServiceName.text = (info.last?.EmotionalName)!
                    ServicesSegment.selectedSegmentIndex = 0
                    CategoryTabl.tag = 1
                    CategoryTabl.reloadData()
                }
                else if intval == 1
                {
                    ServiceName.text = (info.last?.MentalName)!
                    ServicesSegment.selectedSegmentIndex = 1
                    CategoryTabl.tag = 2
                    CategoryTabl.reloadData()
                }
                else if intval == 2
                {
                    ServiceName.text = (info.last?.PhysicalName)!
                    ServicesSegment.selectedSegmentIndex = 2
                    CategoryTabl.tag = 3
                    CategoryTabl.reloadData()
                }
                else if intval == 3
                {
                    ServiceName.text = (info.last?.SpiritualName)!
                    ServicesSegment.selectedSegmentIndex = 3
                    CategoryTabl.tag = 4
                    CategoryTabl.reloadData()
                }
                UserDefaults.standard.removeObject(forKey: "Tab")
            }
            else
            {
                if val == 0
                {
                    ServiceName.text = (info.last?.EmotionalName)!
                }
                else if val == 1
                {
                     ServiceName.text = (info.last?.MentalName)!
                }
                else if val == 2
                {
                    ServiceName.text = (info.last?.PhysicalName)!
                }
                else if val == 3
                {
                    ServiceName.text = (info.last?.SpiritualName)!
                }
               
            }
            
          
        }
        else
        {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            classObject.checkLoginStatus()
        }
    }
    
    
    //Category API
    
    @objc private   func EmotionalAPIMethod (baseURL:String)
    {
        if self.EmotionalCatArray.count == 0
        {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.EmotionalCatArray = (responceDic.object(forKey: "data") as? NSMutableArray)!
                    self.CategoryTabl.reloadData()
                }
                else
                {
                    
                    if self.val == 0
                    {
                        self.NoDataLab.isHidden = false
                    }
                    else
                    {
                        self.NoDataLab.isHidden = true
                    }
                        
//                        var str2 = String()
//                        if let data = UserDefaults.standard.data(forKey: "Category"),
//                            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
//                        {
//                            str2 = (info.last?.EmotionalName)!
//                        }
//                        let str1 = "Request Data Not found for "
//                        let strmassage = str1+str2
//                        AFWrapperClass.svprogressHudDismiss(view: self)
//                        AFWrapperClass.alert(Constants.applicationName, message: strmassage, view: self)
                    
                }
            }
            
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    @objc private   func MentalAPIMethod (baseURL:String)
    {
        if self.MentalCatArray.count == 0
        {
             AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.MentalCatArray = (responceDic.object(forKey: "data") as? NSMutableArray)!
                    self.CategoryTabl.reloadData()
                }
                else
                {
                    if self.val == 1
                    {
                        self.NoDataLab.isHidden = false
                    }
                    else
                    {
                        self.NoDataLab.isHidden = true
                    }
                    
//                    var str2 = String()
//                    if let data = UserDefaults.standard.data(forKey: "Category"),
//                        let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
//                    {
//                        str2 = (info.last?.MentalName)!
//                    }
//                    let str1 = "Request Data Not found for "
//                    let strmassage = str1+str2
//                    AFWrapperClass.svprogressHudDismiss(view: self)
//                    AFWrapperClass.alert(Constants.applicationName, message: strmassage, view: self)
                }
            }
            
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    @objc private   func PhysicalAPIMethod (baseURL:String)
    {
        if self.PhysicalCatArray.count == 0
        {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.PhysicalCatArray = (responceDic.object(forKey: "data") as? NSMutableArray)!
                    self.CategoryTabl.reloadData()
                }
                else
                {
                    if self.val == 2
                    {
                        self.NoDataLab.isHidden = false
                    }
                    else
                    {
                        self.NoDataLab.isHidden = true
                    }
                    
//                    var str2 = String()
//                    if let data = UserDefaults.standard.data(forKey: "Category"),
//                        let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
//                    {
//                        str2 = (info.last?.PhysicalName)!
//                    }
//                    let str1 = "Request Data Not found for "
//                    let strmassage = str1+str2
//                    AFWrapperClass.svprogressHudDismiss(view: self)
//                    AFWrapperClass.alert(Constants.applicationName, message: strmassage, view: self)
                }
            }
            
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    @objc private   func SpiritualAPIMethod (baseURL:String)
    {
        if self.SpiritualCatArray.count == 0
        {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.SpiritualCatArray = (responceDic.object(forKey: "data") as? NSMutableArray)!
                    self.CategoryTabl.reloadData()
                }
                else
                {
                    if self.val == 3
                    {
                        self.NoDataLab.isHidden = false
                    }
                    else
                    {
                        self.NoDataLab.isHidden = true
                    }
                    
//                    var str2 = String()
//                    if let data = UserDefaults.standard.data(forKey: "Category"),
//                        let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
//                    {
//                        str2 = (info.last?.SpiritualName)!
//                    }
//                    let str1 = "Request Data Not found for "
//                    let strmassage = str1+str2
//                    AFWrapperClass.svprogressHudDismiss(view: self)
//                    AFWrapperClass.alert(Constants.applicationName, message: strmassage, view: self)
                }
            }
            
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    
    
    
    // MARK:  Location Butt Clicked
    
    @IBAction func LocationButtClicked(_ sender: UIButton)
    {
        strPlaceCheck = "2"
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // MARK:  SearchButt Clicked
    
    @IBAction func SearchButtClicked(_ sender: UIButton)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchSortItemViewController") as? SearchSortItemViewController
        myVC?.strSearchType = "2"
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    
    // MARK:  SegmentValue Changed
    
    @IBAction func SegmentValChanged(_ sender: UISegmentedControl)
    {
        if ServicesSegment.selectedSegmentIndex == 0
        {
            val = 0
            if let data = UserDefaults.standard.data(forKey: "Category"),
                let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
            {
                 ServiceName.text = (info.last?.EmotionalName)!
            }
            // ServiceName.text = "Emotional Wellness"
             ServicesSegment.selectedSegmentIndex = 0
             CategoryTabl.tag = 1
             CategoryTabl.reloadData()
            
            if EmotionalCatArray.count == 0
            {
                NoDataLab.isHidden = false
            }
            else
            {
                NoDataLab.isHidden = true
            }
        }
        else if ServicesSegment.selectedSegmentIndex == 1
        {
            val = 1
            if let data = UserDefaults.standard.data(forKey: "Category"),
                let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
            {
                ServiceName.text = (info.last?.MentalName)!
            }
            // ServiceName.text = "Mental Wellness"
             ServicesSegment.selectedSegmentIndex = 1
             CategoryTabl.tag = 2
             CategoryTabl.reloadData()
            
            if MentalCatArray.count == 0
            {
                NoDataLab.isHidden = false
            }
            else
            {
                NoDataLab.isHidden = true
            }
        }
        else if ServicesSegment.selectedSegmentIndex == 2
        {
            val = 2
            if let data = UserDefaults.standard.data(forKey: "Category"),
                let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
            {
                ServiceName.text = (info.last?.PhysicalName)!
            }
            // ServiceName.text = "Physical Wellness"
             ServicesSegment.selectedSegmentIndex = 2
             CategoryTabl.tag = 3
             CategoryTabl.reloadData()
            
            if PhysicalCatArray.count == 0
            {
                NoDataLab.isHidden = false
            }
            else
            {
                NoDataLab.isHidden = true
            }
        }
        else if ServicesSegment.selectedSegmentIndex == 3
        {
            val = 3
            if let data = UserDefaults.standard.data(forKey: "Category"),
                let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category]
            {
                ServiceName.text = (info.last?.SpiritualName)!
            }
           //  ServiceName.text = "Spiritual Wellness"
             ServicesSegment.selectedSegmentIndex = 3
             CategoryTabl.tag = 4
             CategoryTabl.reloadData()
            
            if SpiritualCatArray.count == 0
            {
                NoDataLab.isHidden = false
            }
            else
            {
                NoDataLab.isHidden = true
            }
        }
    }
    
    
    
    // MARK:  TableView Delegate Methods
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 1
        {
           return self.EmotionalCatArray.count
        }
        else if tableView.tag == 2
        {
            return self.MentalCatArray.count
        }
        else if tableView.tag == 3
        {
            return self.PhysicalCatArray.count
        }
        else
        {
            return self.SpiritualCatArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "CategoryItemsCell"
        Cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CategoryItemsCell
        if Cell == nil
        {
            tableView.register(UINib(nibName: "CategoryItemsCell", bundle: nil), forCellReuseIdentifier: identifier)
            Cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CategoryItemsCell
        }
        Cell.selectionStyle = UITableViewCellSelectionStyle.none
        CategoryTabl.separatorStyle = .none
        CategoryTabl.separatorColor = UIColor.clear
        
        if tableView.tag == 1
        {
            Cell.CategoryName.text = (self.EmotionalCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
        }
        else if tableView.tag == 2
        {
            Cell.CategoryName.text = (self.MentalCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
        }
        else if tableView.tag == 3
        {
            Cell.CategoryName.text = (self.PhysicalCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
        }
        else
        {
            Cell.CategoryName.text = (self.SpiritualCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
        }
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag == 1
        {
            StrCategoryTypeName = (self.EmotionalCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
            
            if let quantity = (self.EmotionalCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? NSNumber
            {
                strCategoryId = String(describing: quantity)
            }
            else if let quantity = (self.EmotionalCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
            {
                strCategoryId = quantity
            }
        }
        else if tableView.tag == 2
        {
            StrCategoryTypeName = (self.MentalCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
            
            if let quantity = (self.MentalCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? NSNumber
            {
                strCategoryId = String(describing: quantity)
            }
            else if let quantity = (self.MentalCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
            {
                strCategoryId = quantity
            }
        }
        else if tableView.tag == 3
        {
            StrCategoryTypeName = (self.PhysicalCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
            
            if let quantity = (self.PhysicalCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? NSNumber
            {
                strCategoryId = String(describing: quantity)
            }
            else if let quantity = (self.PhysicalCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
            {
                strCategoryId = quantity
            }
        }
        else
        {
            StrCategoryTypeName = (self.SpiritualCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
            
            if let quantity = (self.SpiritualCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? NSNumber
            {
                strCategoryId = String(describing: quantity)
            }
            else if let quantity = (self.SpiritualCatArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
            {
                strCategoryId = quantity
            }
        }
        
        let strlat = "\(currentLatitude)"
        let strlong = "\(currentLongitude)"
        
        
        self.ListItemsAPIMethod(baseURL: String(format:"%@%@?category_id=%@&lat=%@&long=%@",Constants.mainURL,"product_list",strCategoryId,strlat,strlong))
    }
    
    @objc private   func ListItemsAPIMethod (baseURL:String)
    {
        self.view.isUserInteractionEnabled = false
        print(baseURL)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.view.isUserInteractionEnabled = true
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
                    myVC?.strSearchType = "2"
                    myVC?.strCategoryId = self.strCategoryId
                    myVC?.StrCategoryTypeName = self.StrCategoryTypeName
                    self.navigationController?.pushViewController(myVC!, animated: true)
                }
                else
                {
                    self.view.isUserInteractionEnabled = true
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                }
            }
            
        })
        { (error) in
             self.view.isUserInteractionEnabled = true
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

extension ServicesViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        LocationName.text = place.name
        currentLatitude=place.coordinate.latitude
        currentLongitude=place.coordinate.longitude
        
        print(currentLatitude)
        print(currentLongitude)
        
        let newcoordinates = Place(name: self.LocationName.text!, Address: "", Currentlat: self.currentLatitude, CurrentLong: self.currentLongitude)
        var newPlace = [Place]()
        newPlace.append(newcoordinates)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: newPlace)
        UserDefaults.standard.set(encodedData, forKey: "NewPlace")
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}



