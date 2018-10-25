//
//  SentMemesTableViewController.swift
//  MemeMe V2
//
//  Created by Moviefreak89 on 24/10/2018.
//  Copyright © 2018 Moviefreak89. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    // Mark: get memes
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showMemeEditor))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    // Mark: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //reload memes
        tableView.reloadData()
    }
    // Mark: numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // Mark: cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // Mark: showMemeEditor
    @objc func showMemeEditor(){
        let controller: UINavigationController
        controller = storyboard?.instantiateViewController(withIdentifier: "memeEditorNavigation") as! UINavigationController
        
        present(controller, animated: true, completion: nil)
    }
    
}
