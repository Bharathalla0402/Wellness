//
//  PlaceOrderViewController.swift
//  Wellness
//
//  Created by think360 on 12/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import LCBannerView
import SDWebImage
import RaisePlaceholder
import CoreLocation
import GooglePlacePicker

class PlaceOrderViewController: UIViewController,LCBannerViewDelegate,CLLocationManagerDelegate,SecondDelegate {

    var locationManager = CLLocationManager()
    
    @IBOutlet weak var LocationView: UIView!
    @IBOutlet weak var LocationName: UILabel!
    @IBOutlet weak var SearchItemBar: UISearchBar!
    
    @IBOutlet weak var ApplyCouponLab: UILabel!
    @IBOutlet weak var ImgBannerView: UIView!
    @IBOutlet weak var ItemStoreName: UILabel!
    @IBOutlet weak var ItemUserName: UILabel!
    @IBOutlet weak var ItemPrice: UILabel!
    @IBOutlet weak var CouponView: UIView!
    @IBOutlet weak var txtCouponCode: ACFloatingTextfield!
    @IBOutlet weak var ApplyButt: UIButton!
    @IBOutlet weak var ProductTotalLab: UILabel!
    @IBOutlet weak var CouponDiscountLab: UILabel!
    @IBOutlet weak var SubTotalLab: UILabel!
    @IBOutlet weak var TotalPayableLab: UILabel!
    @IBOutlet weak var HSTlab: UILabel!
    
    @IBOutlet weak var LocationNameHeightConstant: NSLayoutConstraint!
    
    
    var imagesArray = NSMutableArray()
    
    var myArray = NSDictionary()
    var strUserID = String()
    
    var strProductId = String()
    var strCouponId = String()
    var StrDiscount = String()
    var StrProductPrice = String()
    var StrProductDate = String()
    var StrProducttime = String()
    var StrProductMonthName = String()
    var StrProductMonthId = String()
    var StrProductYear = String()
    var strBool = String()
    
    
    var StrProYearId = Int()
    var StrProMonthId = Int()
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    
    var strPlaceCheck = String()
    
    var ProductDetail = NSDictionary()
    
    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
        LocationNameHeightConstant.constant = self.view.frame.size.width - 120
        
        txtCouponCode.text = ""
        ApplyCouponLab.isHidden = true
        self.ApplyButt.layer.cornerRadius = 8.0
        self.ApplyButt.clipsToBounds = true
       
      
        
        self.BookingItemPriceAPIMethod(baseURL: String(format:"%@%@?product_id=%@&coupon_code=%@&year=%d&month=%d&day=%@&time=%@",Constants.mainURL,"get_coupon_detail",strProductId,txtCouponCode.text!,StrProYearId,StrProMonthId,StrProductDate,StrProducttime))
        
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
        
        ItemStoreName.text = ProductDetail.object(forKey: "name") as? String ?? ""
        ItemUserName.text = ProductDetail.object(forKey: "vandor") as? String ?? ""
       
        
        
        
        CouponView.layer.borderWidth = 0.5
        CouponView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
         
         strPlaceCheck = "1" // for view will appear check condition if click place selction
        
