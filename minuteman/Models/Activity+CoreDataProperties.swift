//
//  Activity+CoreDataProperties.swift
//  minuteman
//
//  Created by Danil Chernyshev on 04/07/2022.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var colour: Data
    @NSManaged public var emoji: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var newRelationship: Minute?

}

extension Activity : Identifiable {

}
