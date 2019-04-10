//
//  ViewController.swift
//  XPHUDExample
//
//  Created by xp on 2018/6/1.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        XPToast.show("sfdgsdfgdsfgdsfgdsfgdsfgsdfgsdsfdgsdfgdsfgdsfgdsfgdsfgsdfgsdsfdgsdfgdsfgdsfgdsfgdsfgsdfgsdsfdgsdfgdsfgdsfgdsfgdsfgsdfgsd")
        
//        XPHUDUtils.share.showHUD(message: "sdfdgfsddgfefgdfsf")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
//            XPHUDUtils.share.hideHUD()
//        }
        
    }


}

