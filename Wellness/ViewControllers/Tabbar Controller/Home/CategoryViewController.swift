//
//  CategoryViewController.swift
//  Wellness
//
//  Created by think360 on 09/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlacePicker

class CategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate,SecondDelegate {
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var LocationView: UIView!
    @IBOutlet weak var LocationName: UILabel!
    @IBOutlet weak var SearchItemBar: UISearchBar!
    @IBOutlet weak var CategoryTypeName: UILabel!
    @IBOutlet weak var CategoryTabl: UITableView!
    @IBOutlet weak var CategoryNameHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var LocationNameHeightConstant: NSLayoutConstraint!
    
     var CategorylistArray = NSMutableArray()
    
    var StrCategoryType = String()
    
    var myArray = NSDictionary()
    var strUserID = String()
    
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    
    var strPlaceCheck = String()

    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
        LocationNameHeightConstant.constant = self.view.frame.size.width - 120

        // Do any additional setup after loading the view.
        
         strPlaceCheck = "1" // for view will appear check condition if click place selction
        
        
        if StrCategoryType == "1"
        {
            CategoryTypeName.text = "      Emotional"
            CategorylistArray = ["Medical Cannabis Clinics","Phychologist","Naturopath","Nutritional Counselling","NLP","Psychotherapy","Yoga"]
        }
        else if StrCategoryType == "2"
        {
             CategoryTypeName.text = "      Mental"
            CategorylistArray = ["Phychologist","Naturopath","Nutritional Counselling","NLP","Psychotherapy","Yoga"]
        }
        else if StrCategoryType == "3"
        {
            CategoryTypeName.text = "      Physical"
            CategorylistArray = ["Acupunture","Bowen Technique","Carniosacral Therapy","Fitness","Homeopath","Iridology","Martial Arts","Naturopath","Nutritional Counselling","NLP","Psychotherapy","Yoga"]
        }
        else if StrCategoryType == "4"
        {
             CategoryTypeName.text = "      Spiritual"
             CategorylistArray = ["Reiki","Yoga"]
        }
        
        CategoryTabl.tableFooterView = UIView()
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
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        self.classObject.checkLoginStatus()
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
    
    
    
    
    // MARK:  Back Butt Clicked
    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
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
        self.navigationController?.pushViewController(myVC!, animated: false)
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
        return CategorylistArray.count
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
        CategoryTabl.separatorStyle = .none
        CategoryTabl.separatorColor = UIColor.clear
        Cell?.accessoryView = ALCustomColoredAccessory(color: UIColor.gray, type: ALCustomColoredAccessoryTypeRight)
        
        
        Cell?.textLabel?.text = CategorylistArray.object(at: indexPath.row) as? String
        
        return Cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryItemlistViewController") as? CategoryItemlistViewController
        myVC?.StrCategoryTypeName = (CategorylistArray.object(at: indexPath.row) as? String)!
        self.navigationController?.pushViewController(myVC!, animated: true)
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

extension CategoryViewController: GMSAutocompleteViewControllerDelegate {
    
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



