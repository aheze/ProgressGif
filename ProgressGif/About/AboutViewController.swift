//
//  AboutViewController.swift
//  ProgressGif
//
//  Created by Zheng on 8/5/20.
//

import UIKit

// MARK: - the view that appears when you press "ProgressGif"
/// contains metadata like licenses and contributors!
class AboutViewController: UIViewController {
    @IBAction func xPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
        
        /// this is ProgressGif's App Store URL
        if let productURL = URL(string: "https://apps.apple.com/app/id1526969349") {
            var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
            
            components?.queryItems = [
                URLQueryItem(name: "action", value: "write-review")
            ]
            guard let writeReviewURL = components?.url else {
                return
            }
            
            /// open App Store to rate
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
        
        lightenView(view: view)
        
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
        cell.additionsLabel.text = "\(contributor.additions.delimiter) ++"
        cell.deletionsLabel.text = "\(contributor.deletions.delimiter) --"
        if let profileImage = UIImage(named: contributor.profileName) {
            cell.profileImageView.image = profileImage
        }
        
        if !contributor.linkSfSymbols {
            if let linkImage = UIImage(named: contributor.linkImageName)?.withRenderingMode(.alwaysOriginal) {
                cell.linkButton.setImage(linkImage, for: .normal)
            }
        } else {
            if let symbolImage = UIImage(systemName: contributor.linkImageName)? {
                cell.linkButton.setImage(symbolImage, for: .normal)
            }
        }
        cell.link = contributor.link
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension Int {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter
    }()

    var delimiter: String {
        return Int.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
