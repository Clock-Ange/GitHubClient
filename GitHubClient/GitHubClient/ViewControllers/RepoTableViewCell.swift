//
//  RepoTableViewCell.swift
//  GitHubClient
//
//  Created by Геннадий Махмудов on 19.07.2020.
//  Copyright © 2020 Геннадий Махмудов. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func chooseColor(ofLanguage language: String){
        switch language{
        case "JavaScript":
            repoLanguage.textColor = UIColor.systemOrange
            break
        case "Python":
            repoLanguage.textColor = UIColor.systemBlue
            break
        case "Java":
            repoLanguage.textColor = UIColor.systemBlue
            break
        case "C++":
            repoLanguage.textColor = UIColor.systemIndigo
            break
        case "C":
            repoLanguage.textColor = UIColor.systemIndigo
            break
        case "PHP":
            repoLanguage.textColor = UIColor.systemPurple
            break
        case "C#":
            repoLanguage.textColor = UIColor.systemPurple
            break
        case "Shell":
            repoLanguage.textColor = UIColor.systemGray6
            break
        case "Go":
            repoLanguage.textColor = UIColor.cyan
            break
        case "TypeScript":
            repoLanguage.textColor = UIColor.systemBlue
            break
        case "Ruby":
            repoLanguage.textColor = UIColor.systemRed
            break
        case "Jupyter Notebook":
            repoLanguage.textColor = UIColor.systemOrange
            break
        case "Objective-C":
            repoLanguage.textColor = UIColor.lightGray
            break
        case "Swift":
            repoLanguage.textColor = UIColor.systemRed
            break
        case "Kotlin":
            repoLanguage.textColor = UIColor.orange
            break
        case "R":
            repoLanguage.textColor = UIColor.lightGray
            break
        case "Scala":
            repoLanguage.textColor = UIColor.systemRed
            break
        case "Rust":
            repoLanguage.textColor = UIColor.systemOrange
            break
        case "Lua":
            repoLanguage.textColor = UIColor.blue
            break
        case "Matlab":
            repoLanguage.textColor = UIColor.orange
            break
        case "PowerShell":
            repoLanguage.textColor = UIColor.systemGray4
            break
        case "CoffeeScript":
            repoLanguage.textColor = UIColor.brown
            break
        case "Perl":
            repoLanguage.textColor = UIColor.systemPurple
            break
        case "Groovy":
            repoLanguage.textColor = UIColor.systemPink
            break
        case "Haskell":
            repoLanguage.textColor = UIColor.systemGreen
            break
        case "HTML":
            repoLanguage.textColor = UIColor.systemGreen
            break
        default:
            repoLanguage.textColor = UIColor(displayP3Red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
            break
        }
    }
    
}
