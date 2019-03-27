//
//  DBService+User.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation
struct UsersCollectionKeys {
    static let CollectionKey = "users"
    static let UserIdKey = "userId"
    static let DisplayNameKey = "displayName"
    static let FirstNameKey = "firstName"
    static let LastNameKey = "lastName"
    static let EmailKey = "email"
    static let PhotoURLKey = "photoURL"
    static let JoinedDateKey = "joinedDate"
    static let BioKey = "bio"
    static let PetBioKey = "petBio"
    static let PetPhotoURLKey = "petPhotoURL"
    static let RatingKey = "rating"
    static let QualificationsKey = "qualifications"
}
extension DBService {
    static public func createUser(user: UserModel, completion: @escaping (Error?) -> Void) {
        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
            .document(user.userId)
            .setData([ UsersCollectionKeys.UserIdKey : user.userId,
                       UsersCollectionKeys.DisplayNameKey : user.displayName,
                       UsersCollectionKeys.EmailKey       : user.email,
                       UsersCollectionKeys.PhotoURLKey    : user.photoURL ?? "",
                       UsersCollectionKeys.JoinedDateKey  : user.joinedDate,
                       UsersCollectionKeys.BioKey         : user.bio ?? "",
                       UsersCollectionKeys.FirstNameKey   : user.firstName,
                       UsersCollectionKeys.LastNameKey    : user.lastName
            ]) { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
    
    
    static public func fetchUser(userId: String, completion: @escaping (Error?, UserModel?) -> Void) {
        DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .whereField(UsersCollectionKeys.UserIdKey, isEqualTo: userId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(error, nil)
                } else if let snapshot = snapshot?.documents.first {
                    let postCreator = UserModel(dict: snapshot.data())
                    completion(nil, postCreator)
                }
        }
    }
}
