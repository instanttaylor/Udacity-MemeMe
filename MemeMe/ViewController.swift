//
//  ViewController.swift
//  MemeMe
//
//  Created by Taylor Smith on 9/22/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var bottomTextbottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText.delegate = self
        bottomText.delegate = self
        setupText()
        setupFunctionality()
        
    }
    
    func setupText() {
//        SETUP TEXT
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
//            THIS WHITE COLOR ISN'T SHOWING UP FOR SOME REASON. 
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: 2.0
        ]
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        topText.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        bottomText.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unSubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unSubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        moveViewForKeyboard(true, notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        moveViewForKeyboard(false, notification: notification)
    }
    
    func moveViewForKeyboard(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        
        if show {
            let changeInHeight = (CGRectGetHeight(keyboardFrame))
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.view.frame.origin.y -= changeInHeight
            })
        } else {
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.view.frame.origin.y = 0
            })
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        bottomText.resignFirstResponder()
        topText.resignFirstResponder()
        view.endEditing(true)
    }
//    func getKeyboardHeight(notification:NSNotification) -> CGFloat {
//        let userInfo = notification.userInfo
//        let info = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
//        return info.CGRectValue().size.height
//    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func takeAPicture(sender: AnyObject) {
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(camera, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage? {
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }

    
    @IBAction func cancelTapped(sender: AnyObject) {
        setupFunctionality()
    }
    
    func setupFunctionality() {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imageView.image = nil
        shareButton.enabled = false
    }
    
    @IBAction func shareTapped(sender: AnyObject) {
        
        topToolbar.hidden = true
        toolbar.hidden = true
        if let memedImage = generateMemedImage() {
            let av = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
            presentViewController(av, animated: true, completion: nil)
        }
        toolbar.hidden = false
        topToolbar.hidden = false
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            dispatch_async(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion: nil)
                self.imageView.image = image
                self.shareButton.enabled = true
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

extension ViewController: UINavigationControllerDelegate {
    
}

extension ViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 100 && textField.text == "" {
            textField.text = "TOP"
        } else if textField.tag == 101 && textField.text == "" {
            textField.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}