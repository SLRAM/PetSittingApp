//
//  JobPost.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation


struct JobPost {
    let createdDate: String
    let postId: String
    let ownerId: String
    let sitterId: String?
    let imageURLString: String
    let jobDescription: String
    let timeFrame: String
    let wage: Double
    
    init(createdDate: String, postId: String, ownerId: String, sitterId: String?, imageURLString: String, jobDescription: String, timeFrame: String, wage: Double) {
        self.createdDate = createdDate
        self.postId = postId
        self.ownerId = ownerId
        self.sitterId = sitterId
        self.imageURLString = imageURLString
        self.jobDescription = jobDescription
        self.timeFrame = timeFrame
        self.wage = wage
    }
    
    init(dict: [String: Any]) {
        self.createdDate = dict[JobPostCollectionKeys.CreatedDateKey] as? String ?? ""
        self.postId = dict[JobPostCollectionKeys.PostIdKey] as? String ?? ""
        self.ownerId = dict[JobPostCollectionKeys.OwnerIdKey] as? String ?? ""
        self.sitterId = dict[JobPostCollectionKeys.SitterIdKey] as? String ?? ""
        self.imageURLString = dict[JobPostCollectionKeys.ImageURLStringKey] as? String ?? ""
        self.jobDescription = dict[JobPostCollectionKeys.JobDescriptionKey] as? String ?? ""
        self.timeFrame =  dict[JobPostCollectionKeys.TimeFrameKey] as? String ?? ""
        self.wage = dict[JobPostCollectionKeys.WageKey] as? Double ?? 0
    }
}
