//
//  AuthType.swift
//  Connection
//
//  Created by Roderic Linguri <linguri@digices.com>
//  License: MIT
//  Copyright © 2017 Digices LLC. All rights reserved.
//

import UIKit

enum AuthType: String {
  case none = ""
  case basic = "Basic"
  case bearer = "Bearer"
  case digest = "Digest"
  case hawk = "Hawk"
  case aws = "AWS4-HMAC-SHA256"
}
