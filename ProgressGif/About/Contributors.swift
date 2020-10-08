//
//  Contributors.swift
//  ProgressGif
//
//  Created by Zheng on 8/5/20.
//

import Foundation

// MARK: - All contributors to ProgressGif!
class Contributor: NSObject {
    
    /// name to display in the table view
    var name = "Bob"
    
    /// how many lines of code you added
    var additions = "10"
    
    /// how many lines of code you deleted
    var deletions = "1"
    
    var profileName = "You"
    /// name of the image that your link should display
    var linkImageName = "photos"
    
    /// the link to go to when clicked
    var link = URL(string: "https://google.com")
}

extension AboutViewController {
    
    // MARK: - Add your name here if you contributed!
    
    func populateContributors() {
        
        let aheze = Contributor()
        aheze.name = "Zheng"
        aheze.additions = "199,405"
        aheze.deletions = "29,470"
        aheze.profileName = "ahezeProfile"
        aheze.linkImageName = "Medium"
        if let profileURL = URL(string: "https://medium.com/@ahzzheng") {
            aheze.link = profileURL
        }
        contributors.append(aheze)
        
        let thejayhaykid = Contributor()
        thejayhaykid.name = "Jake"
        thejayhaykid.additions = "324"
        thejayhaykid.deletions = "244"
        thejayhaykid.profileName = "thejayhaykidProfile"
        thejayhaykid.linkImageName = "GitHub"
        if let profileURL = URL(string: "https://github.com/thejayhaykid") {
            thejayhaykid.link = profileURL
        }
        contributors.append(thejayhaykid)
        
        let you = Contributor()
        you.name = "You could be here!"
        you.additions = "??"
        you.deletions = "??"
        you.profileName = "You"
        you.linkImageName = "GitHub"
        if let profileURL = URL(string: "https://github.com/aheze/ProgressGif") {
            you.link = profileURL
        }
        contributors.append(you)
    }
}
