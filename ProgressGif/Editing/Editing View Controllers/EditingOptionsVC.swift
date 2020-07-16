//
//  EditingOptionsVC.swift
//  ProgressGif
//
//  Created by Zheng on 7/15/20.
//

import UIKit

protocol EditingOptionsChanged: class {
    func barHeightChanged(to height: Int)
    func foregroundColorChanged(to color: UIColor)
    func backgroundColorChanged(to color: UIColor)
}

class EditingOptionsVC: UIViewController {
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
