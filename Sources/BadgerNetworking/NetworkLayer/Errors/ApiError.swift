//
//  ApiError.swift
//  Networking
//
//  Created by Seth on 4/6/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import Foundation


/// Specifies the possible errors that a request to an api could return.
///
/// - apiError: Specifies api errors that are returned as part of the response from the api.
/// - badRequest: Specifies errors where the api is unable to process the request due to errors with the request data.
/// - unauthorized: Specifies errors where the requestor failed to provide adequate credentials for the data being requested.
/// - paymentRequired: Specifies errors where a payment is required before the request can be fulfilled.
/// - forbidden: Spefies errors where the requestor does not have proper access rights for the data being requested.
/// - notFound: Spefies errors where the resource being requested does not exist.
/// - methodNotAllowed: Specifies errors where the endpoint being called either does not exist or is not allowed for the requestor.
/// - requestEntityTooLarge: Specifies errors where the request being sent is too large to be processed.
/// - responseParseError: Specifies errors where the response being received is not able to be parsed by the network/api processor.
/// - unknownError: Specifies all other errors that have not been defined.
public enum ApiError: Error, Equatable, CustomStringConvertible{
    case apiError(message: String, errorName: String?, code: Int?)
    case badRequest
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case methodNotAllowed
    case requestEntityTooLarge
    case responseParseError
    case unknownError
    
    var code: Int {
        switch self {
        case .apiError(_, _, let code): return (code != nil) ? code! : 677
        case .badRequest:       return 400
        case .unauthorized:     return 301
        case .notFound:         return 404
        default:
            return 677 // default code for now...
        }
    }
    
    var description: String {
        switch self {
        case .apiError(let message, _, _):
            return message
        case .badRequest:   return "Bad Request"
        case .unauthorized: return "Unauthorized"
        case .paymentRequired:  return "Payment Required"
        case .forbidden: return "Forbidden"
        case .notFound: return "Not Found"
        case .methodNotAllowed: return "Method Not Allowed"
        case .requestEntityTooLarge: return "Request is Too Large"
        case .responseParseError: return "Unable to parse model object"
        default:
            return "An unknown error occured. Please try again later."
        }
    }
    
    var errorName: String? {
        switch self {
        case .apiError(_, let errorName, _): return errorName
        default:
            return "Unknown Error"
        }
    }
}

func == (lhs: ApiError, rhs: ApiError) -> Bool {
    switch (lhs, rhs) {
    case (.apiError, .apiError):
        return true
    default:
        return false
    }
    
}
