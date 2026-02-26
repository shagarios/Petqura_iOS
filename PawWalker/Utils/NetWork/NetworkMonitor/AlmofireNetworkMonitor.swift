//
//  AlmofireNetworkMonitor.swift
//  PawWalker
//
//  Created by shagar on 13/05/25.
//

import Alamofire

class AlamofireNetWorkMonitor : NetworkMonitor {
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
