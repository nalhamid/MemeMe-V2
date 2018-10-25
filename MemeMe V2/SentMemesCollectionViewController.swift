//
//  SentMemesCollectionViewController.swift
//  MemeMe V2
//
//  Created by Moviefreak89 on 24/10/2018.
//  Copyright © 2018 Moviefreak89. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // Mark: get memes
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // Mark: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set space sizes
        let space:CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
        
        //add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showMemeEditor))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    // Mark: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //reload memes
        collectionView.reloadData()
    }
    
    // Mark: numberOfItemsInSection
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // Mark: cellForItemAt
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        //set image
        cell.image.image = meme.memedImage
        
        return cell
    }
    
    // Mark: showMemeEditor
    @objc func showMemeEditor(){
        let controller: UINavigationController
        controller = storyboard?.instantiateViewController(withIdentifier: "memeEditorNavigation") as! UINavigationController
        
        present(controller, animated: true, completion: nil)
    }
    
    // Mark: collectionView
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
}
