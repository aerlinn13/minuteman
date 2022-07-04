//
//  Minute+CoreDataProperties.swift
//  minuteman
//
//  Created by Danil Chernyshev on 04/07/2022.
//
//

import Foundation
import CoreData


extension Minute {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Minute> {
        return NSFetchRequest<Minute>(entityName: "Minute")
    }

    @NSManaged public var id: Int64
    @NSManaged public var activityId: String
    @NSManaged public var activityDescription: String
    @NSManaged public var newRelationship: Activity?

}

extension Minute : Identifiable {

}
