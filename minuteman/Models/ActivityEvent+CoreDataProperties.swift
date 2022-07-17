//
//  ActivityEvent+CoreDataProperties.swift
//  minuteman
//
//  Created by Danil Chernyshev on 15/07/2022.
//
//

import Foundation
import CoreData


extension ActivityEvent {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ActivityEvent> {
        return NSFetchRequest<ActivityEvent>(entityName: "ActivityEvent")
    }

    @NSManaged public var start: Date?
    @NSManaged public var end: Date?
    @NSManaged public var activityId: UUID?
    @NSManaged public var id: UUID?
    @NSManaged public var relationship: Activity?

}

extension ActivityEvent : Identifiable {

}
