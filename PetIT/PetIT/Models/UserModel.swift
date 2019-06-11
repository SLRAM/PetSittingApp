//
//  UserModel.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation

class UserModel {
    let userId: String
    let displayName: String
    let email: String
    let photoURL: String?
    let petPhotoURL: String?
    let joinedDate: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let petBio: String?
    let rating: Double?
    let qualifications: String?
    
    public var fullName: String {
        return ((firstName ?? "") + " " + (lastName ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(userId: String,
         displayName: String,
         email: String,
         photoURL: String?,
         joinedDate: String,
         firstName: String?,
         lastName: String?,
         rating: Double?,
         qualifications: String?,
         petPhotoURL: String?,
         petBio: String?,
         bio: String?) {
        self.userId = userId
        self.displayName = displayName
        self.email = email
        self.photoURL = photoURL
        self.joinedDate = joinedDate
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.petPhotoURL = petPhotoURL
        self.petBio = petBio
        self.rating = rating
        self.qualifications = qualifications
    }
    
    init(dict: [String: Any]) {
        self.userId = dict[UsersCollectionKeys.UserIdKey] as? String ?? ""
        self.displayName = dict[UsersCollectionKeys.DisplayNameKey] as? String ?? ""
        self.email = dict[UsersCollectionKeys.EmailKey] as? String ?? ""
        self.photoURL = dict[UsersCollectionKeys.PhotoURLKey] as? String ?? ""
        self.joinedDate = dict[UsersCollectionKeys.JoinedDateKey] as? String ?? ""
        self.firstName = dict[UsersCollectionKeys.FirstNameKey] as? String ?? "FirstName"
        self.lastName = dict[UsersCollectionKeys.LastNameKey] as? String ?? "LastName"
        self.bio = dict[UsersCollectionKeys.BioKey] as? String ?? "fellow users are looking forward to reading your bio"
        self.petPhotoURL = dict[UsersCollectionKeys.PetPhotoURLKey] as? String ?? ""
        self.petBio = dict[UsersCollectionKeys.PetBioKey] as? String ?? "fellow users are looking forward to reading your pet's bio"
        self.rating = dict[UsersCollectionKeys.RatingKey] as? Double ?? 0
        self.qualifications = dict[UsersCollectionKeys.QualificationsKey] as? String ?? ""
    }
}
