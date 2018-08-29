//
//  DetailCategoryViewController.swift
//  Wellness
//
//  Created by think360 on 12/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import LCBannerView
import SDWebImage
import CoreLocation
import GooglePlacePicker

class CalenderCell: UICollectionViewCell
{
    @IBOutlet weak var DataLab: UILabel!
}

class DetailCategoryViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LCBannerViewDelegate,CLLocationManagerDelegate,UIWebViewDelegate,SecondDelegate {

    var locationManager = CLLocationManager()
    
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var LocationView: UIView!
    @IBOutlet weak var LocationName: UILabel!
    @IBOutlet weak var SearchItemBar: UISearchBar!
   
    @IBOutlet weak var ImgBannerView: UIView!
    @IBOutlet weak var ItemStoreName: UILabel!
    @IBOutlet weak var ItemUserName: UILabel!
    @IBOutlet weak var ItemPrice: UILabel!
    @IBOutlet weak var ItemDescription: UILabel!
    @IBOutlet weak var YearCollectionView: UICollectionView!
    @IBOutlet weak var MonthCollectionView: UICollectionView!
    @IBOutlet weak var DayCollectionView: UICollectionView!
    @IBOutlet weak var TimeCollectionView: UICollectionView!
    @IBOutlet weak var DetailWebView: UIWebView!
    @IBOutlet weak var WebViewHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var BookNowButt: UIButton!
    var cell: CalenderCell!
    
    @IBOutlet weak var SubCatView: UIView!
    @IBOutlet weak var SubCatImage: UIImageView!
    @IBOutlet weak var SubCatName: UILabel!
    
    @IBOutlet weak var LocationNameHeightConstant: NSLayoutConstraint!
    
    var ProductDetail = NSDictionary()
    var imagesArray = NSMutableArray()
    var strProductId = String()
    
    var ProductYearArray = NSMutableArray()
    var ProductMonthArray = NSMutableArray()
    var ProductDayArray = NSMutableArray()
    var ProductTimeArray = NSMutableArray()
    var StrProductYearId = Int()
    var StrProductMonthId = Int()
    var StrProductDayId = String()
    var StrProductTimeId = String()
    var StrProductMonthName = String()
    
    
   
    var StaticMonthArray : NSMutableArray = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    var MonthArray = NSMutableArray()
    var DaysArray = NSMutableArray()
    var TimeArray : NSMutableArray = ["09:00 am","10:00 am","11:00 am","12:00 pm","01:00 pm","02:00 pm","03:00 pm","04:00 pm","05:00 pm","06:00 pm"]
    
    var numDays: Int = 0
    
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    var SelectedMonth: Int = 0
    
    var StrMonth = String()
    var StrDay = String()
    var StrTime = String()
    var onceOnly = false
    
    var StrCategoryType = String()
    
    var StrCategoryBookingId = String()
    
    
    var myArray = NSDictionary()
    var strUserID = String()
    
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    
    var strPlaceCheck = String()
    var strBack = String()
    
    var imagesDataArray = NSMutableArray()
    var popview3 = UIView()
    var footerView3 = UIView()
    
    var CategoryListView:UICollectionView!
    var Cell3: ImageCollectionCell!
     var x: Int = 0
    
    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
        LocationNameHeightConstant.constant = self.view.frame.size.width - 120

        // Do any additional setup after loading the view.
        
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
        
        BookNowButt.isHidden = true
        
        strPlaceCheck = "1" // for view will appear check condition if click place selction
        
        let date = Date()
        let calendar = Calendar.current
        
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        SelectedMonth = month
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        StrMonth = dateFormatter.string(from: date)
        StrDay = String(day)
        print(day,month,year)
        print(StrMonth)
        
       
        let dateComponents = DateComponents(year: year, month: month)
        let datec = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: datec)!
        numDays = range.count
        print(numDays)
        
        StrTime = (TimeArray.object(at: 0) as? String)!
        
        // assign the values to the variables
        ItemStoreName.text = ProductDetail.object(forKey: "name") as? String ?? ""
        ItemUserName.text = ProductDetail.object(forKey: "vandor") as? String ?? ""
        if let quantity = self.ProductDetail.object(forKey: "price") as? NSNumber
        {
            let strval = String(describing: quantity)
            ItemPrice.text = String(format:"$ %@", strval)
        }
        else if let quantity = self.ProductDetail.object(forKey: "price") as? String
        {
            ItemPrice.text = String(format:"$ %@", quantity)
        }
        
        ItemDescription.isHidden = true
       
        let htmlText2 = ProductDetail.object(forKey: "description") as? String ?? ""
