//
//  ActivityIndicator-Ext.swift
//  GitHubClient
//
//  Created by Геннадий Махмудов on 15.07.2020.
//  Copyright © 2020 Геннадий Махмудов. All rights reserved.
//

import Foundation
import UIKit

fileprivate var aView : UIView?

extension UIViewController{
    
    func showSpinner(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
}

