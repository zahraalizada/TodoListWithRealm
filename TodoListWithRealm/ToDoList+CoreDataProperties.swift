//
//  ToDoList+CoreDataProperties.swift
//  CoreDataApp
//
//  Created by Zahra Alizada on 15.05.24.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var title: String?

}

extension ToDoList : Identifiable {

}
