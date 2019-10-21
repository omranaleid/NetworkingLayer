//
//  NetworkRouter.swift
//  Network-Layer-Implementation
//
//  Created by Omran on 2019-10-08.
//  Copyright © 2019 Omran. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkRouter: class {
    associatedtype EndPoint: NetworkEndPoint
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: NetworkEndPoint>: NetworkRouter {
    private var task: URLSessionTask?
    private let rootUrl: String
    private let prefix: String?
    
    init(rootUrl: String, prefix: String?) {
        self.rootUrl = rootUrl
        self.prefix = prefix
    }
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let requestBuilder = NetworkRequestBuilder(rootUrl: rootUrl, prefix: prefix)
            if let request = try requestBuilder.buildRequest(for: route) {
                task = session.dataTask(with: request, completionHandler: { data, response, error in
                    completion(data, response, error)
                })
            } else {
                completion(nil, nil, NetworkError.encodingFailed)
            }
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
}
