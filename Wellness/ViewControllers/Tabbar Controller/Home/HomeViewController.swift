//
//  HomeViewController.swift
//  Wellness
//
//  Created by think360 on 06/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlacePicker
import SDWebImage

class PopularCell: UICollectionViewCell
{
    @IBOutlet weak var ProductImage: UIImageView!
    @IBOutlet weak var Productname: UILabel!
    @IBOutlet weak var Producttype: UILabel!
    @IBOutlet weak var ProductRating: UILabel!
    @IBOutlet weak var BookButt: UIButton!
}


class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,CLLocationManagerDelegate,SecondDelegate {

    var locationManager = CLLocationManager()
    @IBOutlet weak var HomeScrool: UIScrollView!
    
    @IBOutlet weak var LocationView: UIView!
    @IBOutlet weak var LocationName: UILabel!
    @IBOutlet weak var SearchItemBar: UISearchBar!
    
    @IBOutlet weak var ItemViewHeight: NSLayoutConstraint!
    @IBOutlet weak var EmotionalView: UIView!
    @IBOutlet weak var EmotionalImage: UIImageView!
    @IBOutlet weak var EmotionalLab: UILabel!
    @IBOutlet weak var MentalView: UIView!
    @IBOutlet weak var MentalImage: UIImageView!
    @IBOutlet weak var MentalLab: UILabel!
    @IBOutlet weak var PhysicalView: UIView!
    @IBOutlet weak var PhysicalImage: UIImageView!
    @IBOutlet weak var PhysicalLab: UILabel!
    @IBOutlet weak var SpiritualView: UIView!
    @IBOutlet weak var SpiritualImage: UIImageView!
    
    @IBOutlet weak var SpiritualLab: UILabel!
    
    @IBOutlet weak var CollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var LocationNameHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var PopularProviderCollectionView: UICollectionView!
    var cell: PopularCell!
    
    var PopularItems = NSMutableArray()
    var StrCategoryBookingId = String()
    
    var myArray = NSDictionary()
    var strUserID = String()
    
 
    var currentLatitude = Double()
    var currentLongitude = Double()
    
    var strPlaceCheck = String()
    var strProductId = String()
     var strProductname = String()
    
    var x: Int = 0
    var a:Float = 1.0
    
    @IBOutlet weak var LeftImage: UIImageView!
    @IBOutlet weak var RightImage: UIImageView!
    @IBOutlet weak var LeftButt: UIButton!
    @IBOutlet weak var RightButt: UIButton!
    
    
    var classObject = MultipartViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.EmotionalLab.text = ""
        self.MentalLab.text = ""
        self.PhysicalLab.text = ""
        self.SpiritualLab.text = ""
        
        self.EmotionalImage.image = nil
        self.MentalImage.image = nil
        self.PhysicalImage.image = nil
        self.SpiritualImage.image = nil
        
        classObject.delegate = self
        
        self.LeftImage.isHidden = true
        self.LeftButt.isHidden = true
        self.RightImage.isHidden = true
        self.RightButt.isHidden = true
        
        LocationNameHeightConstant.constant = self.view.frame.size.width - 120
        
        strPlaceCheck = "1" // for view will appear check condition if click place selction
        
        UserDefaults.standard.set("Login", forKey: "UserLogin")
        
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
        
        ItemViewHeight.constant = self.view.frame.size.width
        
        EmotionalView.clipsToBounds = true
        EmotionalView.layer.borderWidth = 0.5
        EmotionalView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        MentalView.clipsToBounds = true
        MentalView.layer.borderWidth = 0.5
        MentalView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        PhysicalView.clipsToBounds = true
        PhysicalView.layer.borderWidth = 0.5
        PhysicalView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        SpiritualView.clipsToBounds = true
        SpiritualView.layer.borderWidth = 0.5
        SpiritualView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

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
        
