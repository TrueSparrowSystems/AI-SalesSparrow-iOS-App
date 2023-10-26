//
//  Persistence.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import CoreData

/**
 A struct that provides methods for managing the Core Data stack.
 */
struct PersistenceController {
    static let shared = PersistenceController()
    
    // The Core Data container
    let container: NSPersistentContainer
    
    /**
     Initializes the Core Data stack.
     
     - Parameter inMemory: A boolean value that indicates whether the Core Data stack should be initialized in memory.
     */
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SalesSparrow")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // TODO: Replace this implementation with code to handle the error appropriately.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
