//
//  TextDelegate.swift
//  MemeMe
//
//  Created by Suthananth Arulanantham on 06.04.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit

class TextDelegate: NSObject, UITextFieldDelegate {

    // resetting textfields when user begins editing for the first time
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
        textField.autocapitalizationType  = UITextAutocapitalizationType.AllCharacters
        return true
    }
    
    // hides the keyboard when the return button is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
