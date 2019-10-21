//
//  APIManager.swift
//  prsnls-ios
//
//  Created by Omran on 2019-10-03.
//  Copyright © 2019 Guarana Technologies Inc. All rights reserved.
//

import Foundation

enum PRNetworkError: Error {
    case unKnown
    case custom(error: String)
    case authenticationError
    case badRequest
    case outdated
    case failed
}

extension PRNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unKnown:
            return "Something went wrong"
        case .custom(error: let error):
            return error
        case .badRequest: return "Something went wrong"
        case .failed: return "Something went wrong"
        case .outdated: return "Something went wrong"
        case .authenticationError: return "Something went wrong"
        }
    }
}

class ApiManager {
    private let exampleRouter = Router<ExampleEndpoint>(rootUrl: "https://admin.theprsnls.com", prefix: "/api")
    
    private init() { }
    
    static let shared: ApiManager = ApiManager()

    func doRequest<T: Codable>(route: ExampleEndpoint, decodingType: T.Type, complete: @escaping (Result<T, Error>) -> Void) {
        exampleRouter.request(route) { [weak self] (data, response, error) in
            if let error = error {
                complete(.failure(error))
            } else {
    
                guard let response = response as? HTTPURLResponse else {
                    complete(.failure(PRNetworkError.unKnown))
                    return
                }
                
                let result = self?.handleNetworkResponse(response, data: data)
                switch result {
                case .failure(let err): complete(.failure(err))
                case .success(let data):
                    do {
                        let apiResponse: T = try JSONDecoder().decode(decodingType, from: data ?? Data())
                        complete(.success(apiResponse))
                    } catch let err {
                        complete(.failure(err))
                    }
                case .none: complete(.failure(PRNetworkError.unKnown))
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse, data: Data?) -> Result<Data?, Error> {
        switch response.statusCode {
        case 200...299: return .success(data)
        case 401...500: return .failure(PRNetworkError.authenticationError)
        case 501...599: return .failure(PRNetworkError.badRequest)
        case 600: return .failure(PRNetworkError.outdated)
        default: return .failure(PRNetworkError.failed)
        }
    }
}
