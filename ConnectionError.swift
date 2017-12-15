//
//  ConnectionError.swift
//  Connection
//
//  Created by Roderic Linguri <linguri@digices.com>
//  License: MIT
//  Copyright © 2017 Digices LLC. All rights reserved.
//

import Foundation

class ConnectionError {
  
  static let requestCreationError: Error = NSError(domain:"Connection", code: 90000, userInfo: [kCFErrorLocalizedDescriptionKey as String:"Request failed to be created"]) as Error

  static let nilAuthString: Error = NSError(domain:"Connection", code: 90000, userInfo: [kCFErrorLocalizedDescriptionKey as String:"Authorization string cannot be nil"]) as Error
  
}
