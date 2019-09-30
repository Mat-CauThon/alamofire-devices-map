//
//  City+CoreDataProperties.swift
//  
//
//  Created by Roman Mishchenko on 9/29/19.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var city: NSObject?

}
