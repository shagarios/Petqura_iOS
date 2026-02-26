//
//  Connectivity .swift
//  PawWalker
//
//  Created by shagar on 25/04/25.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

