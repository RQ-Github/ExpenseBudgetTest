//
//  LocalStorage.swift
//  Expense
//
//  Created by Ray Qu on 15/02/21.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataPersistence {
    func create<Entity: NSManagedObject>(type: Entity.Type) -> Entity
    func fetch<Entity: NSManagedObject>(type: Entity.Type, id: String) -> Entity?
    func fetchAll<Entity: NSManagedObject>(type: Entity.Type) -> [Entity]
    func save()
}

class CoreDataPersistenceImpl: CoreDataPersistence{
    static let shared = CoreDataPersistenceImpl();
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Expense")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var managedContext: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext;
        }
    }
    
    private init() { }
    
}
extension CoreDataPersistenceImpl {
    func create<Entity: NSManagedObject>(type: Entity.Type) -> Entity {
        let entity = NSEntityDescription.entity(forEntityName: String(describing: Entity.self), in: managedContext)!;
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext);
        return managedObject as! Entity;
    }
    
    func fetch<Entity: NSManagedObject>(type: Entity.Type, id: String) -> Entity? {
        guard let objectID = convertObjectID(id: id) else { return nil };
        
        do {
            let managedObject = try managedContext.existingObject(with: objectID);
            return managedObject as? Entity;
        } catch let error as NSError {
            debugPrint("Could not fetch the managedObjects. \(error), \(error.userInfo)")
            return nil;
        }
    }
    
    func fetchAll<Entity: NSManagedObject>(type: Entity.Type) -> [Entity] {
        let managedContext = CoreDataPersistenceImpl.shared.managedContext;
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: String(describing: type));
        do {
            let managedObjects = try managedContext.fetch(fetchRequest)
            return managedObjects as! [Entity];
        } catch let error as NSError {
            debugPrint("Could not fetch the managedObjects. \(error), \(error.userInfo)")
            return [Entity]();
        }
    }
    
    func save() {
        do {
            try managedContext.save();
        } catch let error as NSError {
            debugPrint("Could not save managed objects. \(error), \(error.userInfo)")
        }
    }
    
    private func convertObjectID(id: String) -> NSManagedObjectID? {
        guard let url = URL(string: id) else { return nil }
        
        let coordinator = persistentContainer.persistentStoreCoordinator;
        let managedObjectID = coordinator.managedObjectID(forURIRepresentation: url)
        
        return managedObjectID;
    }
}
