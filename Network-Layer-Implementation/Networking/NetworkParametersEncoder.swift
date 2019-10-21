//
//  Encoder.swift
//  prsnls-ios
//
//  Created by Omran on 2019-10-03.
//  Copyright © 2019 Guarana Technologies Inc. All rights reserved.
//

import Foundation

internal enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

internal protocol NetworkParameterEncoder {
    func encode(request: inout URLRequest, with parameters: NetworkParameters) throws
}

internal struct ParameterEncoder {
    private let params: NetworkParametersType
    
    init(params: NetworkParametersType) {
        self.params = params
    }
    
    func encode(urlRequest: inout URLRequest) throws {
        do {
            switch self.params {
            case .body(let bodyPramas):
                try JSONParameterEncoder().encode(request: &urlRequest, with: bodyPramas)
            case .url(let urlParams):
                try URLParameterEncoder().encode(request: &urlRequest, with: urlParams)
            case .bodyUrl(let body, let url):
                try URLParameterEncoder().encode(request: &urlRequest, with: url)
                try JSONParameterEncoder().encode(request: &urlRequest, with: body)
            case .none: print("None")
            }
        } catch {
            throw error
        }
    }
}

public struct URLParameterEncoder: NetworkParameterEncoder {
    func encode(request: inout URLRequest, with parameters: NetworkParameters) throws {
        guard let url = request.url else { throw NetworkError.missingURL}
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            request.url = urlComponents.url
        }
        
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}

public struct JSONParameterEncoder: NetworkParameterEncoder {
    func encode(request: inout URLRequest, with parameters: NetworkParameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonAsData
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
