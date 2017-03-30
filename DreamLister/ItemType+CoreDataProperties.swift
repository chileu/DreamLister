//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Chi-Ying Leung on 3/29/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
