//
//  NetworkError.swift
//  Networking
//
//  Created by Seth on 4/6/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import Foundation


/// Specifies the possible errors that could be returned for a network request that are server related and not api related.
///
/// - invalidRequest: Specifies errors where the server does not know how to process the request sent.
/// - requestError: Specifies generic errors with the server request.
/// - responseError: Specifies any kind of response errors.
/// - networkUnreachable: Specifies errors where the request is unable to be sent due to network connectivity issues.
enum NetworkError: Error {
    case invalidRequest
    case requestError
    case responseError
    case networkUnreachable
}
