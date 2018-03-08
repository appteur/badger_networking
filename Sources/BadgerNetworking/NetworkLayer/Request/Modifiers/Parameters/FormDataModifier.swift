//
//  FormDataModifier.swift
//  Networking
//
//  Created by Seth on 3/15/17.
//  Copyright © 2017 Arnott Industries, Inc. All rights reserved.
//

import Foundation

public class FormDataModifier: NetworkRequestModifier {
    
    var postParams: [String : Any]?
    var postData: Data?
    
    var fileType: String = ""
    var contentType: String?
    
    init(params: [String : Any], fileType: String = "image/png") {
        postParams = params
        self.fileType = fileType
        toFormData()
    }
    
    func toFormData() {
        guard let postParams = postParams else {
            return
        }
        
        // setup boundary and content type
        let boundary = "-----------------------------7771935987712374---------------------"
        contentType = "multipart/form-data; boundary="+boundary
        
        
        var body : Data = Data()
        
        var files: [String : Data] = [:]
        
        // add non file parameters to body, pull files out and put into files array
        for (key,value) in postParams {
            
            if let value = value as? Data {
                // add files to array for files
                files[key] = value
            } else {
                // add post param to body
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        
        // now add files to body
        for (key,value) in files {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(fileType)\r\n\r\n".data(using: .utf8)!)
            body.append(value)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // now close the body data
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        postData = body
    }
    
    
    func configure(request: inout URLRequest, with config: RemoteConfig) {
        guard let body = postData else {
            return
        }
        
        request.httpBody = body
        request.addValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        
        if let contentType = contentType {
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
    }
}
