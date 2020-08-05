//
//  AboutViewController.swift
//  ProgressGif
//
//  Created by Zheng on 8/5/20.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var tableView: SelfSizedTableView!
    
    @IBOutlet weak var reportIssueBlurView: UIVisualEffectView!
    @IBOutlet weak var reportIssueButton: UIButton!
    @IBAction func reportIssuePressed(_ sender: Any) {
        let link = URL(string: "https://github.com/aheze/ProgressGif/issues")
        if let urlToOpen = link {
            UIApplication.shared.open(urlToOpen)
        }
    }
    
    
    @IBOutlet weak var rateAppBlurView: UIVisualEffectView!
    @IBOutlet weak var rateAppButton: UIButton!
    @IBAction func rateAppPressed(_ sender: Any) {
        if let productURL = URL(string: "https://apps.apple.com/app/id1506500202") {
            var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
            
            // 2.
            components?.queryItems = [
                URLQueryItem(name: "action", value: "write-review")
            ]
            
            // 3.
            guard let writeReviewURL = components?.url else {
                return
            }
            
            // 4.
            UIApplication.shared.open(writeReviewURL)
        }
    }
    
    @IBOutlet weak var sourceCodeBlurView: UIVisualEffectView!
    @IBOutlet weak var sourceCodeButton: UIButton!
    @IBAction func sourceCodePressed(_ sender: Any) {
        let link = URL(string: "https://github.com/aheze/ProgressGif")
        if let urlToOpen = link {
            UIApplication.shared.open(urlToOpen)
        }
    }
    
    @IBOutlet weak var licensesBlurView: UIVisualEffectView!
    @IBOutlet weak var licensesButton: UIButton!
    @IBAction func licensesPressed(_ sender: Any) {
        presentLicenses()
    }
    
    var contributors = [Contributor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateContributors()
        
        tableView.maxHeight = 400
        tableView.delegate = self
        tableView.dataSource = self
        
        reportIssueBlurView.layer.cornerRadius = 6
        reportIssueBlurView.clipsToBounds = true
        rateAppBlurView.layer.cornerRadius = 6
        rateAppBlurView.clipsToBounds = true
        sourceCodeBlurView.layer.cornerRadius = 6
        sourceCodeBlurView.clipsToBounds = true
        licensesBlurView.layer.cornerRadius = 6
        licensesBlurView.clipsToBounds = true
    }
    
}

extension AboutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCellID", for: indexPath) as! AboutTableCell
        let contributor = contributors[indexPath.row]
        cell.nameLabel.text = contributor.name
        cell.additionsLabel.text = "\(contributor.additions) ++"
        cell.deletionsLabel.text = "\(contributor.deletions) --"
        if let profileImage = UIImage(named: contributor.profileName) {
            cell.profileImageView.image = profileImage
        }
        if let linkImage = UIImage(named: contributor.linkImageName)?.withRenderingMode(.alwaysOriginal) {
            cell.linkButton.setImage(linkImage, for: .normal)
        }
        cell.link = contributor.link
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
