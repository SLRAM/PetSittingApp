//
//  DBService+JobPost.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//
import Foundation

struct JobPostCollectionKeys {
    static let CollectionKey = "jobPost"
    static let CreatedDateKey = "createdDate"
    static let PostIdKey = "postId"
    static let OwnerIdKey = "ownerId"
    static let SitterIdKey = "sitterId"
    static let ImageURLStringKey = "imageURLString"
    static let JobDescriptionKey = "jobDescription"
    static let TimeFrameKey = "timeFrame"
    static let WageKey = "wage"
}

extension DBService {
    static public func postJob(jobPost: JobPost, completion: @escaping (Error?) -> Void)  {
        firestoreDB.collection(JobPostCollectionKeys.CollectionKey)
            .document(jobPost.postId).setData([
                JobPostCollectionKeys.CreatedDateKey        : jobPost.createdDate,
                JobPostCollectionKeys.OwnerIdKey            : jobPost.ownerId,
                JobPostCollectionKeys.JobDescriptionKey     : jobPost.jobDescription,
                JobPostCollectionKeys.ImageURLStringKey     : jobPost.imageURLString,
                JobPostCollectionKeys.PostIdKey             : jobPost.postId,
                JobPostCollectionKeys.SitterIdKey           : jobPost.sitterId,
                JobPostCollectionKeys.TimeFrameKey          : jobPost.timeFrame,
                JobPostCollectionKeys.WageKey               : jobPost.wage
                ])
            { (error) in
                if let error = error {
                    print("posting job error: \(error)")
                    completion(error)
                } else {
                    print("job posted successfully to ref: \(jobPost.postId)")
                    completion(nil)
                }
        }
    }
    
    
    static public func deleteJobPost(jobPost: JobPost, completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB
            .collection(JobPostCollectionKeys.CollectionKey)
            .document(jobPost.postId)
            .delete { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }

}
