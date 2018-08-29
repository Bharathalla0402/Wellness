//
//  CategoryItemlistViewController.swift
//  Wellness
//
//  Created by think360 on 12/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlacePicker

class ItemlistCell: UITableViewCell
{
    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var ItemStoreName: UILabel!
    @IBOutlet weak var ItemUserName: UILabel!
    @IBOutlet weak var ItemRating: FloatRatingView!
    @IBOutlet weak var ItemPrice: UILabel!
    @IBOutlet var ItemDiscountPrice: UILabel!
    @IBOutlet var LayoutDistanceHeight: NSLayoutConstraint!
    @IBOutlet var DiscountPrice: UILabel!
}

class CategoryItemlistViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate,SecondDelegate  {

    var locationManager = CLLocationManager()
    
    @IBOutlet weak var LocationView: UIView!
    @IBOutlet weak var LocationName: UILabel!
    @IBOutlet weak var SearchItemBar: UISearchBar!
    @IBOutlet weak var CategoryTypeName: UILabel!
    @IBOutlet weak var CategoryTabl: UITableView!
    @IBOutlet weak var CategoryNameHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var LocationNameHeightConstant: NSLayoutConstraint!
    
    var Cell:ItemlistCell!
    var CategorylistArray = NSMutableArray()
    var strPage = String()
    var strSort = String()
    var strSearchtxt = String()
    var strCategoryId = String()
    var strSearchType = String()
    
    var StrCategoryTypeName = String()
    
    var myArray = NSDictionary()
    var strUserID = String()
    
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    
    var strPlaceCheck = String()
    
    var strProductId = String()
    
    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
        LocationNameHeightConstant.constant = self.view.frame.size.width - 120
        
         strPlaceCheck = "1" // for view will appear check condition if click place selction
        
        if StrCategoryTypeName == ""
        {
           CategoryNameHeightConstant.constant = 0
        }
        else
        {
            let str1 = "      "
            CategoryTypeName.text = str1+StrCategoryTypeName
        }
        
        
        
        
        if let data = UserDefaults.standard.data(forKey: "NewPlace"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Place]
        {
            LocationName.text = info.last?.name
            currentLatitude = (info.last?.Currentlat)!
            currentLongitude = (info.last?.CurrentLong)!
        }
        else
        {
            print("There is an issue")
        }

        // Do any additional setup after loading the view.
        
        CategoryTabl.rowHeight = UITableViewAutomaticDimension
        CategoryTabl.estimatedRowHeight = 130
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
        if strSearchType == "1"
        {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
            for aViewController in viewControllers {
                if(aViewController is HomeViewController){
                    self.navigationController!.popToViewController(aViewController, animated: true);
                }
            }
        }
        else if strSearchType == "2"
        {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
            for aViewController in viewControllers {
                if(aViewController is ServicesViewController){
                    self.navigationController!.popToViewController(aViewController, animated: true);
                }
            }
        }
        else
        {
           _ = self.navigationController?.popViewController(animated: true)
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
//        if strSearchType == "1"
//        {
//            _ = self.navigationController?.popViewController(animated: true)
//        }
//        else
//        {
//            strSearchType = "2"
//            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchSortItemViewController") as? SearchSortItemViewController
//            self.navigationController?.pushViewController(myVC!, animated: false)
//        }
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchSortItemViewController") as? SearchSortItemViewController
        myVC?.strSearchType = strSearchType
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
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return CategorylistArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "ItemlistCell"
        Cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ItemlistCell
        if Cell == nil
        {
            tableView.register(UINib(nibName: "ItemlistCell", bundle: nil), forCellReuseIdentifier: identifier)
            Cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ItemlistCell
        }
        Cell?.selectionStyle = UITableViewCellSelectionStyle.none
        CategoryTabl.separatorStyle = .none
        CategoryTabl.separatorColor = UIColor.clear
       
        
        let imageURL: String = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as? String ?? ""
        if imageURL == "" || imageURL == "0"
        {
            Cell.ItemImage.image = UIImage(named: "Placeholder")
        }
        else
        {
            let url = NSURL(string:imageURL)
            Cell.ItemImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
        }
        
//        if ( UIDevice.current.model.range(of: "iPad") != nil)
//        {
//           Cell.ItemImage.layer.cornerRadius = 60
//           Cell.ItemImage.clipsToBounds = true
//
//        }
//        else
//        {
//            Cell.ItemImage.layer.cornerRadius = 50
//            Cell.ItemImage.clipsToBounds = true
//        }
        
        Cell.ItemStoreName.text = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
        Cell.ItemUserName.text = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "vandor") as? String ?? ""
        Cell.ItemRating.delegate = self as? FloatRatingViewDelegate
        Cell.ItemRating.type = .halfRatings
        Cell.ItemRating.type = .floatRatings
        
