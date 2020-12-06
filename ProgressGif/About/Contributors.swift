//
//  Contributors.swift
//  ProgressGif
//
//  Created by Zheng on 8/5/20.
//

import Foundation

// MARK: - All contributors to ProgressGif!
class Contributor: NSObject {
    /// Display name
    var name = "You"
    
    /// How many lines of code you added
    var additions = 10
    
    /// How many lines of code you deleted
    var deletions = 1
    
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
        aheze.additions = 204606
        aheze.deletions = 32811
        aheze.profileName = "ahezeProfile"
        aheze.linkImageName = "Medium"
        if let profileURL = URL(string: "https://aheze.medium.com/") {
            aheze.link = profileURL
        }
        contributors.append(aheze)
        
        let hkamran = Contributor()
        hkamran.name = "H. Kamran"
        hkamran.additions = 1423
        hkamran.deletions = 157562
        hkamran.profileName = "You"
        hkamran.linkSfSymbol = true
        hkamran.linkImageName = "link.circle.fill"
        if let profileURL = URL(string: "https://hkamran.com") {
            hkamran.link = profileURL
        }
        contributors.append(hkamran)
        
        let thejayhaykid = Contributor()
        thejayhaykid.name = "Jake"
        thejayhaykid.additions = 473
        thejayhaykid.deletions = 388
        thejayhaykid.profileName = "thejayhaykidProfile"
        thejayhaykid.linkImageName = "GitHub"
        if let profileURL = URL(string: "https://github.com/thejayhaykid") {
            thejayhaykid.link = profileURL
        }
        contributors.append(thejayhaykid)
        
        let tiannahenrylewis = Contributor()
        tiannahenrylewis.name = "Tianna Henry-Lewis"
        tiannahenrylewis.additions = 107
        tiannahenrylewis.deletions = 73
        tiannahenrylewis.profileName = "tiannahenrylewisProfile"
        tiannahenrylewis.linkImageName = "Medium"
        if let profileURL = URL(string: "https://tiannahenrylewis.medium.com/") {
            tiannahenrylewis.link = profileURL
        }
        contributors.append(tiannahenrylewis)

        let janakshah = Contributor()
        janakshah.name = "Janak Shah"
        janakshah.additions = 31
        janakshah.deletions = 15
        janakshah.profileName = "You"
        janakshah.linkSfSymbol = true
        janakshah.linkImageName = "link.circle.fill"
        if let profileURL = URL(string: "https://janakshah.com") {
            janakshah.link = profileURL
        }
        contributors.append(janakshah)
        
        /// If you contributed, add yourself here!

        let you = Contributor()
        you.name = "Your name here"
        you.additions = 0
        you.deletions = 0
        you.profileName = "You"
        you.linkImageName = "GitHub"
        if let profileURL = URL(string: "https://github.com/aheze/ProgressGif") {
            you.link = profileURL
        }
        contributors.append(you)
    }
}
