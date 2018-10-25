//
//  DetailsViewController.swift
//  MemeMe V2
//
//  Created by Moviefreak89 on 25/10/2018.
//  Copyright © 2018 Moviefreak89. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    // Mark: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideTabBar(true)
        self.imageView.image = meme.memedImage
        
    }
    
    // Mark: viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideTabBar(false)
    }
    
    // Mark: hideTabBar
    func hideTabBar(_ status: Bool){
        self.tabBarController?.tabBar.isHidden = status
    }

}
