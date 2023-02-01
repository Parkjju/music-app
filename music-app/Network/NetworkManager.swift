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
    
    typealias NetworkCompletion = (Result<[MusicResult], NetworkError>) -> Void
    
    func fetchMusic(searchTerm: String, completion: @escaping NetworkCompletion){
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
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil{
                print(error!.localizedDescription)
                completion(Result.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(Result.failure(.dataError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                completion(Result.failure(.networkingError))
                return
            }
            
            if let musics = self.parseToJSON(safeData){
                completion(Result.success(musics))
                
            } else {
                print("Parsing Error")
                completion(Result.failure(.parseError))
            }
            
            
        }
        task.resume()
    }
    
    func parseToJSON(_ musicData: Data) -> [MusicResult]? {
        do{
            let decoder = JSONDecoder()
            let musicData = try decoder.decode(MusicData.self, from: musicData)
            return musicData.results
        } catch{
            return nil
        }
    }
}
