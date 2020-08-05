//
//  AboutTableCell.swift
//  ProgressGif
//
//  Created by Zheng on 8/5/20.
//

import UIKit

class AboutTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var additionsLabel: UILabel!
    @IBOutlet weak var deletionsLabel: UILabel!
    
    var link = URL(string: "https://google.com")
    @IBOutlet weak var linkButton: UIButton!
    @IBAction func linkButtonPressed(_ sender: Any) {
        if let urlToOpen = link {
            UIApplication.shared.open(urlToOpen)
        }
    }
    
}

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
