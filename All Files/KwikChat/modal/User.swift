//
//  User.swift
//  KwikChat
//
//  Created by Abuzar Siddiqi on 2/22/25.
//

import SwiftUI
import FirebaseFirestore

struct User: Identifiable,Codable {
    @DocumentID var id: String?
    var username: String
    var userBio: String
    var userBioLink: String
    var userUID: String
    var userEmail: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case username
        case userBio
        case userBioLink
        case userUID
        case userEmail
        case userProfileURL
    }
   
}

