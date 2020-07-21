//
//  FirstViewController.swift
//  GitHubClient
//
//  Created by Геннадий Махмудов on 11.07.2020.
//  Copyright © 2020 Геннадий Махмудов. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var getFollowersButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        
        view.addGestureRecognizer(tap)
        
        getFollowersButton?.layer.borderColor = UIColor.systemTeal.cgColor
        getFollowersButton?.layer.borderWidth = 3.0
        getFollowersButton?.layer.cornerRadius = 7.0
        //        getFollowersButton?.backgroundColor = UIColor.green
    }
    override func viewWillAppear(_ animated: Bool) {
        usernameField?.text = ""
        navigationController?.isNavigationBarHidden = true
        //        tabBarController?.tabBar.isHidden = true
        self.removeSpinner()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func getFollowersTapped(_ sender: UIButton) {
        
        self.showSpinner()
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            [weak self] in
            self?.getFollowersButton.transform = CGAffineTransform(translationX: 0, y: 10)
            self?.getFollowersButton.transform = CGAffineTransform(translationX: 0, y: -10)
            
        }) { [weak self](_) in
            guard let followersVC = self?.storyboard?.instantiateViewController(withIdentifier: "Collection") as? FollowersViewController else{
                fatalError("Could not reach the followers view controller.")
            }
            followersVC.navigationController?.title = self?.usernameField?.text
            followersVC.username = self?.usernameField?.text
            
            self?.getFollowersButton.transform = .identity
            
            
            if self?.usernameField?.text != ""{
                self?.navigationController?.pushViewController(followersVC, animated: true)
                self?.removeSpinner()
            }else{
                let ac = UIAlertController(title: "Textfield is Empty", message: "Please enter the valid username", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.removeSpinner()
                self?.present(ac, animated: true)
            }
        }
        
        
    }
    
}

