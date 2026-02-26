//
//  CoreDataServiceProtocol.swift
//  PawWalker
//
//  Created by shagar on 07/01/25.
//
import CoreData

protocol CoreDataServiceProtocol {
    var context : NSManagedObjectContext {get}
    func fetch<T : NSManagedObject>(tableName : String,sort:[NSSortDescriptor]?,predicate: NSPredicate?,limit: Int?) -> Result<[T],Error>
    func save(object : NSManagedObject)
    func createEntity<T: NSManagedObject>(for tableName : String) -> T?
    func delete(object: NSManagedObject)
}

class CoreDataService : CoreDataServiceProtocol {
    func createEntity<T: NSManagedObject>(for tableName: String) -> T? {
        guard let enity = NSEntityDescription.entity(forEntityName: tableName, in: context) else {
            print("Failed to create entity for table: \(tableName)")
        return nil
        }
        return NSManagedObject(entity: enity, insertInto: context) as? T
    }
    
    var context: NSManagedObjectContext {
        return coreDataContext
    }
    
    private let coreDataContext : NSManagedObjectContext
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.coreDataContext = context
    }
    
    func fetch<T : NSManagedObject>(tableName: String, sort: [NSSortDescriptor]?, predicate: NSPredicate?, limit: Int?) -> Result<[T],Error> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: tableName, in: context)
        fetchRequest.entity = entity
        fetchRequest.returnsObjectsAsFaults = false
        if sort != nil {
            fetchRequest.sortDescriptors = sort
        }
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if let maxCount = limit, maxCount > 0 {
            fetchRequest.fetchLimit = maxCount
        }
        do {
            let result = try self.context.fetch(fetchRequest)
            return .success(result as? [T] ?? [])
        }
        catch {
            return .failure(error)
        }
    }
    
    func save(object: NSManagedObject) {
        do {
            try context.save()
        }
        catch {
            print("count not save the object")
        }
    }
    func delete(object : NSManagedObject) {
        context.delete(object)
    }

    
}
