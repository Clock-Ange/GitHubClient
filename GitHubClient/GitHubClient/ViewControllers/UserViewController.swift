//
//  UserViewController.swift
//  GitHubClient
//
//  Created by Геннадий Махмудов on 12.07.2020.
//  Copyright © 2020 Геннадий Махмудов. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var followersNumber: UILabel!
    @IBOutlet weak var followingNumber: UILabel!
    
    
    var username: String?
    var avatar_url: String?
    var repos = [Repository]()
    var followers = [Follower]()
    var following = [Follower]()
    var starred = [Repository]()
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
        
        userImageView?.layer.cornerRadius = userImageView.frame.size.width / 2.0
        userImageView?.layer.borderColor = UIColor.systemTeal.cgColor
        userImageView?.layer.borderWidth = 2.0
        userImageView?.clipsToBounds = true
        
        if let name = username {
            title = name
            
            let starredURL = "https://api.github.com/users/\(name)/starred"
            let followersURL = "https://api.github.com/users/\(name)/followers"
            let followingURL = "https://api.github.com/users/\(name)/following"
            let reposURL = "https://api.github.com/users/\(name)/repos"
            let decoder = JSONDecoder()
            decoder.decode([Repository].self, fromURL: reposURL) {
                (repos) in
                self.repos = repos
            }
            decoder.decode([Follower].self, fromURL: followersURL) {
                (followers) in
                self.followers = followers
            }
            decoder.decode([Follower].self, fromURL: followingURL) {
                (following) in
                self.following = following
            }
            decoder.decode([Repository].self, fromURL: starredURL) {
                (starred) in
                self.starred = starred
            }
            followersNumber?.text = "\(followers.count)"
            followingNumber?.text = "\(following.count)"
            starsLabel?.text = "⭐️: \(starred.count)"
            
            
        }
        
        if let avatar = avatar_url {
            guard let customImage = userImageView as? CustomImageView else {
                fatalError("Could not downcast.")
            }
            customImage.load(urlString: avatar)
        }
        
    }
    @objc func chooseOption(){
        if let navController = self.tabBarController!.viewControllers![1] as? UINavigationController{
            guard let favoritesVC = navController.viewControllers[0] as? FavoritesViewController else{
                return
            }
            
            let ac = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
            
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
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                navigationController?.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
                present(ac, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? RepoTableViewCell else{
            fatalError("Could not make a RepoTableViewCell.")
        }
        let repo = repos[indexPath.item]
        
        cell.repoName?.text = "\(repo.name)"
        
        if let language = repo.language{
            cell.repoLanguage?.text! = language
            cell.chooseColor(ofLanguage: language)
        } else{
            cell.repoLanguage?.text! = ""
        }
        
        if let description = repo.description {
            cell.repoDescription?.text = description
        } else{
            cell.repoDescription?.text = ""
            
        }
        cell.layer.borderColor = UIColor.systemTeal.cgColor
        cell.layer.borderWidth = 1.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
}

extension UserViewController{
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

