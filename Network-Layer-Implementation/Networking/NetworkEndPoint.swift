//
//  NetworkEndPoint.swift
//  Network-Layer-Implementation
//
//  Created by Omran on 2019-10-08.
//  Copyright © 2019 Omran. All rights reserved.
//

import Foundation

typealias NetworkParameters = [String: Any]
typealias NetworkHeaders = [String: String]

enum HttpMethod: String {
    case GET, POST, PUT, DELETE
}

enum NetworkParametersType {
    case body(NetworkParameters)
    case url(NetworkParameters)
    case bodyUrl(body: NetworkParameters, url: NetworkParameters)
    case none
}

protocol NetworkEndPoint {
    var path: String { get }
    var params: NetworkParametersType? { get }
    var method: HttpMethod { get }
    var headers: NetworkHeaders? { get }
}
