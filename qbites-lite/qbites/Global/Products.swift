//
//  Products.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 4/11/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation

public struct qbitesProducts {
  public static let monthlySub = "qbites_subscription_1"
  public static let yearlySub = "qbites_subscription_2"
  public static let store = IAPManager(productIDs: qbitesProducts.productIDs)
  public static let productIDs: Set<ProductID> = [qbitesProducts.monthlySub, qbitesProducts.yearlySub]
}

public func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
