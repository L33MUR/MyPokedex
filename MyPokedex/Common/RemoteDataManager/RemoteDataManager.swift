//
//  RemoteDataManager.swift
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 28/02/2021.
//

import Foundation

private enum RemoteDataManagerCustomError: Error {
//    Create enum of custom errors
    case emptyResponse
    case emptyData
}

extension RemoteDataManagerCustomError: LocalizedError {
    //Create extension of RemoteDataManagerCustomError to handle the Localized description.
    fileprivate var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return NSLocalizedString("API returned empty response", comment: "")
        case .emptyData:
            return NSLocalizedString("API returned empty data", comment: "")
        }
    }
}


//Manage all interacions with remote API.
class RemoteDataManager{
    var session:DHURLSession
    init(session:DHURLSession) {
        self.session = session
    }

    func fetchGenericJSONObject<T:Decodable>(endpoint:String,completion:@escaping (Result<T,Error>)->Void){
        fetchData(endpoint: endpoint) { (result) in
            switch result {
                case .success(let (data,_)):
                    // Decode JSON 
                    do {
                        let JSONObject = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(JSONObject))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func fetchData(endpoint:String,completion:@escaping (Result<(Data,HTTPURLResponse),Error>)->Void){
        guard let url = URL.init(string:endpoint) else { return }
        // Create URL Session - work on the background
        session.dataTask(with: url) { (data, response, error) in

            //Error handling
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                let error: Error = RemoteDataManagerCustomError.emptyResponse
                print("Response error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            if (response.statusCode != 200){
                print("Response status code: \(response.statusCode)")
            }
            
            guard let data = data else {
                let error: Error = RemoteDataManagerCustomError.emptyData
                print("Data error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            completion(.success((data,response)))
        }.resume()
   
    }
    
}