        if strPlaceCheck == "2"
        {
             strPlaceCheck = "1"
        }
        else
        {
          //  UserDefaults.standard.set("first", forKey: "Collection")
            
            self.DashboardAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"dashboard"))
        
            if let data = UserDefaults.standard.data(forKey: "NewPlace"),
                let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Place]
            {
                print(info.last?.name as Any)
                print(info.last?.Currentlat as Any)
                print(info.last?.CurrentLong as Any)
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
                
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
//
//                    if self.PopularItems.count > 0
//                    {
//                        let str1 = (self.PopularItems.object(at: 0) as! NSDictionary).object(forKey: "name") as? String ?? ""
//                        let str2 = (self.PopularItems.object(at: 0) as! NSDictionary).object(forKey: "vandor") as? String ?? ""
//
//                        let font = UIFont(name: "Helvetica", size: 16.0)
//                        let font2 = UIFont(name: "Helvetica", size: 15.0)
//                        let height = self.heightForView(text: str1, font: font!, width: self.view.frame.size.width-111)
//                        let height2 = self.heightForView(text: str2, font: font2!, width: self.view.frame.size.width-111)
//
//                        self.CollectionViewHeight.constant = height+height2+123
//                    }
//
//                    let bottomOffset = CGPoint(x: 0, y: self.HomeScrool.contentSize.height - self.HomeScrool.bounds.size.height)
//                    self.HomeScrool.setContentOffset(bottomOffset, animated: true)
//                }
                
            }
        }
        
        
        if let data = UserDefaults.standard.data(forKey: "NewPlace"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Place]
        {
            LocationName.text = info.last?.name
            currentLatitude = (info.last?.Currentlat)!
            currentLongitude = (info.last?.CurrentLong)!
        }
        
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
//

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

    //Dashboard API
    
    @objc private   func DashboardAPIMethod (baseURL:String)
    {
        print(baseURL)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            DispatchQueue.main.async {
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.PopularItems = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "product") as? NSMutableArray)!
                    
                    self.PopularProviderCollectionView.reloadData()
                    
                    let ProductCategory:NSArray = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "category") as? NSArray)!
                    
                    
                      var str5 = String()
                    let ProDic1:NSDictionary = (ProductCategory.object(at: 0) as? NSDictionary)!
                    let imageURL: String = ProDic1.object(forKey: "image") as? String ?? ""
                    if imageURL == ""
                    {
                        self.EmotionalImage.image = UIImage(named: "Placeholder")
                    }
                    else
                    {
                        let url = NSURL(string:imageURL)
                        self.EmotionalImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
                    }
                    str5 = ProDic1.object(forKey: "name") as? String ?? ""
                    self.EmotionalLab.text = ProDic1.object(forKey: "name") as? String ?? ""
                    
                    
                    var str6 = String()
                    let ProDic2:NSDictionary = (ProductCategory.object(at: 1) as? NSDictionary)!
                    let imageURL2: String = ProDic2.object(forKey: "image") as? String ?? ""
                    if imageURL2 == ""
                    {
                        self.MentalImage.image = UIImage(named: "Placeholder")
                    }
                    else
                    {
                        let url = NSURL(string:imageURL2)
                        self.MentalImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
                    }
                    str6 = ProDic2.object(forKey: "name") as? String ?? ""
                    self.MentalLab.text = ProDic2.object(forKey: "name") as? String ?? ""
                    
                    var str7 = String()
                    let ProDic3:NSDictionary = (ProductCategory.object(at: 2) as? NSDictionary)!
                    let imageURL3: String = ProDic3.object(forKey: "image") as? String ?? ""
                    if imageURL3 == ""
                    {
                        self.PhysicalImage.image = UIImage(named: "Placeholder")
                    }
                    else
                    {
                        let url = NSURL(string:imageURL3)
                        self.PhysicalImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
                    }
                    str7 = ProDic3.object(forKey: "name") as? String ?? ""
                    self.PhysicalLab.text = ProDic3.object(forKey: "name") as? String ?? ""
                    
                    var str8 = String()
                    let ProDic4:NSDictionary = (ProductCategory.object(at: 3) as? NSDictionary)!
                    let imageURL4: String = ProDic4.object(forKey: "image") as? String ?? ""
                    if imageURL4 == ""
                    {
                        self.SpiritualImage.image = UIImage(named: "Placeholder")
                    }
                    else
                    {
                        let url = NSURL(string:imageURL4)
                        self.SpiritualImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
                    }
                    str8 = ProDic4.object(forKey: "name") as? String ?? ""
                    self.SpiritualLab.text = ProDic4.object(forKey: "name") as? String ?? ""
                    
                    
                    
                    var str1 = String()
                    if let quantity = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "category") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "id") as? NSNumber
                    {
                        str1 = String(describing: quantity)
                    }
                    else if let quantity = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "category") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "id") as? String
                    {
                        str1 = quantity
                    }
                    
                    
                    var str2 = String()
                    if let quantity = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "category") as? NSMutableArray)?.object(at: 1) as? NSDictionary)?.value(forKey: "id") as? NSNumber
                    {
                        str2 = String(describing: quantity)
                    }
                    else if let quantity = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "category") as? NSMutableArray)?.object(at: 1) as? NSDictionary)?.value(forKey: "id") as? String
                    {
                        str2 = quantity
                    }
                    
                    
                    var str3 = String()
                    if let quantity = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "category") as? NSMutableArray)?.object(at: 2) as? NSDictionary)?.value(forKey: "id") as? NSNumber
                    {
                        str3 = String(describing: quantity)
                    }
                    else if let quantity = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "category") as? NSMutableArray)?.object(at: 2) as? NSDictionary)?.value(forKey: "id") as? String
                    {
                        str3 = quantity
                    }
                    
                    
                    var str4 = String()
                    if let quantity = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "category") as? NSMutableArray)?.object(at: 3) as? NSDictionary)?.value(forKey: "id") as? NSNumber
                    {
                        str4 = String(describing: quantity)
                    }
                    else if let quantity = (((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "category") as? NSMutableArray)?.object(at: 3) as? NSDictionary)?.value(forKey: "id") as? String
                    {
                        str4 = quantity
                    }
                    
                    
                    
                    let newcategory = Category(EmotionalId: str1, MentalId: str2,  PhysicalId: str3,  SpiritualId: str4, EmotionalName: str5, MentalName: str6,  PhysicalName: str7,  SpiritualName: str8)
                    var newCategory = [Category]()
                    newCategory.append(newcategory)
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: newCategory)
                    UserDefaults.standard.set(encodedData, forKey: "Category")
                    
                    
                    if self.PopularItems.count == 1 || self.PopularItems.count == 0
                    {
                        self.LeftImage.isHidden = true
                        self.LeftButt.isHidden = true
                        self.RightImage.isHidden = true
                        self.RightButt.isHidden = true
                    }
                    else
                    {
                        self.LeftImage.isHidden = true
                        self.LeftButt.isHidden = true
                        self.RightImage.isHidden = false
                        self.RightButt.isHidden = false
                    }
                    
                    self.x = 0
                    
                    if self.PopularItems.count == 0
                    {
                        self.LeftImage.isHidden = true
                        self.LeftButt.isHidden = true
                        
                        
                        self.RightImage.isHidden = true
                        self.RightButt.isHidden = true
                    }
                    else
                    {
                         self.PopularProviderCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
                    }
                   
                    
                    AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                    self.classObject.checkLoginStatus()
                }
                else
                {
                    AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                    self.classObject.checkLoginStatus()
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
      //  self.view.endEditing(true)
       // let navigationController = UINavigationController(rootViewController: searchViewController)
       // present(navigationController, animated: true, completion: { _ in })
        
       // let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchLocationViewController") as? SearchLocationViewController
       // self.navigationController?.pushViewController(myVC!, animated: false)
        
        strPlaceCheck = "2"
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
     // MARK:  Plus Butt Clicked
    
    @IBAction func PlusButtClicked(_ sender: UIButton)
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
    
     // MARK:  SearchButt Clicked
    
    @IBAction func SearchButtClicked(_ sender: UIButton)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchSortItemViewController") as? SearchSortItemViewController
        myVC?.strSearchType = "1"
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    
     // MARK:  Searchbar Delegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
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
    

    
    // MARK:  Emotional Butt Clicked
    
    @IBAction func EmotionalButtClicked(_ sender: UIButton)
    {
       // let myVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
      //  myVC?.StrCategoryType = "1"
      //  myVC?.hidesBottomBarWhenPushed = true
      //  self.navigationController?.pushViewController(myVC!, animated: true)
        
        _ = self.tabBarController?.selectedIndex = 1
        let imageDataDict:[String: Int] = ["CatId": 0]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CatSelected"), object: nil, userInfo: imageDataDict)
        UserDefaults.standard.setValue("0", forKey: "Tab")
    }
    
    // MARK:  Mental Butt Clicked
    
    @IBAction func MentalButtClicked(_ sender: UIButton)
    {
        _ = self.tabBarController?.selectedIndex = 1
        let imageDataDict:[String: Int] = ["CatId": 1]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CatSelected"), object: nil, userInfo: imageDataDict)
         UserDefaults.standard.setValue("1", forKey: "Tab")
    }
    
    // MARK:  Physical Butt Clicked
    
    @IBAction func PhysicalButtClicked(_ sender: UIButton)
    {
        _ = self.tabBarController?.selectedIndex = 1
        let imageDataDict:[String: Int] = ["CatId": 2]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CatSelected"), object: nil, userInfo: imageDataDict)
         UserDefaults.standard.setValue("2", forKey: "Tab")
    }
    
    // MARK:  Spiritual Butt Clicked
    
    @IBAction func SpiritualButtClicked(_ sender: UIButton)
    {
        _ = self.tabBarController?.selectedIndex = 1
        let imageDataDict:[String: Int] = ["CatId": 3]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CatSelected"), object: nil, userInfo: imageDataDict)
         UserDefaults.standard.setValue("3", forKey: "Tab")
    }
    
    // MARK:  Collection View Delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.PopularItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
//        if UserDefaults.standard.object(forKey: "Collection") != nil
//        {
//            if indexPath.row == self.PopularItems.count-1
//            {
//                let str1 = (self.PopularItems.object(at: 0) as! NSDictionary).object(forKey: "name") as? String ?? ""
//                let str2 = (self.PopularItems.object(at: 0) as! NSDictionary).object(forKey: "vandor") as? String ?? ""
//
//                let font = UIFont(name: "Helvetica", size: 16.0)
//                let font2 = UIFont(name: "Helvetica", size: 14.0)
//                let height = heightForView(text: str1, font: font!, width: self.view.frame.size.width-111)
//                let height2 = heightForView(text: str2, font: font2!, width: self.view.frame.size.width-111)
//
//                CollectionViewHeight.constant = height+height2+123
//
//                UserDefaults.standard.removeObject(forKey: "Collection")
//
//                return CGSize(width: self.PopularProviderCollectionView.frame.size.width , height: height+height2+123)
//            }
//            else
//            {
//                let str1 = (self.PopularItems.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
//                let str2 = (self.PopularItems.object(at: indexPath.row) as! NSDictionary).object(forKey: "vandor") as? String ?? ""
//
//                let font = UIFont(name: "Helvetica", size: 16.0)
//                let font2 = UIFont(name: "Helvetica", size: 14.0)
//                let height = heightForView(text: str1, font: font!, width: self.view.frame.size.width-111)
//                let height2 = heightForView(text: str2, font: font2!, width: self.view.frame.size.width-111)
//
//                CollectionViewHeight.constant = height+height2+123
//
//                return CGSize(width: self.PopularProviderCollectionView.frame.size.width , height: height+height2+123)
//            }
//        }
//        else
//        {
//            let str1 = (self.PopularItems.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
//            let str2 = (self.PopularItems.object(at: indexPath.row) as! NSDictionary).object(forKey: "vandor") as? String ?? ""
//
//            let font = UIFont(name: "Helvetica", size: 16.0)
//            let font2 = UIFont(name: "Helvetica", size: 14.0)
//            let height = heightForView(text: str1, font: font!, width: self.view.frame.size.width-111)
//            let height2 = heightForView(text: str2, font: font2!, width: self.view.frame.size.width-111)
//
//            CollectionViewHeight.constant = height+height2+123
//
//            return CGSize(width: self.PopularProviderCollectionView.frame.size.width , height: height+height2+123)
//        }
        
        
         return CGSize(width: self.PopularProviderCollectionView.frame.size.width , height: 160)
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath) as! PopularCell
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 4.0
        
        let imageURL: String = (self.PopularItems.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as? String ?? ""
        if imageURL == "" || imageURL == "0"
        {
            cell.ProductImage.image = UIImage(named: "Placeholder")
        }
        else
        {
            let url = NSURL(string:imageURL)
            cell.ProductImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
        }
        
         cell.Productname.text = (self.PopularItems.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
         cell.Producttype.text = (self.PopularItems.object(at: indexPath.row) as! NSDictionary).object(forKey: "vandor") as? String ?? ""
        
        if let quantity = (self.PopularItems.object(at: indexPath.row) as! NSDictionary).object(forKey: "rating") as? NSNumber
        {
            cell.ProductRating.text = String(describing: quantity)
        }
        else if let quantity = (self.PopularItems.object(at: indexPath.row) as! NSDictionary).object(forKey: "rating") as? String
        {
            cell.ProductRating.text = quantity
        }
        
        cell.BookButt.tag = indexPath.row
        cell.BookButt.addTarget(self, action: #selector(self.BookButtClicked), for: .touchUpInside)
        
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CollectionViewRightSwipped))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CollectionViewLeftSwipped))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
      //  let TapButt : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CollectionViewTapped))
      //  TapButt.numberOfTapsRequired = 1
        
     
        
        cell.addGestureRecognizer(swipeLeft)
        cell.addGestureRecognizer(swipeRight)
       // cell.addGestureRecognizer(TapButt)
      

        return cell
    }
    
    func CollectionViewTapped()
    {
        if let quantity = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "id") as? NSNumber
        {
            strProductId = String(describing: quantity)
        }
        else if let quantity = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "id") as? String
        {
            strProductId = quantity
        }
        
        self.ProductDetailsAPIMethod(baseURL: String(format:"%@%@?product_id=%@",Constants.mainURL,"product_detail",strProductId))
    
    }
    
   
    
    @objc private   func ProductDetailsAPIMethod (baseURL:String)
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
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailCategoryViewController") as? DetailCategoryViewController
                    myVC?.hidesBottomBarWhenPushed = true
                    myVC?.ProductDetail = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "product") as? NSDictionary)!
                    let strimage = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "product") as? NSDictionary)?.object(forKey: "image") as? String ?? ""
                    let imageArray = NSMutableArray()
                    imageArray.add(strimage)
                    myVC?.imagesArray = imageArray
                    myVC?.strProductId = self.strProductId
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
    
    
    
    func CollectionViewLeftSwipped()
    {
        a=1.0
        if self.x == 0
        {
            if self.PopularItems.count == 1 || self.PopularItems.count == 0
            {
                self.LeftImage.isHidden = true
                self.LeftButt.isHidden = true
                self.RightImage.isHidden = true
                self.RightButt.isHidden = true
            }
            else
            {
                self.LeftImage.isHidden = true
                self.LeftButt.isHidden = true
                self.RightImage.isHidden = false
                self.RightButt.isHidden = false
            }
        }
        else if self.x > 0
        {
            self.LeftImage.isHidden = false
            self.LeftButt.isHidden = false
            self.RightImage.isHidden = false
            self.RightButt.isHidden = false
            
            self.x = self.x - 1
            let indexPath = IndexPath(item: x, section: 0)
            self.PopularProviderCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            
            let str1 = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "name") as? String ?? ""
            let str2 = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "vandor") as? String ?? ""
            
            let font = UIFont(name: "Helvetica", size: 16.0)
            let font2 = UIFont(name: "Helvetica", size: 15.0)
            let height = self.heightForView(text: str1, font: font!, width: self.view.frame.size.width-111)
            let height2 = self.heightForView(text: str2, font: font2!, width: self.view.frame.size.width-111)
            
            // self.CollectionViewHeight.constant = height+height2+123
            
            let bottomOffset = CGPoint(x: 0, y: self.HomeScrool.contentSize.height - self.HomeScrool.bounds.size.height)
            self.HomeScrool.setContentOffset(bottomOffset, animated: true)
            
            if self.x == 0
            {
                if self.PopularItems.count == 1 || self.PopularItems.count == 0
                {
                    self.LeftImage.isHidden = true
                    self.LeftButt.isHidden = true
                    self.RightImage.isHidden = true
                    self.RightButt.isHidden = true
                }
                else
                {
                    self.LeftImage.isHidden = true
                    self.LeftButt.isHidden = true
                    self.RightImage.isHidden = false
                    self.RightButt.isHidden = false
                }
            }
        }
    }
    
    func CollectionViewRightSwipped()
    {
        if self.PopularItems.count == 1
        {
            
        }
        else
        {
        
        a=1.0
        if self.x < self.PopularItems.count
        {
            let count: Int = self.PopularItems.count-1
            
            if self.x == count
            {
                self.LeftImage.isHidden = false
                self.LeftButt.isHidden = false
                self.RightImage.isHidden = true
                self.RightButt.isHidden = true
            }
            else
            {
                self.x = self.x + 1
                let indexPath = IndexPath(item: x, section: 0)
                self.PopularProviderCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                
                let str1 = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "name") as? String ?? ""
                let str2 = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "vandor") as? String ?? ""
                
                let font = UIFont(name: "Helvetica", size: 16.0)
                let font2 = UIFont(name: "Helvetica", size: 15.0)
                let height = self.heightForView(text: str1, font: font!, width: self.view.frame.size.width-111)
                let height2 = self.heightForView(text: str2, font: font2!, width: self.view.frame.size.width-111)
                
                
                if self.x == count
                {
                    self.LeftImage.isHidden = false
                    self.LeftButt.isHidden = false
                    self.RightImage.isHidden = true
                    self.RightButt.isHidden = true
                }
                else
                {
                    self.LeftImage.isHidden = false
                    self.LeftButt.isHidden = false
                    self.RightImage.isHidden = false
                    self.RightButt.isHidden = false
                }
                
                //  self.CollectionViewHeight.constant = height+height2+123
            }
            
        }
        else
        {
            self.x = 0
            self.PopularProviderCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
            
            let str1 = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "name") as? String ?? ""
            let str2 = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "vandor") as? String ?? ""
            
            let font = UIFont(name: "Helvetica", size: 16.0)
            let font2 = UIFont(name: "Helvetica", size: 15.0)
            let height = self.heightForView(text: str1, font: font!, width: self.view.frame.size.width-111)
            let height2 = self.heightForView(text: str2, font: font2!, width: self.view.frame.size.width-111)
            
            if self.x == 0
            {
                if self.PopularItems.count == 1 || self.PopularItems.count == 0
                {
                    self.LeftImage.isHidden = true
                    self.LeftButt.isHidden = true
                    self.RightImage.isHidden = true
                    self.RightButt.isHidden = true
                }
                else
                {
                    self.LeftImage.isHidden = true
                    self.LeftButt.isHidden = true
                    self.RightImage.isHidden = false
                    self.RightButt.isHidden = false
                }
            }
            
            // self.CollectionViewHeight.constant = height+height2+123
        }
        
        let bottomOffset = CGPoint(x: 0, y: self.HomeScrool.contentSize.height - self.HomeScrool.bounds.size.height)
        self.HomeScrool.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    @IBAction func LeftButtClicked(_ sender: UIButton)
    {
        a=1.0
        if self.x == 0
        {
            if self.PopularItems.count == 1 || self.PopularItems.count == 0
            {
                self.LeftImage.isHidden = true
                self.LeftButt.isHidden = true
                self.RightImage.isHidden = true
                self.RightButt.isHidden = true
            }
            else
            {
                self.LeftImage.isHidden = true
                self.LeftButt.isHidden = true
                self.RightImage.isHidden = false
                self.RightButt.isHidden = false
            }
        }
        else if self.x > 0
        {
            self.LeftImage.isHidden = false
            self.LeftButt.isHidden = false
            self.RightImage.isHidden = false
            self.RightButt.isHidden = false
            
            self.x = self.x - 1
            let indexPath = IndexPath(item: x, section: 0)
            self.PopularProviderCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            
            let str1 = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "name") as? String ?? ""
            let str2 = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "vandor") as? String ?? ""
            
            let font = UIFont(name: "Helvetica", size: 16.0)
            let font2 = UIFont(name: "Helvetica", size: 15.0)
            let height = self.heightForView(text: str1, font: font!, width: self.view.frame.size.width-111)
            let height2 = self.heightForView(text: str2, font: font2!, width: self.view.frame.size.width-111)
            
            // self.CollectionViewHeight.constant = height+height2+123
            
            let bottomOffset = CGPoint(x: 0, y: self.HomeScrool.contentSize.height - self.HomeScrool.bounds.size.height)
            self.HomeScrool.setContentOffset(bottomOffset, animated: true)
            
            if self.x == 0
            {
                if self.PopularItems.count == 1 || self.PopularItems.count == 0
                {
                    self.LeftImage.isHidden = true
                    self.LeftButt.isHidden = true
                    self.RightImage.isHidden = true
                    self.RightButt.isHidden = true
                }
                else
                {
                    self.LeftImage.isHidden = true
                    self.LeftButt.isHidden = true
                    self.RightImage.isHidden = false
                    self.RightButt.isHidden = false
                }
            }
        }
    }
    
    @IBAction func RightButtClicked(_ sender: UIButton)
    {
        a=1.0
        if self.x < self.PopularItems.count
        {
            let count: Int = self.PopularItems.count-1
            
            if self.x == count
            {
                self.LeftImage.isHidden = false
                self.LeftButt.isHidden = false
                self.RightImage.isHidden = true
                self.RightButt.isHidden = true
            }
            else
            {
                self.x = self.x + 1
                let indexPath = IndexPath(item: x, section: 0)
                self.PopularProviderCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                
                let str1 = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "name") as? String ?? ""
                let str2 = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "vandor") as? String ?? ""
                
                let font = UIFont(name: "Helvetica", size: 16.0)
                let font2 = UIFont(name: "Helvetica", size: 15.0)
                let height = self.heightForView(text: str1, font: font!, width: self.view.frame.size.width-111)
                let height2 = self.heightForView(text: str2, font: font2!, width: self.view.frame.size.width-111)
                
                
                if self.x == count
                {
                    self.LeftImage.isHidden = false
                    self.LeftButt.isHidden = false
                    self.RightImage.isHidden = true
                    self.RightButt.isHidden = true
                }
                else
                {
                    self.LeftImage.isHidden = false
                    self.LeftButt.isHidden = false
                    self.RightImage.isHidden = false
                    self.RightButt.isHidden = false
                }
                
                //  self.CollectionViewHeight.constant = height+height2+123
            }
            
        }
        else
        {
            self.x = 0
            self.PopularProviderCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
            
            let str1 = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "name") as? String ?? ""
            let str2 = (self.PopularItems.object(at: self.x) as! NSDictionary).object(forKey: "vandor") as? String ?? ""
            
            let font = UIFont(name: "Helvetica", size: 16.0)
            let font2 = UIFont(name: "Helvetica", size: 15.0)
            let height = self.heightForView(text: str1, font: font!, width: self.view.frame.size.width-111)
            let height2 = self.heightForView(text: str2, font: font2!, width: self.view.frame.size.width-111)
            
            if self.x == 0
            {
                if self.PopularItems.count == 1 || self.PopularItems.count == 0
                {
                    self.LeftImage.isHidden = true
                    self.LeftButt.isHidden = true
                    self.RightImage.isHidden = true
                    self.RightButt.isHidden = true
                }
                else
                {
                    self.LeftImage.isHidden = true
                    self.LeftButt.isHidden = true
                    self.RightImage.isHidden = false
                    self.RightButt.isHidden = false
                }
            }
            
            // self.CollectionViewHeight.constant = height+height2+123
        }
        
        let bottomOffset = CGPoint(x: 0, y: self.HomeScrool.contentSize.height - self.HomeScrool.bounds.size.height)
        self.HomeScrool.setContentOffset(bottomOffset, animated: true)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        strProductname = (self.PopularItems.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
        
        if let quantity = (self.PopularItems.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? NSNumber
        {
            strProductId = String(describing: quantity)
        }
        else if let quantity = (self.PopularItems.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
        {
            strProductId = quantity
        }
    
    
        let strlat = "\(currentLatitude)"
        let strlong = "\(currentLongitude)"
    
    
        self.ListItemsAPIMethod(baseURL: String(format:"%@%@?category_id=%@&lat=%@&long=%@",Constants.mainURL,"product_list",strProductId,strlat,strlong))
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
                   // myVC?.strSearchType = "2"
                    myVC?.strCategoryId = self.strProductId
                    myVC?.StrCategoryTypeName = self.strProductname
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
    
    
    //MARK: Book Butt Clicked
    
    @IBAction func BookButtClicked(_ sender: UIButton)
    {
        if let quantity = (self.PopularItems.object(at: sender.tag) as! NSDictionary).object(forKey: "category_parent") as? NSNumber
        {
            strProductId = String(describing: quantity)
        }
        else if let quantity = (self.PopularItems.object(at: sender.tag) as! NSDictionary).object(forKey: "category_parent") as? String
        {
            strProductId = quantity
        }

        
        
        let strlat = "\(currentLatitude)"
        let strlong = "\(currentLongitude)"
        
        self.ViewAllListItemsAPIMethod(baseURL: String(format:"%@%@?category_id=%@",Constants.mainURL,"category",strProductId))
    }
    
    @objc private   func ViewAllListItemsAPIMethod (baseURL:String)
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
                    self.view.isUserInteractionEnabled = true
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AllProvidersViewController") as? AllProvidersViewController
                    myVC?.CategorylistArray = (responceDic.object(forKey: "data")as? NSMutableArray)!
                    if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? NSNumber
                    {
                        myVC?.strPage = String(describing: quantity)
                    }
                    else if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? String
                    {
                        myVC?.strPage = quantity
                    }
                    // myVC?.strSearchType = "2"
                    myVC?.strCategoryId = self.strProductId
                    myVC?.StrCategoryTypeName = "Providers"
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

//extension HomeViewController: ABCGooglePlacesSearchViewControllerDelegate {
//
//    func searchViewController(_ controller: ABCGooglePlacesSearchViewController, didReturn place: ABCGooglePlace)
//    {
//        LocationName.text = place.name
//        currentLatitude=place.location.coordinate.latitude
//        currentLongitude=place.location.coordinate.longitude
//
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
//
//
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
//                       // self.StrZipCode = ((address.object(at: i) as! NSDictionary).value(forKey: "short_name") as? String)!
//                    }
//
//                }
//               // print(self.StrZipCode)
//            }
//
//        }
//
//
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
//            guard let addressDict = placemarks?[0].addressDictionary else {
//                return
//            }
//
//            // Print each key-value pair in a new row
//            addressDict.forEach { print($0) }
//
//            print(addressDict)
//
//           // self.StrCountryName = addressDict["Country"] as? String ?? ""
//          //  self.StrStateName = addressDict["State"] as? String ?? ""
//          //  self.StrCityName = addressDict["City"] as? String ?? ""
//          //  self.StrCountryCode = addressDict["CountryCode"] as? String ?? ""
//          //  self.StrStateCode = addressDict["State"] as? String ?? ""
//
//        })
//    }
//}


extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    
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
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error)
    {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController)
    {
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


