//
//  EndPointExample.swift
//  Network-Layer-Implementation
//
//  Created by Omran on 2019-10-08.
//  Copyright © 2019 Omran. All rights reserved.
//

import Foundation

enum ExampleEndpoint {
    case login
    case signup
    case cities
}

extension ExampleEndpoint: NetworkEndPoint {
    var path: String {
        switch self {
        case .login: return "/login"
        case .signup: return "/signup"
        case .cities: return "/cities"
        }
    }
    
    var params: NetworkParametersType? {
        switch self {
        case .login: return .body(["email": "test", "password": "123456"])
        case .signup: return .url(["test": "test"])
        case .cities: return nil
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .login, .signup: return .POST
        case .cities: return .GET
        }
    }
    
    var headers: NetworkHeaders? {
        return nil
    }
}
