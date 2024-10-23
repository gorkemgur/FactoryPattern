//
//  CoreDataStorage.swift
//  factorySample
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation
import CoreData

final class CoreDataStorage: StorageServiceProtocol {
    private let container: NSPersistentContainer
    
    init(containerName: String = "StorageContainer") {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData load failed: \(error)")
            }
        }
    }
    
    func save<T: Codable>(_ item: T, for key: String) throws {
        let context = container.viewContext
        
        // Entity ismi T tipinden gelsin
        let entityName = String(describing: T.self)
        
        // Önce eski veriyi sil
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "key == %@", key)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object as! NSManagedObject)
            }
            
            // Yeni veriyi kaydet
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
            let newObject = NSManagedObject(entity: entity, insertInto: context)
            let data = try JSONEncoder().encode(item)
            
            newObject.setValue(key, forKey: "key")
            newObject.setValue(data, forKey: "data")
            
            try context.save()
        } catch {
            throw StorageError.saveError("CoreData save failed: \(error)")
        }
    }
    
    func fetch<T: Codable>(for key: String) throws -> T? {
        let context = container.viewContext
        let entityName = String(describing: T.self)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "key == %@", key)
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let object = results.first as? NSManagedObject,
                  let data = object.value(forKey: "data") as? Data else {
                return nil
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw StorageError.fetchError("CoreData fetch failed: \(error)")
        }
    }
    
    func delete(for key: String) throws {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StorageEntity")
        fetchRequest.predicate = NSPredicate(format: "key == %@", key)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object as! NSManagedObject)
            }
            try context.save()
        } catch {
            throw StorageError.deleteError("CoreData delete failed: \(error)")
        }
    }
    
    func clearAll() throws {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StorageEntity")
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object as! NSManagedObject)
            }
            try context.save()
        } catch {
            throw StorageError.deleteError("CoreData clear failed: \(error)")
        }
    }
}
