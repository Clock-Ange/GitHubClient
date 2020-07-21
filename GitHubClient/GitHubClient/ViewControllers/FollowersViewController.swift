//
//  FollowersViewController.swift
//  GitHubClient
//
//  Created by Геннадий Махмудов on 11.07.2020.
//  Copyright © 2020 Геннадий Махмудов. All rights reserved.
//

import UIKit

class FollowersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var followers = [Follower]()
    var currentFollowers = [Follower]() // For search bar
    var username: String?
    
    var dataToLoad = [Follower]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "favorites") as? Data{
            let decoder = JSONDecoder()
            
            do{
                dataToLoad = try decoder.decode([Follower].self, from: savedData)
            }catch{
                print("Failed to load favorites.")
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(chooseOption))
        
        navigationItem.largeTitleDisplayMode = .always
        tabBarController?.tabBar.isHidden = false
//        edgesForExtendedLayout = []
        
        navigationController?.isNavigationBarHidden = false
        if let name = username {
            title = name
            let url = "https://api.github.com/users/\(name)/followers"
            let decoder = JSONDecoder() 
            decoder.decode([Follower].self, fromURL: url) {
                (followers) in
                self.followers = followers
            }
        }
        currentFollowers = followers
        
    }
    
    @objc func chooseOption(){
        let ac = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
        let navController = self.tabBarController!.viewControllers![1] as! UINavigationController
        let favoritesVC = navController.topViewController as! FavoritesViewController
        //        guard let favoritesVC = storyboard?.instantiateViewController(withIdentifier: "FavoritesController") as? FavoritesViewController else{
        //            fatalError("Could not instantiate FavoritesViewController.")
        //        }
        if let name = username{
            var actionTitle = ""
            
            let decoder = JSONDecoder()
            let url = "https://api.github.com/users/\(name)"
            decoder.decode(Follower.self, fromURL: url) {
                (user) in
                if favoritesVC.favorites.contains(user){
                    actionTitle = "Remove From Favorites"
                } else{
                    actionTitle = "Add To Favorites"
                }
                ac.addAction(UIAlertAction(title: "See profile", style: .default, handler: {[weak self] (_) in
                    guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "UserInfo") as? UserViewController else {
                        fatalError("Could not instantiate UserViewController.")
                    }
                    
                    vc.username = user.login
                    vc.avatar_url = user.avatar_url
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }))
                
                ac.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (_) in
                    if !self.dataToLoad.contains(user){
                        self.dataToLoad.append(user)
                        self.save()
                        favoritesVC.favorites = self.dataToLoad
                    }else{
                        if let index = self.dataToLoad.firstIndex(of: user){
                            self.dataToLoad.remove(at: index)
                            self.save()
                            favoritesVC.favorites = self.dataToLoad
                        }
                    }
                }))
            }
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        navigationController?.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentFollowers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell else{
            fatalError("There is no such cell")
        }
        let follower = currentFollowers[indexPath.item]
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        collectionView.contentInset = adjustForTabbarInsets
        collectionView.scrollIndicatorInsets = adjustForTabbarInsets
        
        
        guard let customImage = cell.imageView as? CustomImageView else{ fatalError("Make")}
        customImage.load(urlString: follower.avatar_url)
        customImage.layer.cornerRadius = 10.0
        cell.personLabel?.text = follower.login
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "UserInfo") as? UserViewController else {
            fatalError("Could not instantiate UserViewController.")
        }
        self.showSpinner()
        DispatchQueue.global().async {
            
            let user = self.currentFollowers[indexPath.item]
            vc.username = user.login
            vc.avatar_url = user.avatar_url
            DispatchQueue.main.async {
                self.removeSpinner()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    @IBAction func followSegmentedControlTapped(_ sender: UISegmentedControl) {
        
        //        sender.addTarget(self, action: #selector(addSpinner), for: .valueChanged)
        
        self.showSpinner()
        
        switch sender.selectedSegmentIndex {
        case 0:
            DispatchQueue.global().async {
                if let name = self.username {
                    let url = "https://api.github.com/users/\(name)/followers"
                    let decoder = JSONDecoder()
                    decoder.decode([Follower].self, fromURL: url) {
                        (followers) in
                        DispatchQueue.main.async {
                            self.followers = followers
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        self.currentFollowers = self.followers
                        self.removeSpinner()
                    }
                    
                    
                }
            }
            
        case 1:
            DispatchQueue.global().async {
                if let name = self.username {
                    let url = "https://api.github.com/users/\(name)/following"
                    let decoder = JSONDecoder()
                    decoder.decode([Follower].self, fromURL: url) {
                        (followers) in
                        DispatchQueue.main.async {
                            self.followers = followers
                            
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        self.currentFollowers = self.followers
                        self.removeSpinner()
                    }
                    
                    
                }
            }
            
        default:
            break
        }
    }
    
}

// For a proper display of collection view
extension FollowersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
    }
}

// Search bar
extension FollowersViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            currentFollowers = followers
            collectionView?.reloadData()
            return
        }
        currentFollowers = followers.filter({ (follower) -> Bool in
            return follower.login.lowercased().contains(searchText.lowercased())
        })
        collectionView?.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

extension FollowersViewController{
    func save(){
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(dataToLoad){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "favorites")
        }else{
            print("Failed to save data.")
        }
    }
}
