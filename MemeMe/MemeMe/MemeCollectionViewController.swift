//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Suthananth Arulanantham on 08.04.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController,UICollectionViewDataSource {
    
    var memeList = [Meme]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let obj = UIApplication.sharedApplication().delegate as! AppDelegate
        self.memeList = obj.memeList
        self.collectionView?.reloadData()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memeList.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath)as! MemeCollectionCell
        let meme = self.memeList[indexPath.row]
        
        // set image and sent date
        cell.img.image = meme.memeImg
        cell.sentDate.text = "Sent: \(meme.sentDate)"
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // if editing mode is on. We delete selected items
        if self.editing {
            let obj = UIApplication.sharedApplication().delegate as! AppDelegate
            obj.memeList.removeAtIndex(indexPath.row)
            
            self.memeList.removeAtIndex(indexPath.row)
            self.collectionView?.reloadData()
            return
        }
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("detailMeme")! as! DetailMemeViewControll
        controller.currentIndex = indexPath.row
        controller.currentMeme = self.memeList[indexPath.row]
        controller.memeList = self.memeList
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // create a new meme in the meme editor
    @IBAction func newButtonTouched(sender: UIBarButtonItem) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("memeEditor")! as! MemeEditorViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
