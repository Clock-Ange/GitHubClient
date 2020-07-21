//
//  FavoritesViewController.swift
//  GitHubClient
//
//  Created by Геннадий Махмудов on 19.07.2020.
//  Copyright © 2020 Геннадий Махмудов. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var favorites = [Follower]()
    var currentFollowers = [Follower]() // For search bar
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "favorites") as? Data{
            let decoder = JSONDecoder()
            
            do{
                favorites = try decoder.decode([Follower].self, from: savedData)
            }catch{
                print("Failed to load favorites.")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        currentFollowers = favorites
        collectionView?.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentFollowers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoritesViewCell else{
            fatalError("Couldn't make a FavoriteCell.")
        }
        let follower = currentFollowers[indexPath.item]
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        collectionView.contentInset = adjustForTabbarInsets
        collectionView.scrollIndicatorInsets = adjustForTabbarInsets
        
        
        guard let customImage = cell.favoriteImageView as? CustomImageView else{ fatalError("Make")}
        customImage.load(urlString: follower.avatar_url)
        customImage.layer.cornerRadius = 10.0
        cell.favoriteLabel?.text = follower.login
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.showSpinner()
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "UserInfo") as? UserViewController else {
            fatalError("Could not instantiate UserViewController.")
        }
        DispatchQueue.global().async {
            
            
            let user = self.currentFollowers[indexPath.item]
            vc.username = user.login
            vc.avatar_url = user.avatar_url
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.removeSpinner()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

// For a proper display of collection view
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
    }
}

// Search bar
extension FavoritesViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            currentFollowers = favorites
            collectionView?.reloadData()
            return
        }
        currentFollowers = favorites.filter({ (follower) -> Bool in
            return follower.login.lowercased().contains(searchText.lowercased())
        })
        collectionView?.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}
