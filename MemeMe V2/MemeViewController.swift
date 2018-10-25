//
//  MemeViewController.swift
//  MemeMe V1
//
//  Created by Moviefreak89 on 18/10/2018.
//  Copyright © 2018 Moviefreak89. All rights reserved.
//
import Foundation
import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // mark: list of outlets
    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    
   
    // mark: set default text attributes
    let memeTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)! ,
        NSAttributedString.Key.strokeWidth: -4
        ] as [NSAttributedString.Key: Any]

    
    // mark: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkCamera()
    }
    
    // mark: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //share button
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
        self.navigationItem.leftBarButtonItem = shareButton
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        //share button
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelMeme))
        self.navigationItem.rightBarButtonItem = cancelButton
        
        // call setTextfield methods
        setTextfield(topTextfield,textValue:  "TOP")
        setTextfield(bottomTextfield,textValue:  "BOTTOM")
        
    }
    
    // mark: Check camera in device
    func checkCamera(){
        //disable camera button if the device is not supported
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // mark: setTextfield
    // set default textfiels attributes and assign text
    func setTextfield (_ Textfield: UITextField, textValue: String){
        
        Textfield.defaultTextAttributes = memeTextAttributes
        Textfield.text = textValue
        Textfield.textAlignment = NSTextAlignment.center
        //assign delegate
        Textfield.delegate = self
        
    }
    
    // mark: pickImageFromAlbum
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        getImage(type: .photoLibrary)
    }
    
    // mark: pickImageFromCamera
    @IBAction func pickImageFromCamera(_ sender: Any) {
        getImage(type: .camera)
    }
    
    // mark: imagePickerController
    //after picking set imageViewer to the picked picture
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info [.originalImage] as? UIImage{
            imageViewer.image = image
        }
        dismiss(animated: true, completion: nil)
        //enable share button
        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
    // mark: imagePickerControllerDidCancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // mark: getImage
    //open photo library or camera depanding on source type
    func getImage (type: UIImagePickerController.SourceType ){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    // mark: textFieldShouldBeginEditing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if ((textField.text == "TOP") || (textField.text == "BOTTOM")){
            textField.text = ""
        }
        if (textField == bottomTextfield){
            //subscribeToKeyboardNotifications to move view
            subscribeToKeyboardNotifications()
        }
    }
    
    // mark: textFieldShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == bottomTextfield){
            //unsubscribeToKeyboardNotifications to move back view
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    // mark: keyboardWillShow
    @objc func keyboardWillShow(_ notification:Notification) {
        
        //move up with keyboaed size
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    // mark: keyboardWillHide
    @objc func keyboardWillHide(_ notification:Notification) {
        //set back to zero
        view.frame.origin.y = 0
    }
    
    // mark: getKeyboardHeight
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return (keyboardSize.cgRectValue.height - 30)
    }
    
    // mark: subscribeToKeyboardNotifications
    func subscribeToKeyboardNotifications() {
        //subscribe To Keyboard will show
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //subscribe To Keyboard will hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // mark: unsubscribeFromKeyboardNotifications
    func unsubscribeFromKeyboardNotifications() {
        //unsubscribe To Keyboard will show
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        //unsubscribe To Keyboard will hide
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // mark: viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // mark: generateMemedImage
    func generateMemedImage() -> UIImage {
        
        //hide navagation Bar and bottom toolbar
        hideBars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //show navagation Bar and bottom toolbar
        hideBars(false)
        
        return memedImage
    }
    
    // mark: hideBars
    func hideBars (_ hide: Bool){
        self.navigationController?.isNavigationBarHidden = hide
        bottomToolbar.isHidden = hide
    }
    
    // mark: save Image
    func saveMeme(_ memedImage: UIImage){
        //create meme
        let meme = Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, orignalImage: imageViewer.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // mark: share memed image
    @objc func shareMeme() {
        //get memed image
        let memedImage = generateMemedImage()
        //show activity view
        let activityViewer = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewer.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                return
            }
            // User completed activity
            self.saveMeme(memedImage)
            //return
            self.dismiss(animated: true, completion: nil)
        }
        self.present(activityViewer, animated: true, completion: nil)
        //for ipads view
        if let popOver = activityViewer.popoverPresentationController {
            popOver.sourceView = self.view
        }
    }
    
    // mark: cancelMeme
    @objc func cancelMeme(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

