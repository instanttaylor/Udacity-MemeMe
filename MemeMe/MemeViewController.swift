//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Taylor Smith on 9/22/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var bottomTextbottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText.delegate = self
        bottomText.delegate = self
        setupText(topText)
        setupText(bottomText)
        setupFunctionality()
    }
    
    func setupText(field: UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0
        ]
        field.defaultTextAttributes = memeTextAttributes
        field.textAlignment = .Center
        field.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        tabBarController?.hidesBottomBarWhenPushed = true
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        unSubscribeFromKeyboardNotifications()
        setupFunctionality()
        super.viewWillDisappear(true)
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
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        
        if show {
            let changeInHeight = (CGRectGetHeight(keyboardFrame))
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.view.frame.origin.y = -changeInHeight
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
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func takeAPicture(sender: AnyObject) {
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(camera, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage? {
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }

    func save(memedImage: UIImage) {
        let meme = Meme(top: topText.text!, bottom: bottomText.text!, image: imageView.image!, memedImage: memedImage)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
    }
    
    func setupFunctionality() {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imageView.image = nil
        shareButton.enabled = false
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareTapped(sender: AnyObject) {
        topToolbar.hidden = true
        toolbar.hidden = true
        if let memedImage = generateMemedImage() {
            let av = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
            av.completionWithItemsHandler = { (_, success, _, _) in
                if success {
                    self.save(memedImage)
                }
            }
            presentViewController(av, animated: true, completion: nil)
        }
        topToolbar.hidden = false
        toolbar.hidden = false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}



extension MemeViewController: UIImagePickerControllerDelegate {
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension MemeViewController: UINavigationControllerDelegate {
    
}

extension MemeViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 101 {
            subscribeToKeyboardNotifications()
        }
        return true
    }

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
        unSubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}