//
//  ViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    var projects = [Project]()
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var addButtonIsPressed = false
    @IBOutlet weak var addButton: CustomButton!
    @IBAction func addButtonTouchDown(_ sender: Any) {
        handleAddButtonTouchDown()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        handleAddButtonPress()
    }
    
    @IBAction func addButtonTouchUpOutside(_ sender: Any) {
        handleAddButtonTouchUpOutside()
    }
    
    private lazy var collectionViewController: CollectionViewController? = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController {
            
            viewController.projects = self.projects
            viewController.topInset = visualEffectView.frame.height
            viewController.collectionType = .projects
            
            // Add View Controller as Child View Controller
//            self.add(asChildViewController: viewController)
            
            self.add(childViewController: viewController, inView: view)
            
            return viewController
        } else {
            return nil
        }
        
    }()
    
    
    @IBOutlet weak var importVideoLabel: UILabel!
    @IBOutlet weak var importVideoBottomC: NSLayoutConstraint! /// 26
    let importVideoBottomCShownConstant = CGFloat(32)
    let importVideoBottomCHiddenConstant = CGFloat(26)
    
    @IBOutlet weak var filesButton: CustomButton!
    @IBOutlet weak var photosButton: CustomButton!
    @IBOutlet weak var clipboardButton: CustomButton!
    
    @IBAction func filesTouchDown(_ sender: Any) {
        filesButton.scaleDown()
    }
    
    @IBAction func filesPressed(_ sender: Any) {
        filesButton.scaleUp()
        handleAddButtonPress()
    }
    
    @IBAction func filesTouchUpOutside(_ sender: Any) {
        filesButton.scaleUp()
    }
    
    
    @IBAction func photosTouchDown(_ sender: Any) {
        photosButton.scaleDown()
    }
    
    @IBAction func photosPressed(_ sender: Any) {
        photosButton.scaleUp()
        importVideo()
        handleAddButtonPress()
    }
    
    @IBAction func photosTouchUpOutside(_ sender: Any) {
        photosButton.scaleUp()
        
    }
    
    @IBAction func clipboardTouchDown(_ sender: Any) {
        clipboardButton.scaleDown()
    }
    @IBAction func clipboardPressed(_ sender: Any) {
        clipboardButton.scaleUp()
        handleAddButtonPress()
    }
    @IBAction func clipboardTouchUpOutside(_ sender: Any) {
        clipboardButton.scaleUp()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpButtonAlpha()
        
        
        
        for _ in 0...5 {
            
            let project = Project()
            project.title = "Title"
            projects.append(project)
        }
        
        _ = collectionViewController
        
    }


}






