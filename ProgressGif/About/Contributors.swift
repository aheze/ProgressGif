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
    var name = "You"
    
    /// How many lines of code you added
    var additions = "10"
    
    /// How many lines of code you deleted
    var deletions = "1"
    
    /// Image name (should match the filename in Contributing.xcassets)
    var profileName = "You"
    
    /// Whether to use treat linkImageName as a SF Symbol
    var linkSfSymbol = false
    
    /// Media image (Medium, GitHub, etc)
    var linkImageName = "GitHub"
    
    /// The link to navigate to on click
    var link = URL(string: "https://github.com")
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
        
        let hkamran = Contributor()
        hkamran.name = "H. Kamran"
        hkamran.additions = ""
        hkamran.deletions = ""
        hkamran.profileName = "You"
        hkamran.linkSfSymbol = true
        hkamran.linkImageName = "link.circle.fill"
        if let profileURL = URL(string: "https://hkamran.com") {
            hkamran.link = profileURL
        }
        contributors.append(hkamran)
        
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
