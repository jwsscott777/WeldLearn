//
//  DataController-Awards.swift
//  WeldLearn
//
//  Created by JWSScott777 on 5/11/21.
//
import CoreData
import Foundation

extension DataController {
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "items":
            // returns true if they added a certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "complete":
            // returns true if they completed some items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
           // fatalError("Unknown award criterion: \(award.criterion)")
        return false
        }
    }
}
