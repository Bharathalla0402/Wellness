//
//  TabsViewController.swift
//  Wellness
//
//  Created by think360 on 05/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit

class TabsViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        let toIndex: Int = self.tabBar.items!.index(of: item)!
        guard let tabViewControllers = viewControllers, tabViewControllers.count > toIndex, let fromViewController = selectedViewController, let fromIndex = tabViewControllers.index(of: fromViewController), fromIndex != toIndex else {return}
        
        view.isUserInteractionEnabled = false
        
        let toViewController = tabViewControllers[toIndex]
        let push = toIndex > fromIndex
        let bounds = UIScreen.main.bounds
        
        let offScreenCenter = CGPoint(x: fromViewController.view.center.x + bounds.width, y: toViewController.view.center.y)
        let partiallyOffCenter = CGPoint(x: fromViewController.view.center.x - bounds.width*0.25, y: fromViewController.view.center.y)
        
        if push{
            fromViewController.view.superview?.addSubview(toViewController.view)
            toViewController.view.center = offScreenCenter
        }else{
            fromViewController.view.superview?.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            toViewController.view.center = partiallyOffCenter
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            toViewController.view.center   = fromViewController.view.center
            fromViewController.view.center = push ? partiallyOffCenter : offScreenCenter
        }, completion: { finished in
            fromViewController.view.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        })
        
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
