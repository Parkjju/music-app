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
    var releaseDate: String?
    var primaryGenreName: String?
}
