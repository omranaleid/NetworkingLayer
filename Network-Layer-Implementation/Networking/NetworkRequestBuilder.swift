//
//  NetworkRequestBuilder.swift
//  Network-Layer-Implementation
//
//  Created by Omran on 2019-10-08.
//  Copyright © 2019 Omran. All rights reserved.
//

import Foundation

protocol NetworkRequestBuilderProtocol {
    func buildRequest(for endpoint: NetworkEndPoint) throws -> URLRequest?
}

struct NetworkRequestBuilder {
    internal let urlString: String
    internal let timeOut: TimeInterval
    internal var request: URLRequest?

    init(rootUrl: String, prefix: String?, timeOut: TimeInterval = 10.0) {
        self.urlString = rootUrl + (prefix ?? "")
        self.timeOut = timeOut
    }
}

extension NetworkRequestBuilder: NetworkRequestBuilderProtocol {
    func buildRequest(for endpoint: NetworkEndPoint) throws -> URLRequest?  {
        guard let url = URL(string: self.urlString) else { return nil }
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: self.timeOut)
        
        request.httpMethod = endpoint.method.rawValue

        if let parameters = endpoint.params {
            let encoder = ParameterEncoder(params: parameters)
            do {
                try encoder.encode(urlRequest: &request)
            } catch {
                print(error)
                fatalError("Error while encoding the parameters")
            }
        }
    
        if let headers = endpoint.headers {
            addAdditionalHeaders(headers, request: &request)
        }
        
        return request
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: NetworkHeaders, request: inout URLRequest) {
        for (key, value) in additionalHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