//        if let htmlData2 = htmlText2.data(using: String.Encoding.unicode) {
//            do {
//                let attributedText = try NSAttributedString(data: htmlData2, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
//                ItemDescription.font = UIFont(name: "Helvetica", size: 16)!
//                ItemDescription.attributedText = attributedText
//
//            } catch let e as NSError {
//                print("Couldn't translate \(htmlText2): \(e.localizedDescription) ")
//            }
//        }
        let font = UIFont.init(name: "Helvetica", size: 15)
        self.DetailWebView.loadHTMLString("<span style=\"font-family: \(font!.fontName); font-size: \(font!.pointSize); color: #3E3E3E\">\(htmlText2)</span>", baseURL: nil)
        DetailWebView.scrollView.showsHorizontalScrollIndicator = false
        DetailWebView.scrollView.showsVerticalScrollIndicator = false
        DetailWebView.scrollView.isScrollEnabled = false
      //  DetailWebView.loadHTMLString(htmlText2, baseURL: nil)
        
        ProductYearArray = (ProductDetail.object(forKey: "available_month") as? NSMutableArray)!
        
        if ProductYearArray.count == 0
        {
            YearCollectionView.isHidden = true
            MonthCollectionView.isHidden = true
            DayCollectionView.isHidden = true
            TimeCollectionView.isHidden = true
        }
        else
        {
            
            if let quantity = (ProductYearArray.object(at: 0) as? NSDictionary)?.object(forKey: "year") as? NSNumber
            {
                StrProductYearId = quantity.intValue
            }
            else if let quantity = (ProductYearArray.object(at: 0) as? NSDictionary)?.object(forKey: "year") as? String
            {
                StrProductYearId = Int(quantity)!
            }
            
            
            
            ProductMonthArray = (((ProductDetail.object(forKey: "available_month") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "month") as? NSMutableArray)!
            
            
            if ProductMonthArray.count == 0
            {
                
            }
            else
            {
                if let quantity = ProductMonthArray.object(at: 0) as? NSNumber
                {
                    StrProductMonthId = quantity.intValue
                }
                else if let quantity = ProductMonthArray.object(at: 0) as? String
                {
                    StrProductMonthId = Int(quantity)!
                }
                
               self.MonthDaysAPIMethod2(baseURL: String(format:"%@%@?product_id=%@&year=%d&month=%d",Constants.mainURL,"product_booking_day",strProductId,StrProductYearId,StrProductMonthId))
            }
            
            
        }
        
       
        
        
        // Banner Images displayed
        
        var height = CGFloat()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            height = 300.0
        }
        else
        {
            height = 180.0
        }
        
       
        for i in 0..<imagesArray.count
        {
            let image: String = imagesArray.object(at: i) as! String
            //as! NSDictionary).object(forKey: "link") as! String
            let image1 = image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
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
        
        
        var StrSubCat = String()
        if let quantity = self.ProductDetail.object(forKey: "category") as? NSNumber
        {
            StrSubCat = String(describing: quantity)
        }
        else if let quantity = self.ProductDetail.object(forKey: "category") as? String
        {
            StrSubCat = quantity
        }
        
        SubCatImage.isHidden = true
        if StrSubCat == "Emotional"
        {
            SubCatImage.image = UIImage(named:"Emotional")
            SubCatName.text = StrSubCat
        }
        else if StrSubCat == "Mental"
        {
            SubCatImage.image = UIImage(named:"Mental")
            SubCatName.text = StrSubCat
        }
        else if StrSubCat == "Physical"
        {
            SubCatImage.image = UIImage(named:"Physical")
            SubCatName.text = StrSubCat
        }
        else if StrSubCat == "Spiritual"
        {
            SubCatImage.image = UIImage(named:"Spiritual")
            SubCatName.text = StrSubCat
        }
        else
        {
            SubCatImage.image = UIImage(named:"Placeholder")
            SubCatName.text = StrSubCat
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
    }
    
     // Banner Images Clicked
    @IBAction func ImageButtClicked(_ sender: UIButton)
    {
        viewDidDraged()
    }
    
    func viewDidDraged()
    {
        popview3.isHidden=false
        footerView3.isHidden=false
        
        popview3.frame = CGRect(x:0, y:TopView.frame.origin.y, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview3.backgroundColor=UIColor(patternImage: UIImage(named: "BackgroundImage")!)
        self.view.addSubview(popview3)
        
        footerView3.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        footerView3.backgroundColor = #colorLiteral(red: 0.86695081, green: 0.8746541142, blue: 0.8702579141, alpha: 1)
        popview3.addSubview(footerView3)
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:10, y:25, width:25, height:25)
        crossbutt.setImage( UIImage.init(named: "CircleCross"), for: .normal)
        crossbutt.addTarget(self, action: #selector(self.CloseButtonAction3(_:)), for: UIControlEvents.touchUpInside)
        footerView3.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:0, y:20, width:50, height:40)
        crossbutt2.addTarget(self, action: #selector(self.CloseButtonAction3(_:)), for: UIControlEvents.touchUpInside)
        footerView3.addSubview(crossbutt2)
        
        let layout = UICollectionViewFlowLayout()
        CategoryListView = UICollectionView(frame: CGRect(x: 0, y: crossbutt2.frame.origin.y+crossbutt2.frame.size.height, width: footerView3.frame.size.width, height: footerView3.frame.size.height-60), collectionViewLayout: layout)
        CategoryListView.delegate = self
        CategoryListView.dataSource = self
        CategoryListView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        CategoryListView.backgroundColor = #colorLiteral(red: 0.9959946275, green: 0.9961337447, blue: 0.9959508777, alpha: 1)
        CategoryListView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellIdentifier")
        layout.scrollDirection = .horizontal
        CategoryListView.showsHorizontalScrollIndicator = false
        CategoryListView.showsVerticalScrollIndicator = false
        CategoryListView.isScrollEnabled = false
        CategoryListView.tag = 1
        CategoryListView.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        footerView3.addSubview(CategoryListView)
        
        let indexPath = IndexPath(item: x, section: 0)
        CategoryListView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    func CloseButtonAction3(_ sender: UIButton!)
    {
        popview3.isHidden=true
        footerView3.isHidden=true
    }
    
    func CollectionViewLeftSwipped2()
    {
        if self.x == 0
        {
            
        }
        else if self.x > 0
        {
            self.x = self.x - 1
            let indexPath = IndexPath(item: x, section: 0)
            CategoryListView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    func CollectionViewRightSwipped2()
    {
        if self.x < self.imagesDataArray.count
        {
            let count: Int = self.imagesDataArray.count-1
            
            if self.x == count
            {
                
            }
            else
            {
                self.x = self.x + 1
                let indexPath = IndexPath(item: x, section: 0)
                CategoryListView.scrollToItem(at: indexPath, at: .left, animated: true)
            }
            
        } else {
            self.x = 0
            self.CategoryListView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        }
    }
    
    
    
    @objc private   func MonthDaysAPIMethod2 (baseURL:String)
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
                    self.StrProductDayId = ""
                    self.StrProductTimeId = ""
                    self.ProductDayArray.removeAllObjects()
                    self.ProductTimeArray.removeAllObjects()
                    self.ProductDayArray = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "available_day") as? NSMutableArray)!
                    self.DayCollectionView.reloadData()
                    self.TimeCollectionView.reloadData()
                    
                    AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                    self.classObject.checkLoginStatus()
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                    
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
    
    
    
    
      // MARK:  WebView Delegate Methods.
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView)
    {
       // let textSize: Int = 17
      //  webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'")
        
        DetailWebView.frame.size.height = 1
        DetailWebView.frame.size = webView.sizeThatFits(CGSize.zero)
        WebViewHeightConstant.constant = DetailWebView.frame.size.height
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
        if strBack == "1"
        {
            UserDefaults.standard.setValue("Yes", forKey: "front")
            _ = self.navigationController?.popViewController(animated: true)
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
    
    // MARK:  Collection View Delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == YearCollectionView
        {
           return ProductYearArray.count
        }
        else if collectionView == MonthCollectionView
        {
           return ProductMonthArray.count
        }
        else if collectionView == DayCollectionView
        {
           return ProductDayArray.count
        }
        else if collectionView == CategoryListView
        {
            return imagesDataArray.count
        }
        else
        {
           return ProductTimeArray.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == CategoryListView
        {
            if ( UIDevice.current.model.range(of: "iPad") != nil)
            {
                return CGSize(width: self.view.bounds.size.width  , height: self.view.bounds.size.height-60)
            }
            else {
                return CGSize(width: self.view.bounds.size.width , height: self.view.bounds.size.height-60)
            }
        }
        else if collectionView == YearCollectionView
        {
            let count:Int = ProductYearArray.count
            let myFloat = CGFloat(count)
            if count > 3
            {
              return CGSize(width: (self.view.frame.size.width/3)-6, height: 30)
            }
            else
            {
               return CGSize(width: (self.view.frame.size.width/myFloat)-6, height: 30)
            }
        }
        else if collectionView == MonthCollectionView
        {
            let count:Int = ProductMonthArray.count
            let myFloat = CGFloat(count)
            if count > 3
            {
                return CGSize(width: (self.view.frame.size.width/3)-6, height: 30)
                
            }
            else
            {
                return CGSize(width: (self.view.frame.size.width/myFloat)-6, height: 30)
            }
        }
        else if collectionView == DayCollectionView
        {
             return CGSize(width: 34 , height: 34)
        }
        else
        {
            let count:Int = ProductTimeArray.count
            let myFloat = CGFloat(count)
            if count > 3
            {
                return CGSize(width: (self.view.frame.size.width/3)-6, height: 30)
            }
            else
            {
                return CGSize(width: (self.view.frame.size.width/myFloat)-6, height: 30)
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView.tag == 1
        {
            Cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
            
            let imageURL: String =  imagesArray[indexPath.row] as! String
            let url = NSURL(string:imageURL)
            Cell3.BannerImage.contentMode = .scaleAspectFit;
            Cell3.BannerImage.clipsToBounds = true
            Cell3.BannerImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
            
            let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CollectionViewRightSwipped2))
            swipeLeft.direction = UISwipeGestureRecognizerDirection.left
            
            let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CollectionViewLeftSwipped2))
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            
            Cell3.SwipeClickButt.addGestureRecognizer(swipeLeft)
            Cell3.SwipeClickButt.addGestureRecognizer(swipeRight)
            
            let pinchZoom : UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureDidFire))
            Cell3.SwipeClickButt.addGestureRecognizer(pinchZoom)
            Cell3.BannerImage.addGestureRecognizer(pinchZoom)
            Cell3.ImageScrool.addGestureRecognizer(pinchZoom)
            
            //            let doubleTapGest : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
            //            doubleTapGest.numberOfTapsRequired = 2
            //            Cell3.SwipeClickButt.addGestureRecognizer(doubleTapGest)
            //            Cell3.BannerImage.addGestureRecognizer(doubleTapGest)
            //            Cell3.ImageScrool.addGestureRecognizer(doubleTapGest)
            
            Cell3.ImageScrool.delegate = self
            //    Cell3.ImageScrool.isScrollEnabled = false
            
            return Cell3
        }
        else
        {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderCell", for: indexPath) as! CalenderCell
        
        if collectionView == YearCollectionView
        {
            var YearCheckId = Int()
            if let quantity = (ProductYearArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "year") as? NSNumber
            {
                YearCheckId = quantity.intValue
            }
            else if let quantity = (ProductYearArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "year") as? String
            {
                YearCheckId = Int(quantity)!
            }
            
            
            if let quantity = (ProductYearArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "year") as? NSNumber
            {
                cell.DataLab.text = String(describing: quantity)
            }
            else if let quantity = (ProductYearArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "year") as? String
            {
                cell.DataLab.text = quantity
            }
            
            if StrProductYearId == YearCheckId
            {
                cell.DataLab.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.DataLab.textColor = #colorLiteral(red: 0.3333333333, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
                cell.DataLab.cornerRadius = 15
            }
            else
            {
                cell.DataLab.backgroundColor = UIColor.clear
                cell.DataLab.textColor = #colorLiteral(red: 0.7019607843, green: 0.7098039216, blue: 0.7215686275, alpha: 1)
                cell.DataLab.cornerRadius = 15
            }
            
        }
        else if collectionView == MonthCollectionView
        {
            var MonthCheckId = Int()
            if let quantity = ProductMonthArray.object(at: indexPath.row) as? NSNumber
            {
                MonthCheckId = quantity.intValue
            }
            else if let quantity = ProductMonthArray.object(at: indexPath.row) as? String
            {
                MonthCheckId = Int(quantity)!
            }
            
            cell.DataLab.text = StaticMonthArray.object(at: MonthCheckId-1) as? String
            if StrProductMonthId == MonthCheckId
            {
                cell.DataLab.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.DataLab.textColor = #colorLiteral(red: 0.3333333333, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
                cell.DataLab.cornerRadius = 15
            }
            else
            {
                cell.DataLab.backgroundColor = UIColor.clear
                cell.DataLab.textColor = #colorLiteral(red: 0.7019607843, green: 0.7098039216, blue: 0.7215686275, alpha: 1)
                cell.DataLab.cornerRadius = 15
            }
        }
        else if collectionView == DayCollectionView
        {
            var DayCheckId = String()
            if let quantity = ProductDayArray.object(at: indexPath.row) as? NSNumber
            {
                DayCheckId = String(describing: quantity)
                cell.DataLab.text = DayCheckId
            }
            else if let quantity = ProductDayArray.object(at: indexPath.row) as? String
            {
                DayCheckId = quantity
                cell.DataLab.text = quantity
            }
            
        
            if StrProductDayId == DayCheckId
            {
                cell.DataLab.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
                cell.DataLab.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.DataLab.cornerRadius = 15
            }
            else
            {
                cell.DataLab.backgroundColor = UIColor.clear
                cell.DataLab.textColor = UIColor.black
                cell.DataLab.cornerRadius = 15
            }
        }
        else
        {
            var TimeCheckId = String()
            if let quantity = ProductTimeArray.object(at: indexPath.row) as? NSNumber
            {
                TimeCheckId = String(describing: quantity)
                cell.DataLab.text = TimeCheckId
            }
            else if let quantity = ProductTimeArray.object(at: indexPath.row) as? String
            {
                TimeCheckId = quantity
                cell.DataLab.text = quantity
            }
            
            
            if StrProductTimeId == TimeCheckId
            {
                cell.DataLab.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.DataLab.textColor = #colorLiteral(red: 0.3333333333, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
                cell.DataLab.cornerRadius = 15
                cell.DataLab.layer.borderWidth = 2.0
                cell.DataLab.layer.borderColor = #colorLiteral(red: 0.3333333333, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
                cell.DataLab.clipsToBounds = true
            }
            else
            {
                cell.DataLab.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.937254902, blue: 0.9529411765, alpha: 1)
                cell.DataLab.textColor = #colorLiteral(red: 0.7019607843, green: 0.7098039216, blue: 0.7215686275, alpha: 1)
                cell.DataLab.cornerRadius = 15
                cell.DataLab.layer.borderWidth = 2.0
                cell.DataLab.layer.borderColor = #colorLiteral(red: 0.9254901961, green: 0.937254902, blue: 0.9529411765, alpha: 1)
                cell.DataLab.clipsToBounds = true
            }
        }
        return cell!
        }
    }
    
    func pinchGestureDidFire(_ pinch: UIPinchGestureRecognizer)
    {
        Cell3.BannerImage.contentMode = .scaleAspectFit;
        let pinchView: UIView? = pinch.view
        let bounds: CGRect? = pinchView?.bounds
        var pinchCenter: CGPoint = pinch.location(in: pinchView)
        pinchCenter.x -= (bounds?.midX)!
        pinchCenter.y -= (bounds?.midY)!
        var transform: CGAffineTransform? = pinchView?.transform
        transform = transform?.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
        let scale: CGFloat = pinch.scale
        transform = transform?.scaledBy(x: scale, y: scale)
        transform = transform?.translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
        pinchView?.transform = transform!
        pinch.scale = 1.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == CategoryListView
        {
           
        }
        else if collectionView == YearCollectionView
        {
            BookNowButt.isHidden = true
            
            if let quantity = (ProductYearArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "year") as? NSNumber
            {
                StrProductYearId = quantity.intValue
            }
            else if let quantity = (ProductYearArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "year") as? String
            {
                StrProductYearId = Int(quantity)!
            }
           
            let indexToScrollTo = IndexPath(row: indexPath.row, section: 0)
            self.MonthCollectionView.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: true)
            MonthCollectionView.reloadData()
            
            ProductMonthArray = ((ProductYearArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "month") as? NSMutableArray)!
            YearCollectionView.reloadData()
            
            if ProductMonthArray.count == 0
            {
                
            }
            else
            {
                if let quantity = ProductMonthArray.object(at: 0) as? NSNumber
                {
                    StrProductMonthId = quantity.intValue
                }
                else if let quantity = ProductMonthArray.object(at: 0) as? String
                {
                    StrProductMonthId = Int(quantity)!
                }
                
                self.MonthDaysAPIMethod(baseURL: String(format:"%@%@?product_id=%@&year=%d&month=%d",Constants.mainURL,"product_booking_day",strProductId,StrProductYearId,StrProductMonthId))
            }
            
        }
        else if collectionView == MonthCollectionView
        {
            BookNowButt.isHidden = true
            
            if let quantity = ProductMonthArray.object(at: indexPath.row) as? NSNumber
            {
                StrProductMonthId = quantity.intValue
            }
            else if let quantity = ProductMonthArray.object(at: indexPath.row) as? String
            {
                StrProductMonthId = Int(quantity)!
            }
            
            StrProductMonthName = (StaticMonthArray.object(at: StrProductMonthId-1) as? String)!
            
            MonthCollectionView.reloadData()
            
            self.MonthDaysAPIMethod(baseURL: String(format:"%@%@?product_id=%@&year=%d&month=%d",Constants.mainURL,"product_booking_day",strProductId,StrProductYearId,StrProductMonthId))

        }
        else if collectionView == DayCollectionView
        {
            BookNowButt.isHidden = true
            
            if let quantity = ProductDayArray.object(at: indexPath.row) as? NSNumber
            {
                StrProductDayId = String(describing: quantity)
            }
            else if let quantity = ProductDayArray.object(at: indexPath.row) as? String
            {
                StrProductDayId = quantity
            }
            
            DayCollectionView.reloadData()
            
            self.TimeDayAPIMethod(baseURL: String(format:"%@%@?product_id=%@&year=%d&month=%d&day=%@",Constants.mainURL,"product_booking_time_slot",strProductId,StrProductYearId,StrProductMonthId,StrProductDayId))
        }
        else
        {
            if let quantity = ProductTimeArray.object(at: indexPath.row) as? NSNumber
            {
                StrProductTimeId = String(describing: quantity)
            }
            else if let quantity = ProductTimeArray.object(at: indexPath.row) as? String
            {
                StrProductTimeId = quantity
            }
            
            BookNowButt.isHidden = false
            
            TimeCollectionView.reloadData()
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if !onceOnly {
            let indexToScrollTo = IndexPath(row: 0, section: 0)
            self.YearCollectionView.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: false)
            
          //  let indexToScrollTo = IndexPath(row: self.month-1, section: 0)
          //  self.MonthCollectionView.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: false)

          //  let indexToScrollTo2 = IndexPath(row: self.day-1, section: 0)
          //  self.DayCollectionView.scrollToItem(at: indexToScrollTo2, at: .centeredHorizontally, animated: false)

          //  let indexToScrollTo3 = IndexPath(row: 0, section: 0)
          //  self.TimeCollectionView.scrollToItem(at: indexToScrollTo3, at: .centeredHorizontally, animated: false)
            onceOnly = true
        }
    }
    
    // MARK:  Month Day Api
    
    @objc private   func MonthDaysAPIMethod (baseURL:String)
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
                    self.StrProductDayId = ""
                    self.StrProductTimeId = ""
                    self.ProductDayArray.removeAllObjects()
                    self.ProductTimeArray.removeAllObjects()
                    self.ProductDayArray = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "available_day") as? NSMutableArray)!
                    self.DayCollectionView.reloadData()
                    self.TimeCollectionView.reloadData()
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
    
    // MARK:  Time Slot Api
    
    @objc private   func TimeDayAPIMethod (baseURL:String)
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
                    self.StrProductTimeId = ""
                    self.ProductTimeArray.removeAllObjects()
                    self.ProductTimeArray = ((responceDic.object(forKey: "data") as? NSDictionary)?.object(forKey: "available_day") as? NSMutableArray)!
                    self.TimeCollectionView.reloadData()
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
    
    
    
     // MARK:  BookNow Butt Clicked
    
    @IBAction func BookNowButtClicked(_ sender: UIButton)
    {
        if StrProductDayId == ""
        {
           AFWrapperClass.alert(Constants.applicationName, message: "Please Select the booking date", view: self)
        }
        else if StrProductTimeId == ""
        {
           AFWrapperClass.alert(Constants.applicationName, message: "Please Select the booking time", view: self)
        }
        else
        {
            self.BookingAvailableAPIMethod(baseURL: String(format:"%@%@?product_id=%@&year=%d&month=%d&day=%@&time=%@",Constants.mainURL,"check_booking_availabilty",strProductId,StrProductYearId,StrProductMonthId,StrProductDayId,StrProductTimeId))
        }
    }
    
    @objc private   func BookingAvailableAPIMethod (baseURL:String)
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
  
                    let stringValue = "\(self.StrProductYearId)"
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "PlaceOrderViewController") as? PlaceOrderViewController
                    myVC?.ProductDetail = self.ProductDetail
                    myVC?.imagesArray = self.imagesArray
                    myVC?.strProductId = self.strProductId
                    myVC?.StrProductDate = self.StrProductDayId
                    myVC?.StrProducttime = self.StrProductTimeId
                    myVC?.StrProductMonthName = self.StrProductMonthName
                    myVC?.StrProductMonthId = String(self.StrProductMonthId)
                    myVC?.StrProductYear = stringValue
                    myVC?.StrProYearId = self.StrProductYearId
                    myVC?.StrProMonthId = self.StrProductMonthId
                    myVC?.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(myVC!, animated: true)
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                    
                    
