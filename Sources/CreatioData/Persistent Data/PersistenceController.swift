//
//  PersistenceController.swift
//
//  Created by Davis Allie on 4/3/2022.
//

import CoreData

public class PersistenceController: ObservableObject {
    
    @Published public var state: State = .loading
    public enum State {
        case loading, migrating(Progress), ready, failed(Error)
    }
    
    private let container: NSPersistentContainer
    public let mediaController: MediaStorageController
    
    public init(containerName: String, mediaController: MediaStorageController, inMemory: Bool = false, customPath: URL? = nil) {
        self.mediaController = mediaController
        
        container = NSPersistentContainer(name: containerName)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        if let path = customPath {
            container.persistentStoreDescriptions.first!.url = path
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                self.state = .failed(error)
            } else {
                self.state = .ready
            }
        }
    }
    
    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    public func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
}
