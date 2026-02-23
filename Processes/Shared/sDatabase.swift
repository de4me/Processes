//
//  Database.swift
//  Processes
//
//  Created by DE4ME on 20.02.2026.
//

import CoreData;


final class sDatabase {
    
    static let shared = sDatabase();
    
    //MARK: CONST
    
    let workQueue = DispatchQueue(label: "Database Queue", qos: .userInitiated);
    
    //MARK: GET
    
    var mainContext: NSManagedObjectContext {
        self.persistentContainer.viewContext;
    }
    
    //MARK: VAR
    
    
    lazy var privateContext: NSManagedObjectContext = {
        self.persistentContainer.newBackgroundContext();
    }();
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Processes");
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
        return container;
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() throws {
        let context = self.mainContext;
        guard context.hasChanges else{
            return;
        }
        try context.save();
    }
    
    //MARK: OVERRIDE
    
    init() {
        let nc = NotificationCenter.default;
        nc.addObserver(self, selector: #selector(self.privateContextDidSaveNotify(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: self.privateContext);
        nc.addObserver(self, selector: #selector(self.mainContextDidSaveNotify(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: self.mainContext);
    }
    
    //MARK: NOTIFY
    
    @objc func privateContextDidSaveNotify(_ notify: Notification) {
        let context = self.mainContext;
        context.perform {
            context.mergeChanges(fromContextDidSave: notify);
        }
    }
    
    @objc func mainContextDidSaveNotify(_ notify: Notification) {
        let context = self.privateContext;
        context.perform {
            context.mergeChanges(fromContextDidSave: notify);
        }
    }
    
    //MARK: FUNC
    
    #if DEBUG
    func debug(){
        do{
            let fetch1:NSFetchRequest<DBSession> = DBSession.fetchRequest();
            let sessions = try self.privateContext.fetch(fetch1);
            print("***");
            sessions.forEach{ print($0.objectID, $0.date ?? "?", $0.tasks?.count ?? 0) }
            let fetch2:NSFetchRequest<DBProcess> = DBProcess.fetchRequest();
            let processes = try self.privateContext.fetch(fetch2);
            print("***");
            print(processes.count);
        }
        catch {
            print(error);
        }
    }
    #endif
    
    func save(applications: [ApplicationObject], completionHandler: @escaping (Error?) -> Void) {
        self.workQueue.async {
            do {
                let _ = DBSession(applications: applications, context: self.privateContext);
                guard self.privateContext.hasChanges else {
                    return;
                }
                try self.privateContext.save();
                completionHandler(nil);
            }
            catch {
                self.privateContext.rollback();
                completionHandler(error);
            }
        }
    }
    
    func delete(objects: [any DatabaseObjectIDProtocol], completionHandler: @escaping (Error?) -> Void) {
        self.workQueue.async {
            do {
                objects.forEach { object in
                    let session = self.privateContext.object(with: object.objectId());
                    self.privateContext.delete(session);
                }
                guard self.privateContext.hasChanges else {
                    return;
                }
                try self.privateContext.save();
                completionHandler(nil);
            }
            catch {
                self.privateContext.rollback();
                completionHandler(error);
            }
        }
    }
    
    func clear(_ completionHandler: @escaping (Error?) -> Void) {
        self.workQueue.async {
            do {
                let requests:[NSFetchRequest<NSFetchRequestResult>] = [DBSession.fetchRequest(),
                                                                       DBProcess.fetchRequest()];
                let array = try requests.flatMap { request in
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: request);
                    deleteRequest.resultType = .resultTypeObjectIDs;
                    let result = try self.privateContext.execute(deleteRequest) as! NSBatchDeleteResult;
                    return result.result as! [NSManagedObjectID];
                }
                let changes = [NSDeletedObjectsKey: array];
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.mainContext]);
                completionHandler(nil);
            }
            catch {
                self.privateContext.rollback();
                completionHandler(error);
            }
        }
    }
    
}

