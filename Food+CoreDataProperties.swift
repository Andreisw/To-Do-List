//
//  Food+CoreDataProperties.swift
//  ToDoListWithDepencyInjection
//
//  Created by Andrei Cojocaru on 19.04.2021.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: Int64
    @NSManaged public var parentCategory: Category?

}

extension Food : Identifiable {

}
