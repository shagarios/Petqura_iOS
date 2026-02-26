//
//  CoreDataManager.swift
//  PawWalker
//
//  Created by shagar on 07/01/25.
//
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    init() {
        
    }
    lazy var presistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PawWalker")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load error: \(error)")
            }
        }
        return container
    }()
    var context : NSManagedObjectContext {
        presistentContainer.viewContext
    }
    func saveContext() {
        guard context.hasChanges else {return}
        do {
            try context.save()
        }
        catch {
            fatalError("Unresolved error \(error)")
        }
                
    }
}
