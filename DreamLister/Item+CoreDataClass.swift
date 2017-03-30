//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Chi-Ying Leung on 3/29/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
        
    }
}
