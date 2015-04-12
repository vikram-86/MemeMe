//
//  DetailMemeViewControll.swift
//  MemeMe
//
//  Created by Suthananth Arulanantham on 09.04.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit

class DetailMemeViewControll: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var bottomBar: UIToolbar!
    var currentMeme : Meme!
    var isBarsHidden = false
    var currentIndex : Int!
    var memeList = [Meme]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // hide toolbars
        self.tabBarController?.tabBar.hidden = true
        self.bottomBar.hidden = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("editCurrentMeme:"))
        self.displayCurrentMeme()
        self.hideAndShowBars()
        
    }
    
    override func viewDidLoad() {
        self.addGesturesToView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    /****************************************************************************************
    *                                                                                       *
    *                              GESTURE AND BUTTON SECTION                               *
    *                                                                                       *
    ****************************************************************************************/
    
    //this functions allows the user to edit current meme
    // in the meme editor
    func editCurrentMeme(button : UIBarButtonItem){
        var controller = self.storyboard?.instantiateViewControllerWithIdentifier("memeEditor") as! MemeEditorViewController
        self.presentViewController(controller, animated: true, completion: {
            controller.bottomText.text = self.currentMeme.bottomText
            controller.img.image = self.currentMeme.img
            controller.topText.text = self.currentMeme.topText
            controller.shareButton.enabled = true
        })
    }
    

    
    // how to respond when the screen is tapped
    func tappedImage(tapRecognizer: UITapGestureRecognizer){
        self.hideAndShowBars()
    }
    
    // handles swipe gestures
    func handleSwipes(swipe : UISwipeGestureRecognizer){
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.Left :
            self.currentIndex  = Int(self.currentIndex) + 1
            
        case UISwipeGestureRecognizerDirection.Right:
            self.currentIndex = Int(self.currentIndex) - 1
        default:
            break
        }
        
        currentIndex = (currentIndex < 0) ? (self.memeList.count - 1) : (currentIndex % self.memeList.count)
        currentMeme = self.memeList[currentIndex]
        
        self.imgView.image = currentMeme.memeImg
    
    }
    
    // deletes the current meme and updates the meme list
    @IBAction func deleteButtonTouched(sender: UIBarButtonItem) {
        let obj = UIApplication.sharedApplication().delegate as! AppDelegate
        obj.memeList.removeAtIndex(self.currentIndex)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    /****************************************************************************************
    *                                                                                       *
    *                              UTILITY FUNCTIONS                                        *
    *                                                                                       *
    ****************************************************************************************/
    
    
    // set current meme to be showed
    func displayCurrentMeme() {
        self.imgView.image = self.currentMeme.memeImg
    }
    
    // hide and show toolbars on screen
    func hideAndShowBars(){
        if self.isBarsHidden == true {
            self.navigationController?.navigationBarHidden = false
            self.bottomBar.hidden = false
            self.isBarsHidden = false
        }
        else{
            self.navigationController?.navigationBarHidden = true
            self.bottomBar.hidden = true
            self.isBarsHidden = true
        }
    }
    
    func addGesturesToView(){
        // add a tap recognizer for the view
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("tappedImage:"))
        self.view.addGestureRecognizer(tapGesture)
        
        // add a swipe recognizer for the view
        var leftSwipe = UISwipeGestureRecognizer(target:self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
}
