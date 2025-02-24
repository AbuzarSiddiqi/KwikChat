//
//  Post.swift
//  KwikChat
//
//  Created by Abuzar Siddiqi on 2/23/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

//MArk: Post Model
struct Post: Identifiable, Codable, Equatable, Hashable{
    @DocumentID var id: String?
    var text: String
    var imageURL: URL?
    var imageReferenceID: String = ""
    var publishedDate: Date = Date()
    var likedIDs: [String] = []
    var dislikedIDs: [String] = []
    
    //MArk: Basic User Info
    var userName: String
    var userUID: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case imageURL
        case imageReferenceID
        case publishedDate
        case likedIDs
        case dislikedIDs
        case userName
        case userUID
        case userProfileURL
        
    }
    
    
}
