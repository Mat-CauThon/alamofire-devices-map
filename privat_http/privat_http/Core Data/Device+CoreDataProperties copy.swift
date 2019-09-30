//
//  Device+CoreDataProperties.swift
//  
//
//  Created by Roman Mishchenko on 9/29/19.
//
//

import Foundation
import CoreData


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var type: String?
    @NSManaged public var placeRu: String?
    @NSManaged public var fullAddressRu: String?
    @NSManaged public var placeUa: String?
    @NSManaged public var fullAddressUa: String?
    @NSManaged public var fullAddressEn: String?
    @NSManaged public var cityRU: String?
    @NSManaged public var cityUA: String?
    @NSManaged public var cityEN: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var mon: String?
    @NSManaged public var tue: String?
    @NSManaged public var wed: String?
    @NSManaged public var thu: String?
    @NSManaged public var fri: String?
    @NSManaged public var sat: String?
    @NSManaged public var sun: String?
    @NSManaged public var hol: String?
    @NSManaged public var favorite: Bool

}
