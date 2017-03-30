//
//  MaterialView.swift
//  DreamLister
//
//  Created by Chi-Ying Leung on 3/29/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit

// can not set materialKey var inside extension. must be outside.
private var materialKey = false

// why do we use extension?
// so that anything that inherits from UIView will also be able to add styling below
// if someone adds a new view they can select whether or not they want materialDesign added to the view
extension UIView {
    
    // An IBInspectable is a toggling/ selectable option that we can select inside of Storyboard
    @IBInspectable var materialDesign: Bool {
        
        get {
            return materialKey
        }
        
        set {
            // set the materialKey to the new value that was selected
            materialKey = newValue
            
            if materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            } else {
                // these are the default values; if materialKey = false
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
        

    }


}
