//
//  Music.swift
//  music-app
//
//  Created by Jun on 2023/01/30.
//

import Foundation

class MusicData: Codable{
    var resultCount: Int?
    var results: [MusicResult]?
}

struct MusicResult: Codable{
    var wrapperType: String?
    var kind: String?
    var artistName: String?
    var collectionName: String?
    var trackName: String?
    var artistViewUrl: String?
    var collectionViewUrl: String?
    var trackViewUrl: String?
    var previewUrl: String?
    var primaryGenreName: String?
    var releaseDate:String?
    
    var releaseDateString: String? {
        guard let isoDate = ISO8601DateFormatter().date(from: releaseDate ?? "") else {
            return ""
        }
        
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-mm-dd"
        let dateString = myFormatter.string(from: isoDate)
        return dateString
    }
}