        var height = CGFloat()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            height = 300.0
        }
        else
        {
            height = 180.0
        }
        
        let imagesDataArray = NSMutableArray()
        for i in 0..<imagesArray.count
        {
            let image: String = imagesArray.object(at: i) as! String
            //as! NSDictionary).object(forKey: "link") as! String
            let image1 = image.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
            imagesDataArray.add(image1 as Any)
        }
        
        if imagesDataArray.count == 0
        {
            let imageview = UIImageView()
            imageview.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width-16, height: height)
            imageview.image = UIImage(named: "Dummy2")
            imageview.contentMode = .scaleAspectFit
            imageview.clipsToBounds = true
            ImgBannerView.addSubview(imageview)
        }
        else if imagesDataArray.count == 1
        {
            let bannerview = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width-16, height: height), delegate: self, imageURLs: (imagesArray as NSArray) as! [Any], placeholderImageName: "Logo", timeInterval: 1000, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
            bannerview?.clipsToBounds = true
            bannerview?.notScrolling = true
            bannerview?.contentMode = .scaleAspectFit
            ImgBannerView.addSubview(bannerview!)
        }
        else
        {
            let bannerview = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width-16, height: height), delegate: self, imageURLs: (imagesArray as NSArray) as! [Any], placeholderImageName: "Logo", timeInterval: 5, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
            bannerview?.clipsToBounds = true
            bannerview?.contentMode = .scaleAspectFit
            ImgBannerView.addSubview(bannerview!)
        }
        
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
         self.txtCouponCode.inputAccessoryView = doneToolbar
    }
    
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
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
    
    
    //Dashboard API
    
    @objc private   func BookingItemPriceAPIMethod (baseURL:String)
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
                    if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "coupon_id")) as? NSNumber
                    {
                        self.strCouponId = String(describing: quantity)
                    }
                    else if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "coupon_id")) as? String
                    {
                        self.strCouponId = quantity
                    }
                    
                    if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "discount")) as? NSNumber
                    {
                        self.StrDiscount = String(describing: quantity)
                        self.CouponDiscountLab.text = String(format:"$ %@", self.StrDiscount)
                    }
                    else if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "discount")) as? String
                    {
                        self.StrDiscount = quantity
                       self.CouponDiscountLab.text = String(format:"$ %@", self.StrDiscount)
                    }
                    
                    if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "product_price_total")) as? NSNumber
                    {
                        self.StrProductPrice = String(describing: quantity)
                        self.TotalPayableLab.text =  String(format:"$ %@", self.StrProductPrice)
                    }
                    else if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "product_price_total")) as? String
                    {
                        self.StrProductPrice = quantity
                        self.TotalPayableLab.text = String(format:"$ %@", self.StrProductPrice)
                    }
                    
                    
                    if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "product_price")) as? NSNumber
                    {
                        let str = String(describing: quantity)
                        self.ProductTotalLab.text = String(format:"$ %@", str)
                        self.ItemPrice.text = String(format:"$ %@", str)
                    }
                    else if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "product_price")) as? String 
                    {
                        self.ProductTotalLab.text = String(format:"$ %@", quantity)
                        self.ItemPrice.text = String(format:"$ %@", quantity)
                    }
                    
                    if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "price_subtotal")) as? NSNumber
                    {
                        let str = String(describing: quantity)
                        self.SubTotalLab.text = String(format:"$ %@", str)
                    }
                    else if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "price_subtotal")) as? String
                    {
                         self.SubTotalLab.text = String(format:"$ %@", quantity)
                    }
                    
                    if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "product_tax")) as? NSNumber
                    {
                        let str = String(describing: quantity)
                        self.HSTlab.text = String(format:"$ %@", str)
                    }
                    else if let quantity = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "product_tax")) as? String
                    {
                        self.HSTlab.text = String(format:"$ %@", quantity)
                    }
                    
                    
                    if self.strBool == "1"
                    {
                        self.ApplyCouponLab.isHidden = false
                        self.txtCouponCode.isHidden = true
                        let str = "Congratulations!. Coupon has been sucessfully applied. You will get a Discount price of $ "
                        self.ApplyCouponLab.text = str+self.StrDiscount
                        self.strBool = "2"
                        self.ApplyButt.setTitle("  Cancel  ", for: .normal)
                        
                    }
                    else
                    {
                        self.strBool = "1"
                        self.ApplyCouponLab.isHidden = true
                        self.txtCouponCode.isHidden = false
                        self.txtCouponCode.text = ""
                        self.ApplyButt.setTitle("  Apply  ", for: .normal)
                    }
                    
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
    
    // MARK:  Coupon Butt Clicked
    
    @IBAction func CouponButtClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        var message = String()
        if (txtCouponCode.text?.isEmpty)!
        {
            message = "Please Enter CouponCode"
        }
   
        if message.characters.count > 1
        {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
            if strBool == "1"
            {
                let str = txtCouponCode.text!
                var encodeUrl = String()
                let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
                if let escapedString = str.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
                    encodeUrl = escapedString
                }
                
                 self.BookingItemPriceAPIMethod(baseURL: String(format:"%@%@?product_id=%@&coupon_code=%@&year=%d&month=%d&day=%@&time=%@",Constants.mainURL,"get_coupon_detail",strProductId,encodeUrl,StrProYearId,StrProMonthId,StrProductDate,StrProducttime))
                
            }
            else
            {
                 self.BookingItemPriceAPIMethod(baseURL: String(format:"%@%@?product_id=%@&coupon_code=%@&year=%d&month=%d&day=%@&time=%@",Constants.mainURL,"get_coupon_detail",strProductId,"",StrProYearId,StrProMonthId,StrProductDate,StrProducttime))
            }
        }
    }
    
    // MARK:  Place Order Butt Clicked
    
    @IBAction func PlaceOrderButtClicked(_ sender: UIButton)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController
        myVC?.ProductDetail = ProductDetail
        myVC?.strProductId = strProductId
        myVC?.strCouponId = strCouponId
        myVC?.StrProductPrice = StrProductPrice
        myVC?.imagesArray = imagesArray
        myVC?.StrProductDate = StrProductDate
        myVC?.StrProducttime = StrProducttime
        myVC?.StrProductMonthName = StrProductMonthName
        myVC?.StrProductMonthId = StrProductMonthId
        myVC?.StrProductYear = StrProductYear
        myVC?.StrProYearId = StrProYearId
        myVC?.StrProMonthId = StrProMonthId
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

extension PlaceOrderViewController: GMSAutocompleteViewControllerDelegate {
    
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



