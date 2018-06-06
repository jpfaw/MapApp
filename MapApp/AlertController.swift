//
//  AlertController.swift
//  MapApp
//
//  Created by Yuta on 2018/06/05.
//  Copyright © 2018年 Yuta. All rights reserved.
//

import UIKit

extension ViewController {
    
    func pushAlert(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
