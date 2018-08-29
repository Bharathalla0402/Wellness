//
//  HelpViewController.swift
//  Wellness
//
//  Created by think360 on 21/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController,UIWebViewDelegate,SecondDelegate {

    @IBOutlet weak var HelpWebView: UIWebView!
    
    var classObject = MultipartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        
        
        HelpWebView.delegate = self
        HelpWebView.backgroundColor = UIColor.white
        let url = NSURL (string: "https://wellnesswrx.ca/support/")
        var requestObj = URLRequest(url: url! as URL)
        requestObj.cachePolicy = .returnCacheDataElseLoad
       // HelpWebView.isUserInteractionEnabled = false
        HelpWebView.loadRequest(requestObj);
        
        // Do any additional setup after loading the view.
    }
    
    // MARK:  UIWebView Delegates
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        AFWrapperClass.svprogressHudDismiss(view: self)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        AFWrapperClass.svprogressHudDismiss(view: self)
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
    
    
    // MARK:  Back Butt Clicked
    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func responsewithToken2()
    {
       // AFWrapperClass.svprogressHudDismiss(view: self)
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
    }
    
    // MARK:  View Will Appear
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
      //  AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        classObject.checkLoginStatus()
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
