//
//  DBService.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

final class DBService {
    private init() {}
    
    public static var firestoreDB: Firestore = {
        let db = Firestore.firestore()
        let settings = db.settings
        //        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        return db
    }()
    
    static public var generateDocumentId: String {
        return firestoreDB.collection(UsersCollectionKeys.CollectionKey).document().documentID
    }
}
