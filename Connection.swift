//
//  Connection.swift
//  Connection
//
//  Created by Roderic Linguri <linguri@digices.com>
//  License: MIT
//  Copyright © 2017 Digices LLC. All rights reserved.
//

import UIKit

class Connection {
  
  let urlString: String
  
  var method: HTTPMethod
  
  var authType: AuthType
  
  var authString: String?
  
  var parameters: [String:String]?
  
  var headers: [String:String]?
  
  var error: Error?
  
  var request: URLRequest? {
    get {
      
      // make a copy of our stored URL
      var urlString: String = self.urlString.copy() as! String
      
      // initialize body with empty string
      var bodyString: String = ""
      
      // initialize empty data
      var bodyData: Data? = nil
      
      // check for GET
      if self.method == .get {
        if let params = self.parameters {
          urlString.append("?")
          let c = params.count
          var i = 1
          for (key, value) in params {
            urlString.append("\(key)=\(value)")
            if i < c {
              urlString.append("&")
            } // ./still have params
            i += 1
          } // ./params iterator
        } // ./we have params
      } // ./get
      
      // check for POST
      if self.method == .post {
        if let params = self.parameters {
          let c = params.count
          var i = 1
          for (key, value) in params {
            bodyString.append("\(key)=\(value)")
            if i < c {
              bodyString.append("&")
            }
            i += 1
          } // ./params iterator
          bodyData = bodyString.data(using: .utf8)
        } // ./we have params
      } // ./post
      
      if let url = URL(string: "\(urlString)") {
        
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = self.method.rawValue
        
        if self.authType != .none {
          if let authData: Data = self.authString?.data(using: .utf8) {
            let encodedAuth = authData.base64EncodedString(options: [])
            // force unwrap authTypeString because we have verified that authType is not none
            let value = "\(self.authType.rawValue) \(encodedAuth)"
            request.setValue(value, forHTTPHeaderField: "Authorization")
          } // ./authString converted to data
          
          else {
            self.error = ConnectionError.nilAuthString
          } // ./authString is nil

        } // /./some type of authorization
        
        if self.method == .post {
          if let data = bodyData {
            request.httpBody = data
          } // ./have POST data
        } // ./this is a POST
        
        if let headers = self.headers {
          request.allHTTPHeaderFields = headers
        }
        
        return request
      } // ./url is valid
      return nil
    }
  } // var request
  
  /**
   * Construct a new Connection object
   * - parameter: String
   * - parameter: HTTPMethod default is GET
   * - parameter: AuthType default is none
   */
  init(urlString: String, method: HTTPMethod = .get, authType: AuthType = .none) {
    self.urlString = urlString
    self.method = method
    self.authType = authType
  }
  
} // ./Connection
