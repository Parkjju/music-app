//
//  NetworkManager..swift
//  music-app
//
//  Created by 박경준 on 2023/01/27.
//

import Foundation

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

class NetworkManager{
    static let shared = NetworkManager()
    
    private init(){}
    
    typealias NetworkCompletion = Result<[Music], NetworkError> -> Void
    
    func fetchMusic(searchTerm: String?, completion: @escaping NetworkCompletion){
        let urlString = "\(MusicApi.requestUrl)\(MusicApi.mediaParam)&term=\(searchTerm)"
        
        performRequest(with: urlString){ result in
            completion(result)
        }
    }
    
    func performRequest(with urlString: String, completion: @escaping NetworkCompletion){
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            guard let safeData = data else {
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                return
            }
            
            
        }
    }
    
    func parseToJSON(_ musicData: Data) -> [Music]? {
        do{
            let musicData = JSONDecoder.decode(MusicData.self, from: musicData)
            return musicData
        } catch{
            return nil
        }
    }
}
