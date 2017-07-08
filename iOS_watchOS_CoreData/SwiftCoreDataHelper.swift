//
//  SwiftCoreDataHelper.swift
//  testTable
//
//  Created by Zhou Ti on 8/7/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import CoreData

class SwiftCoreDataHelper: NSObject {

    class func sharedAppGroup() -> String {
        return "group.com.team12"
    }

    class func manageObjectModel() -> NSManagedObjectModel {
        let moduleURL = Bundle.main.url(forResource: "Model", withExtension: "momd")
        return NSManagedObjectModel(contentsOf: moduleURL!)!
    }

    class func persistantStoreCoordinator() -> NSPersistentStoreCoordinator? {
        let sharedContentURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: SwiftCoreDataHelper.sharedAppGroup())
        if let sharedContentURL = sharedContentURL {
            let storeURL = sharedContentURL.appendingPathComponent("database.sqlite")
            let coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: SwiftCoreDataHelper.manageObjectModel())
            do {
                try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                print(error)
            }
            return coordinator
        }
        return nil
    }

    class func manageObjectContext() -> NSManagedObjectContext {
        let coordinator = SwiftCoreDataHelper.persistantStoreCoordinator()
        let manageObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        manageObjectContext.persistentStoreCoordinator = coordinator
        return manageObjectContext
    }

    class func insertManagedObject(className: NSString, managedObjectContext: NSManagedObjectContext) -> AnyObject {
        let manageObject = NSEntityDescription.insertNewObject(forEntityName: className as String, into: managedObjectContext) as NSManagedObject
        return manageObject
    }

    class func saveManagedObjectContext(managedObjectContext: NSManagedObjectContext) -> Bool {
        do {
            try managedObjectContext.save()
            return true
        } catch {
            print(error)
        }
        return false
    }

    class func setValueForManagedObject(managedObject: NSManagedObject, key: String, value: AnyObject){
        managedObject.setValue(value, forKey: key)
    }

    class func deleteManagedObjectContext(managedObjectContext: NSManagedObjectContext, managedObject: NSManagedObject) -> Bool {
        managedObjectContext.delete(managedObject)
        return true
    }

    class func fetchEntities(className: NSString, withPredict predict: NSPredicate?, andSortDescriptor sortDescriptor: NSSortDescriptor?, managedObjectContext: NSManagedObjectContext) -> NSArray {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: className as String, in: managedObjectContext)
        fetchRequest.entity = entityDescription
        if predict != nil {
            fetchRequest.predicate = predict!
        }
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = [sortDescriptor!]
        }
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let items = try managedObjectContext.fetch(fetchRequest)
            return items as NSArray
        } catch {
            print(error)
        }
        return []
    }


}
