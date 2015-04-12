//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Suthananth Arulanantham on 08.04.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController, UITableViewDataSource {

    var memeList = [Meme]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let obj = UIApplication.sharedApplication().delegate as! AppDelegate
        self.memeList = obj.memeList
        self.tableView.reloadData()
        self.navigationItem.leftBarButtonItem  = self.editButtonItem()
        
    }
    
    // create new meme in the meme editor
    @IBAction func addNewButtonTouched(sender: AnyObject) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("memeEditor")!as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memeList.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")as! UITableViewCell
        let meme = self.memeList[indexPath.row]
        
        // set image and send date
        cell.imageView?.image = meme.memeImg
        cell.textLabel?.text = meme.sentDate
        
        // customize cell
        let obj = UIApplication.sharedApplication().delegate as! AppDelegate
        cell.backgroundColor = obj.backgroundColor
        cell.textLabel?.textColor = obj.tintColor
        
        return cell
    }
    
    // called when a row deletion action is confirmed
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            //remove the deleted item from the model
            self.memeList.removeAtIndex(indexPath.row)
            
            //update memeList
            let obj = UIApplication.sharedApplication().delegate as! AppDelegate
            obj.memeList = self.memeList
            
            // remove the deleted item from the "UITableView"
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.reloadData()
            
        default:
            return
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("detailMeme") as! DetailMemeViewControll
        detailController.currentMeme = self.memeList[indexPath.row]
        detailController.currentIndex = indexPath.row
        detailController.memeList = self.memeList
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