        if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "rating") as? NSNumber
        {
            Cell.ItemRating.rating = Double(CGFloat(quantity))
        }
        else if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "rating") as? String
        {
            let numberFormatter = NumberFormatter()
            let number = numberFormatter.number(from: quantity)
            let numberFloatValue = number?.floatValue
            Cell.ItemRating.rating = Double(numberFloatValue!)
        }
        
        var StrDiscount = String()
        if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "is_discount") as? NSNumber
        {
            StrDiscount = String(describing: quantity)
        }
        else if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "is_discount") as? String
        {
            StrDiscount = quantity
        }
        
        if StrDiscount == "1"
        {
            Cell.LayoutDistanceHeight.constant = 8
            
            if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "regular_price") as? NSNumber
            {
                let strval = String(describing: quantity)
                print(strval)
                Cell.ItemPrice.text = String(format:"$ %@ ", strval)
            }
            else if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "regular_price") as? String
            {
                print(quantity)
                Cell.ItemPrice.text = String(format:"$ %@ ", quantity)
            }
            
            if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "price") as? NSNumber
            {
                let strval = String(describing: quantity)
                print(strval)
                Cell.ItemDiscountPrice.text = String(format:"$ %@ ", strval)
            }
            else if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "price") as? String
            {
                print(quantity)
                Cell.ItemDiscountPrice.text = String(format:"$ %@ ", quantity)
            }
            
            if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "discount") as? NSNumber
            {
                let strval = String(describing: quantity)
                print(strval)
                Cell.DiscountPrice.text = String(format:"(%@ Discount) ", strval)
            }
            else if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "discount") as? String
            {
                print(quantity)
                Cell.DiscountPrice.text = String(format:"(%@ Discount) ", quantity)
            }
        }
        else
        {
            Cell.ItemPrice.text = ""
            Cell.LayoutDistanceHeight.constant = 0
            
            if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "regular_price") as? NSNumber
            {
                let strval = String(describing: quantity)
                print(strval)
                Cell.ItemDiscountPrice.text = String(format:"$ %@ ", strval)
            }
            else if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "regular_price") as? String
            {
                print(quantity)
                Cell.ItemDiscountPrice.text = String(format:"$ %@ ", quantity)
            }
            
             Cell.DiscountPrice.text = ""
        }
        
        return Cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? NSNumber
        {
            strProductId = String(describing: quantity)
        }
        else if let quantity = (self.CategorylistArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
        {
            strProductId = quantity
        }
        
        self.ProductDetailsAPIMethod(baseURL: String(format:"%@%@?product_id=%@",Constants.mainURL,"product_detail",strProductId))
    }
    
    
    @objc private   func ProductDetailsAPIMethod (baseURL:String)
    {
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
                let strlat = "\(currentLatitude)"
                let strlong = "\(currentLongitude)"
                 
                let baseURL: String  =  String(format:"%@%@?category_id=%@&text=%@&lat=%@&long=%@&sort=%@&page=%@",Constants.mainURL,"product_list",strCategoryId,strSearchtxt,strlat,strlong,strSort,self.strPage)
                
                AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
                    
                    DispatchQueue.main.async {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let responceDic:NSDictionary = jsonDic as NSDictionary
                          print(responceDic)
                        if (responceDic.object(forKey: "status") as! NSNumber) == 1
                        {
                            self.responsewithToken7(responceDic)
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
        arr = ((responseDict.object(forKey: "data") as? NSDictionary)?.object(forKey: "product") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.CategorylistArray.addObjects(from: arr as [AnyObject])
        
        if let quantity = ((responseDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? NSNumber
        {
            self.strPage = String(describing: quantity)
        }
        else if let quantity = ((responseDictionary.object(forKey: "data") as? NSDictionary)?.object(forKey: "nextPage")) as? String
        {
             self.strPage = quantity
        }
        
        CategoryTabl.reloadData()
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


extension CategoryItemlistViewController: GMSAutocompleteViewControllerDelegate {
    
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


