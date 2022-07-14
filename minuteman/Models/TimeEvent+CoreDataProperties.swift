//
//  TimeEvent+CoreDataProperties.swift
//  minuteman
//
//  Created by Danil Chernyshev on 15/07/2022.
//
//

import Foundation
import CoreData


extension TimeEvent {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<TimeEvent> {
        return NSFetchRequest<TimeEvent>(entityName: "TimeEvent")
    }

    @NSManaged public var start: Date?
    @NSManaged public var end: Date?
    @NSManaged public var activityId: UUID?
    @NSManaged public var relationship: Activity?

}

extension TimeEvent : Identifiable {

}
