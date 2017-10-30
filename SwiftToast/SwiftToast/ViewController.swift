//
//  ViewController.swift
//  SwiftToast
//
//  Created by hsm on 2017/10/26.
//  Copyright © 2017年 SM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func showToastClick(_ sender: Any) {
        print("btn\(sender)")
        let  kfToast = KFToastView.sharedInstance
        kfToast.setTextLabelColor(color: UIColor.blue)
        kfToast.setToastViewBackgroundColor(color: UIColor.yellow)
        kfToast.showToast(text: "hellotoastddddddddddddddtoastddddddddddddddtoastdddddddddddddd toastdddddddddddddd ", duration: 2,delay: 0.25)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

