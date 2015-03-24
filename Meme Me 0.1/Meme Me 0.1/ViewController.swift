//
//  ViewController.swift
//  Meme Me 0.1
//
//  Created by Thiago Graça Couto Braun on 3/23/15.
//  Copyright (c) 2015 GCBraun. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
        @IBOutlet weak var toolBar: UIToolbar!
    
    var imagePicker = UIImagePickerController()
    var memedImage : UIImage!
    
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -2.0
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textTop.textAlignment = NSTextAlignment.Center
        textBottom.textAlignment = NSTextAlignment.Center
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       println("view did load")
        shareButton.enabled = false
        pickButton.enabled = true
        cameraButton.enabled = true
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable    (UIImagePickerControllerSourceType.Camera)
        textTop.delegate = self
        //textTop.text = "Top Text"
        textTop.defaultTextAttributes = memeTextAttributes
        
        textBottom.delegate = self
        //textBottom.text = "Bottom Text"
        textBottom.defaultTextAttributes = memeTextAttributes
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickImage(sender: UIBarButtonItem) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
    
            imageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
            
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
        
    }
 
    @IBAction func takePicture(sender: UIBarButtonItem) {
        
               
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
     
        
     self.unsubscribeFromKeyboardNotifications()
     generateMemedImage()
        
        var imageArray : [UIImage] = [memedImage]
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: imageArray, applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:Array!, error:NSError!) in
            
            if completed {
                    self.save()
                    println("activity completed")
                    self.dismissViewControllerAnimated(true, completion: {});
                    return
                
            }
        }
        
        presentViewController(activityViewController, animated: true, completion: nil)
        
        
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        imageView.image = image
        pickButton.enabled = false
        cameraButton.enabled = false
        shareButton.enabled = true
        
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField!) {    //delegate method
        if textField == textTop {
            self.unsubscribeFromKeyboardNotifications()
            println("text top selected")
        } else if textField == textBottom {
            self.unsubscribeFromKeyboardNotifications()
            self.subscribeToKeyboardNotifications()
            println("text bottom selected")
            
        }
   
    }
   
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
         self.view.endEditing(true)
        return false
    }
    
    override func shouldAutorotate() -> Bool {
                return false;
        
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    func generateMemedImage() -> UIImage
    {
        // Render view to an image
        self.navigationController?.navigationBar.hidden = true
        toolBar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        memedImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController?.navigationBar.hidden = false
        toolBar.hidden = false
        
        println("meme image generated")
        return memedImage
    }
    
    func save() {
        //Create the meme
        var meme = Meme(text1: textTop.text!, text2: textBottom.text!, image:
            imageView.image!, memedImage: memedImage)
        (UIApplication.sharedApplication().delegate as AppDelegate).memes.append(meme)
        println("meme object saved")
        println((UIApplication.sharedApplication().delegate as AppDelegate).memes.count)
    }
    
}

