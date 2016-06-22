//
//  ViewController.swift
//  MemeMe1
//
//  Created by Damonique Thomas on 6/12/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor(white:0.0, alpha:1.0),
        NSForegroundColorAttributeName : UIColor(white:1.0, alpha:1.0),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 50)!,
        NSStrokeWidthAttributeName : -8,
    ]
    
    var keyboardHeight :CGFloat!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topText.delegate = self
        topText.defaultTextAttributes = memeTextAttributes
        topText.text = "TOP"
        topText.textAlignment = .Center
        bottomText.delegate = self
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.text = "BOTTOM"
        bottomText.textAlignment = .Center
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }

    //Opens Camera
    @IBAction func viewCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Opens Album Image Picker
    @IBAction func viewAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Opens Activity view for sharing meme
    @IBAction func shareMeme(sender: AnyObject) {
        let image = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        save(image)
        self.presentViewController(activityController, animated: true, completion:nil)
    }

    //Clears text and image when Cancel is pressed
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imageView.image = nil
    }
    
    //Loads selected/captured image into image view
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //Clears text when first editing
    func textFieldDidBeginEditing(textField: UITextField){
        print(textField.text)
        if(textField.text == "TOP" || textField.text == "BOTTOM"){
            textField.text = "";
        }
    }
    
    //Keyboard hides when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        view.frame.origin.y = 0
        return true
    }

    //Subscribes keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }

    //Unsubscribes keyboard
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
    }

    //Adjusts the view for keyboard
    func keyboardWillShow(notification: NSNotification) {
        keyboardHeight = getKeyboardHeight(notification)
        if(bottomText.isFirstResponder()){
            self.view.frame.origin.y -= keyboardHeight
        }
    }

    //Returns the height of the keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.toolbarHidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.toolbarHidden = false
        
        return memedImage
    }
    
    //Saves Meme
    func save(memedImage:UIImage){
         _ = Meme(topText:topText.text!, bottomText:bottomText.text!, originalImage:imageView.image!, memedImage:memedImage)
    }

}