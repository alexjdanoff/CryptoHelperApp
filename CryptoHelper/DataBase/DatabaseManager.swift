//
//  DatabaseManager.swift
//  CryptoHelper
//
//  Created by Alexandru Jdanov on 11.10.2022.
//

import Foundation
import RealmSwift

class DatabaseManager: ObservableObject {
    static var shared = DatabaseManager()
    
    lazy var mainRealm = try! Realm(configuration: .init(schemaVersion: 1, deleteRealmIfMigrationNeeded: true))
    
    func save(object: Object, block: (() -> Void)?) {
        do {
            try mainRealm.write {
                mainRealm.add(
                    object,
                    update: .all
                )
                block?()
            }
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func getObjects(type: Object.Type) -> Results<Object> {
        mainRealm.objects(type)
    }
    
    func deleteObject(object: Object) {
        do {
            try mainRealm.write {
                mainRealm.delete(object)
            }
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func modifyObject(block: (() -> Void)?) {
        do {
            try mainRealm.write {
                block?()
            }
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
    }
}

extension Results {
func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0 ..< count {
        if let result = self[index] as? T {
            array.append(result)
        }
    }

    return array
}
}
