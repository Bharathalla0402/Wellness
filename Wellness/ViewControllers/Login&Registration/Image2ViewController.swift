//
//  Image2ViewController.swift
//  Wellness
//
//  Created by think360 on 08/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class Image2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK:  Skip Butt Clicked
    
    @IBAction func SkipButtClicked(_ sender: UIButton)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    // MARK:  Next Butt Clicked
    
    @IBAction func NextButtClicked(_ sender: UIButton)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "Image3ViewController") as? Image3ViewController
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
