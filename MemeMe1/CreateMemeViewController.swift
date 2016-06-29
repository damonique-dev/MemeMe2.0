//
//  ViewController.swift
//  MemeMe1
//
//  Created by Damonique Thomas on 6/12/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var meme: Meme?

    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor(white:0.0, alpha:1.0),
        NSForegroundColorAttributeName : UIColor(white:1.0, alpha:1.0),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 50)!,
        NSStrokeWidthAttributeName : -3.0,
    ]
    
    var keyboardHeight :CGFloat!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField(topText)
        setUpTextField(bottomText)
        if let memeImage = meme {
            topText.text = memeImage.topText
            bottomText.text = memeImage.bottomText
            imageView.image = memeImage.originalImage
            shareButton.enabled = true
            print(topText.text)
            print(bottomText.text)
        }
        else {
            topText.text = "TOP"
            bottomText.text = "BOTTOM"
            shareButton.enabled = false
        }
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
    }
    
    //Sets up text fields
    func setUpTextField(textfield: UITextField) {
        textfield.delegate = self
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .Center
    }

    //Opens Camera
    @IBAction func viewCamera(sender: AnyObject) {
        setUpPicker(UIImagePickerControllerSourceType.Camera)
    }
    
    //Opens Album Image Picker
    @IBAction func viewAlbum(sender: AnyObject) {
        setUpPicker(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    //Sets up and presents image picker controller
    func setUpPicker(source: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Opens Activity view for sharing meme
    @IBAction func shareMeme(sender: AnyObject) {
        let image = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (string, ok, items, err) -> Void in
            if ok {
                let meme = Meme(topText:self.topText.text!, bottomText:self.bottomText.text!, originalImage:self.imageView.image!, memedImage:image)
                // Add it to the memes array in the Application Delegate
                let object = UIApplication.sharedApplication().delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(meme)
                self.backToRoot()
            }
        }
        presentViewController(activityController, animated: true, completion:nil)
    }

    //Clears text and image when Cancel is pressed
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imageView.image = nil
        shareButton.enabled = false
        backToRoot()
    }
    
    //Loads selected/captured image into image view
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
            shareButton.enabled = true
        }
    }
    
    //Clears text when first editing
    func textFieldDidBeginEditing(textField: UITextField){
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateMemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }

    //Unsubscribes keyboard
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
    }

    //Adjusts the view for keyboard
    func keyboardWillShow(notification: NSNotification) {
        keyboardHeight = getKeyboardHeight(notification) * -1
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
        navigationController?.navigationBarHidden = true
        navigationController?.toolbarHidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navigationController?.navigationBarHidden = false
        navigationController?.toolbarHidden = false
        
        return memedImage
    }
    
    func backToRoot() {
        let tabController = self.storyboard!.instantiateViewControllerWithIdentifier("tabBar")
        UIApplication.sharedApplication().keyWindow?.rootViewController = tabController
    }

}