//
//  ApiCaller.swift
//  HandAssure
//
//  Created by kishlay kishore on 09/11/20.
//

import Foundation
import Alamofire

class ApiCaller {
    static let shared = ApiCaller()
    
    public func performApiCall<T: Codable>(url: URLRequest, expectingReturnType:T.Type,completion: @escaping ((Result<T, Error>) -> Void)) {
       // var request: URLRequest? = nil
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _,error in
            guard let data = data, error == nil else {
                return
            }
            var decodedResult: T?
            do {
                decodedResult = try JSONDecoder().decode(T.self, from: data)
            }
            catch {
                
            }
            guard let result = decodedResult else {
             //Failure Case
               return
            }
            completion(.success(result))
        })
        task.resume()
    }
}
