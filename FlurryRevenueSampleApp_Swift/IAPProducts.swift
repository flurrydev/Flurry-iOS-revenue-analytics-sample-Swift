//
//  IAPProducts.swift
//  FlurryRevenueSampleApp_Swift
//
//  Created by Yilun Xu on 10/3/18.
//  Copyright © 2018 Flurry. All rights reserved.
//

import Foundation

enum IAPProduct: String {
    case consumable = "com.yahoo.flurryiap.flurry_test_consumable"
    case consumable2 = "com.yahoo.flurryiap.flurry_test_nonconsumable_2"
    case nonConsumable = "com.yahoo.flurryiap.flurry_test_nonconsumable"
    case autoRenew = "com.yahoo.flurryiap.flurry_test_autorenew"
    case free = "com.yahoo.flurryiap.flurry_test_subscription_free"
    case nonRenew = "com.yahoo.flurryiap.flurry_test_subscription_nonrenew"
}
