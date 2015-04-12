//
//  Meme.swift
//  MemeMe
//
//  Created by Suthananth Arulanantham on 07.04.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import Foundation
import UIKit

class Meme : NSObject{
    
    var img : UIImage!
    var memeImg : UIImage!
    var topText : String!
    var bottomText : String!
    var sentDate : String!
    
    init(img:UIImage,memeImg : UIImage, topText : String, bottomText : String, sentDate : String) {
        
        self.img = img
        self.memeImg = memeImg
        self.topText = topText
        self.bottomText = bottomText
        self.sentDate = sentDate
    }
}