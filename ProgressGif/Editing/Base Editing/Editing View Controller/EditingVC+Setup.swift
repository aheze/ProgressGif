//
//  EditingVC+Setup.swift
//  ProgressGif
//
//  Created by Zheng on 7/17/20.
//

import UIKit
import Parchment

extension EditingViewController {
    func setUpPagingViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        loadConfig()
//        setUpPreview()
        
        titleTextField.text = project?.title
        
        editingBarVC = storyboard.instantiateViewController(withIdentifier: "EditingBarVC") as? EditingBarVC
        editingBarVC?.title = "Bar"
        editingBarVC?.originalBarHeight = editingConfiguration.barHeight
        editingBarVC?.originalBarForegroundColor = editingConfiguration.barForegroundColor
        editingBarVC?.originalBarBackgroundColor = editingConfiguration.barBackgroundColor
        
        editingBarVC?.editingBarChanged = self
        
        editingEdgesVC = storyboard.instantiateViewController(withIdentifier: "EditingEdgesVC") as? EditingEdgesVC
        editingEdgesVC?.title = "Edges"
        editingEdgesVC?.originalEdgeInset = editingConfiguration.edgeInset
        editingEdgesVC?.originalEdgeCornerRadius = editingConfiguration.edgeCornerRadius
        editingEdgesVC?.originalEdgeShadowIntensity = editingConfiguration.edgeShadowIntensity
        editingEdgesVC?.originalEdgeShadowRadius = editingConfiguration.edgeShadowRadius
        editingEdgesVC?.originalEdgeShadowColor = editingConfiguration.edgeShadowColor
        
        editingEdgesVC?.editingEdgesChanged = self
        
        /// options will be added in a later release
        //        let editingOptionsVC = storyboard.instantiateViewController(withIdentifier: "EditingOptionsVC") as! EditingOptionsVC
        //        editingOptionsVC.title = "Options"
        
        guard let editingBarViewController = editingBarVC,
            let editingEdgesViewController = editingEdgesVC else {
                return
        }
        
        let pagingViewController = PagingViewController(viewControllers: [
            editingBarViewController,
            editingEdgesViewController,
            //          editingOptionsVC
        ])
        
        pagingViewController.textColor = UIColor.label
        pagingViewController.selectedTextColor = UIColor(named: "YellorangeText") ?? UIColor.blue /// will look terrible but it won't happen
        
        pagingViewController.indicatorColor = UIColor(named: "Yellorange") ?? UIColor.blue
        pagingViewController.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        pagingViewController.selectedFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        pagingViewController.borderColor = UIColor.systemFill /// the border line below the menu buttons
        
        pagingViewController.backgroundColor = UIColor.systemBackground
        pagingViewController.selectedBackgroundColor = UIColor.systemBackground
        
        self.add(childViewController: pagingViewController, inView: bottomReferenceView)
    }
}
