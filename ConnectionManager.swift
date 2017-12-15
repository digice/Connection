//
//  ConnectionManager.swift
//  Connection
//
//  Created by Roderic Linguri <linguri@digices.com>
//  License: MIT
//  Copyright © 2017 Digices LLC. All rights reserved.
//

import UIKit

protocol ConnectionManagerDelegate {
  func connectionManager(_ manager: ConnectionManager, sendStatus status: Bool)
  func connectionManager(_ manager: ConnectionManager, didProduceError error: Error)
  func connectionManager(_ manager: ConnectionManager, didReceiveData data: Data)
} // ./ConnectionManager

class ConnectionManager {
  
  var delegate: ConnectionManagerDelegate
  
  /**
   * Create a ConnectionManager instance with a delegate
   * - parameter: delegate to receive notifications
   */
  init(delegate: ConnectionManagerDelegate) {
    self.delegate = delegate
  }

  /**
   * Receive completion of URLSession Task
   * - parameter: optional Data (body of the response)
   * - parameter: optional URLResponse (contains response codes, etc.)
   * - parameter: optional Error (Server Error, not-found etc.)
   */
  func completionHandler(data: Data?, response: URLResponse?, error: Error?) {
    
    if let e = error {
      OperationQueue.main.addOperation { [weak self] in
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if let weakSelf = self {
          weakSelf.delegate.connectionManager(weakSelf, didProduceError: e)
        } // ./unwrap self
      } // ./main queue
    } // ./unwrap error
    
    if let d = data {
      OperationQueue.main.addOperation { [weak self] in
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if let weakSelf = self {
          weakSelf.delegate.connectionManager(weakSelf, didReceiveData: d)
        } // ./unwrap self
      } // ./main queue
    } // ./unwrap data
    
  } // ./completionHandler
  
  /**
   * Send a connection request
   * - parameter: a Connection object
   */
  func sendRequest(forConnection connection: Connection) {
    
    if let request = connection.request {
      let task = URLSession.shared.dataTask(with: request, completionHandler: self.completionHandler)
      task.resume()
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      self.delegate.connectionManager(self, sendStatus: true)
    } // ./we have a request
    
    else {
      self.delegate.connectionManager(self, didProduceError: ConnectionError.requestCreationError)
    } // ./request was nil
    
  } // ./sendRequest
  
} // ./ConnectionManager
