//
//  NetworkReachability.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/08/05.
//

import Foundation
import SystemConfiguration

// NetworkReachability.swift

class NetworkReachability: ObservableObject {
  @Published private(set) var reachable: Bool = false
  private let reachability = SCNetworkReachabilityCreateWithName(nil, "com.epiens.meal")

  init() {
    self.reachable = checkConnection()
  }

  private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
    let isReachable = flags.contains(.reachable)
    let connectionRequired = flags.contains(.connectionRequired)
    let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
    let canConnectWithoutIntervention = canConnectAutomatically && !flags.contains(.interventionRequired)

    return isReachable && (!connectionRequired || canConnectWithoutIntervention)
  }

  func checkConnection() -> Bool {
    var flags = SCNetworkReachabilityFlags()
    SCNetworkReachabilityGetFlags(reachability!, &flags)

    return isNetworkReachable(with: flags)
  }

}
