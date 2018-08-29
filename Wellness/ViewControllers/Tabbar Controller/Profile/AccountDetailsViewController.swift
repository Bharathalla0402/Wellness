//
//  AccountDetailsViewController.swift
//  Wellness
//
//  Created by think360 on 13/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import RaisePlaceholder
import Alamofire

class AccountDetailsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SecondDelegate {

    var imagePicker = UIImagePickerController()
    var currentSelectedImage = UIImage()
    
    var classObject = MultipartViewController()
    
    @IBOutlet weak var ImageButt: UIButton!
    @IBOutlet weak var UserPic: UIImageView!
    @IBOutlet weak var txtUserName: UILabel!
    @IBOutlet weak var txtFirstName: ACFloatingTextfield!
    @IBOutlet weak var txtLastName: ACFloatingTextfield!
    @IBOutlet weak var txtEmailAddress: ACFloatingTextfield!
    @IBOutlet weak var txtPhoneNumber: ACFloatingTextfield!
    @IBOutlet weak var txtOldPassword: ACFloatingTextfield!
    @IBOutlet weak var txtNewPassword: ACFloatingTextfield!
    @IBOutlet weak var txtConfirmPassword: ACFloatingTextfield!
    
    var myArray = NSDictionary()
    var strUserID = String()
    var StrImageUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         classObject.delegate = self
        
        if let data = UserDefaults.standard.data(forKey: "UserProfile"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserProfile]
        {
            let str1 = info.last?.FirstName
            let str2 = info.last?.LastName
            let str3 = " "
            txtUserName.text = str1!+str3+str2!
            
            txtFirstName.text = str1
            txtLastName.text = str2
            txtEmailAddress.text = info.last?.EmailId
            txtPhoneNumber.text = info.last?.Phone
            txtOldPassword.text = ""
            txtNewPassword.text = ""
            txtConfirmPassword.text = ""
            
            let imageURL: String = (info.last?.ImageUrl)!
            if imageURL == ""
            {
                UserPic.image = UIImage(named: "Placeholder")
            }
            else
            {
                let url = NSURL(string:imageURL)
                UserPic.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Placeholder"))
            }
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

         imagePicker.delegate = self
        
        // Do any additional setup after loading the view.
         self.addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.txtFirstName.inputAccessoryView = doneToolbar
        self.txtLastName.inputAccessoryView = doneToolbar
        self.txtEmailAddress.inputAccessoryView = doneToolbar
        self.txtPhoneNumber.inputAccessoryView = doneToolbar
        self.txtOldPassword.inputAccessoryView = doneToolbar
        self.txtNewPassword.inputAccessoryView = doneToolbar
        self.txtConfirmPassword.inputAccessoryView = doneToolbar
    }
    
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
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
        
       // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
      //  classObject.checkLoginStatus()
    }
    
    // MARK:  Back Butt Clicked
    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
     // MARK:  ImagePic Butt Clicked
    @IBAction func ImagePicButtClicked(_ sender: UIButton)
    {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let pibraryAction = UIAlertAction(title: "From Photo Library", style: .default, handler:
        {(alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cameraction = UIAlertAction(title: "Camera", style: .default, handler:
        {(alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true,completion: nil)
                
            } else {
               // AFWrapperClass.alert(Constants.applicationName, message: "Sorry, this device has no camera", view: self)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(pibraryAction)
        optionMenu.addAction(cameraction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            let popOverPresentationController : UIPopoverPresentationController = optionMenu.popoverPresentationController!
            popOverPresentationController.sourceView                = ImageButt
            popOverPresentationController.sourceRect                = ImageButt.bounds
            popOverPresentationController.permittedArrowDirections  = UIPopoverArrowDirection.any
        }
        
    }
    
    func image(withReduce imageName: UIImage, scaleTo newsize: CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(newsize, false, 12.0)
        imageName.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newsize.width), height: CGFloat(newsize.height)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        currentSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        UserPic.image = currentSelectedImage
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        self.classObject.next(currentSelectedImage)
        dismiss(animated: true, completion: nil)
       // self.uploadImageAPIMethod()
    }
    
    func responsewithToken(_ responseToken: NSMutableDictionary!)
    {
        print(responseToken)
        AFWrapperClass.svprogressHudDismiss(view: self)
        
        if responseToken == nil
        {
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: "Server is not responding.Please try again later", view: self)
        }
        else
        {
            
            if (responseToken.object(forKey: "status") as! NSNumber) == 1
            {
                self.StrImageUrl = (responseToken.value(forKey: "data") as? NSDictionary)?.value(forKey: "file_path") as? String ?? ""
            }
            else
            {
                let Message = responseToken.object(forKey: "responseMessage") as? String ?? ""
                
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
            }
        }
    }
    
    
    
     // MARK:  SaveChanges Butt Clicked
    @IBAction func SaveChangesButtClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let str1: String = txtNewPassword.text!
        let str2: String = txtConfirmPassword.text!
        
        var message = String()
        if (txtFirstName.text?.isEmpty)!
        {
            message = "Please Enter First Name"
        }
        else if (txtLastName.text?.isEmpty)!
        {
            message = "Please Enter Last Name"
        }
        else if (txtEmailAddress.text?.isEmpty)!
        {
            message = "Please Enter Email Id"
        }
        else if !AFWrapperClass.isValidEmail(txtEmailAddress.text!)
        {
            message = "Please Enter Valid Email"
        }
        else if (txtPhoneNumber.text?.isEmpty)!
        {
            message = "Please Enter Phone Number"
        }
        else if !(txtOldPassword.text?.isEmpty)!
        {
            if !(txtNewPassword.text?.isEmpty)!
            {
                if !(txtConfirmPassword.text?.isEmpty)!
                {
                    if (str1 != str2)
                    {
                        message = "Password and Confirm Password is Not Matching"
                    }
                    else
                    {
                         self.UserProfileUpdateAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"user_profile_update") , params: "first_name=\(txtFirstName.text!)&last_name=\(txtLastName.text!)&email=\(txtEmailAddress.text!)&phone=\(txtPhoneNumber.text!)&user_id=\(strUserID)&old_password=\(txtOldPassword.text!)&new_password=\(txtNewPassword.text!)&profile_pic=\(StrImageUrl)")
                        
                        return;
                    }
                }
                else
                {
                     message = "Please Enter Confirm New Password"
                }
            }
            else
            {
                 message = "Please Enter New Password"
            }
        }
        else if (txtOldPassword.text?.isEmpty)!
        {
            if (txtNewPassword.text?.isEmpty)!
            {
                if (txtConfirmPassword.text?.isEmpty)!
                {
                    if message.characters.count > 1
                    {
                        AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
                    }
                    else
                    {
                        self.UserProfileUpdateAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"user_profile_update") , params: "first_name=\(txtFirstName.text!)&last_name=\(txtLastName.text!)&email=\(txtEmailAddress.text!)&phone=\(txtPhoneNumber.text!)&user_id=\(strUserID)&profile_pic=\(StrImageUrl)")
                    }
                    
                    return;
                }
                else
                {
                     message = "Please Enter old Password"
                }
            }
            else
            {
                message = "Please Enter Old Password"
            }
        }
        
        if message.characters.count > 1
        {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
            self.UserProfileUpdateAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"user_profile_update") , params: "first_name=\(txtFirstName.text!)&last_name=\(txtLastName.text!)&email=\(txtEmailAddress.text!)&phone=\(txtPhoneNumber.text!)&user_id=\(strUserID)&profile_pic=\(StrImageUrl)")
        }
    }
    
    @objc private   func UserProfileUpdateAPIMethod (baseURL:String , params: String)
    {
        print(baseURL)
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                     UserDefaults.standard.setValue("Yes", forKey: "front")
                   self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                }
            }
            
        }) { (error) in
            
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
