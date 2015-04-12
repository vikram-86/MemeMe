//
//  ViewController.swift
//  MemeMe
//
//  Created by Suthananth Arulanantham on 06.04.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //Screen Items
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // Delegates
    let textDelegate = TextDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.topText.delegate = self.textDelegate
        self.bottomText.delegate = self.textDelegate
        
        // enabling buttons
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.shareButton.enabled = false
        self.cancelButton.enabled = self.returnMemeList().count > 0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // instantiates a new viewcontroller when the user touches the cancel button
    @IBAction func cancelButtonTouched(sender: UIBarButtonItem) {
        let list = self.returnMemeList()
        if list.count == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("memeEditor") as! MemeEditorViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
        else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func shareButtonTouched(sender: UIBarButtonItem) {
        var activityVC = UIActivityViewController(activityItems: [self.generateMemeImage()], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(s : String!,completed : Bool, items:[AnyObject]!, error:NSError!) in
            self.showSentMemeController()
        }
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    /****************************************************************************************
    *                                                                                       *
    *                              UIIMAGE PICKER                                           *
    *                                                                                       *
    ****************************************************************************************/
    
    // opens the native camera app if the user touches the camera button
    @IBAction func cameraButtonTouched(sender: AnyObject) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.Camera
        controller.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // opens the saved photo library if the user touched the library button
    @IBAction func libraryButtonTouched(sender: AnyObject) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // store image in imageView when selected
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.img.image = chosenImage
        self.shareButton.enabled = true     // enabling the share button sice we have a image to share
        self.cancelButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // if user cancels image selection
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    /****************************************************************************************
    *                                                                                       *
    *                              KEYBOARD SECTION                                         *
    *                                                                                       *
    * In this section we will allow the main view to slide up and down                      *
    * as the keyboard appears and disappears                                                *
    ****************************************************************************************/
    
    // returns the height of keyboard according to screensize
    func getKeyboardHeight(notification:NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardHeight = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardHeight.CGRectValue().height
    }
    
    // slide the view up if the bottom textfield is being used
    func keyboardWillShow(notification:NSNotification){
        if self.bottomText.editing{
            self.view.frame.origin.y -= self.getKeyboardHeight(notification)
        }
    }
    
    // slide the view down if the bottom textfield is being used
    func keyboardWillHide(notification:NSNotification){
        if self.bottomText.editing{
            self.view.frame.origin.y += self.getKeyboardHeight(notification)
        }
    }
    
    // subscribe to all keyboard notifications
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // unsubscribe to all keyboard notifications
    func unsubscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /****************************************************************************************
    *                                                                                       *
    *                              UTILITY FUNCTIONS                                        *
    *                                                                                       *
    ****************************************************************************************/
    
    // get current date and time
    func getCurrentDateAndTime() -> String{
        let timeAndDate = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        return timeAndDate
    }
    
    // takes an screenshot and returns the image
    func generateMemeImage() -> UIImage{
        // hide top and bottom toolbar
        self.topBar.hidden = true
        self.bottomBar.hidden = true
        
        // create an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // unhide top and bottombar
        self.topBar.hidden = false
        self.bottomBar.hidden = false
        
        self.save(memedImage)
        return memedImage
    }
    
    // save current image and store it in the meme list
    func save( memeImg : UIImage){
        let meme = Meme(img: self.img.image!, memeImg: memeImg, topText: self.topText.text, bottomText: self.bottomText.text, sentDate: self.getCurrentDateAndTime())
        
        // save img in meme list
        let obj = UIApplication.sharedApplication().delegate as! AppDelegate
        obj.memeList.append(meme)
    }
    
    // show the sent meme view controller
    func showSentMemeController(){
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("tabController")! as! UITabBarController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // return memeList
    func returnMemeList() -> [Meme]{
        let obj = UIApplication.sharedApplication().delegate as! AppDelegate
        return obj.memeList
    }
}

