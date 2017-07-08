//
//  Content+CoreDataProperties.swift
//  testTable
//
//  Created by Zhou Ti on 8/7/17.
//  Copyright © 2017 com. All rights reserved.
//

import Foundation
import CoreData


extension Content {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content")
    }

    @NSManaged public var message: String?
    @NSManaged public var date: NSDate?

}