//                    if let quantity = (self.ProductYearArray.object(at: 0) as? NSDictionary)?.object(forKey: "year") as? NSNumber
//                    {
//                        self.StrProductYearId = quantity.intValue
//                    }
//                    else if let quantity = (self.ProductYearArray.object(at: 0) as? NSDictionary)?.object(forKey: "year") as? String
//                    {
//                        self.StrProductYearId = Int(quantity)!
//                    }
//
//
//
//                    self.ProductMonthArray = (((self.ProductDetail.object(forKey: "available_month") as? NSMutableArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "month") as? NSMutableArray)!
//
//
//                    if self.ProductMonthArray.count == 0
//                    {
//
//                    }
//                    else
//                    {
//                        if let quantity = self.ProductMonthArray.object(at: 0) as? NSNumber
//                        {
//                            self.StrProductMonthId = quantity.intValue
//                        }
//                        else if let quantity = self.ProductMonthArray.object(at: 0) as? String
//                        {
//                            self.StrProductMonthId = Int(quantity)!
//                        }
//
//                        self.MonthDaysAPIMethod(baseURL: String(format:"%@%@?product_id=%@&year=%d&month=%d",Constants.mainURL,"product_booking_day",self.strProductId,self.StrProductYearId,self.StrProductMonthId))
//                    }
                    
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

extension DetailCategoryViewController: GMSAutocompleteViewControllerDelegate {
    
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



