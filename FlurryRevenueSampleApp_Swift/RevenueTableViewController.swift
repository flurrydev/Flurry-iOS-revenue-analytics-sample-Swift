//
//  RevenueTableViewController.swift
//  FlurryRevenueSampleApp_Swift
//
//  Created by Yilun Xu on 10/3/18.
//  Copyright © 2018 Flurry. All rights reserved.
//

import UIKit
import StoreKit

class RevenueTableViewController: UITableViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productsSet: Set = [IAPProduct.consumable.rawValue,
                             IAPProduct.consumable2.rawValue,
                             IAPProduct.nonConsumable.rawValue,
                             IAPProduct.autoRenew.rawValue,
                             IAPProduct.nonRenew.rawValue,
                             IAPProduct.free.rawValue]
        let request = SKProductsRequest(productIdentifiers: productsSet)
        request.delegate = self
        request.start()
        paymentQueue.add(self)

    }
    
    func purchase(product: IAPProduct) {
        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first else {return}
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: self.purchase(product: .consumable)
        case 1: self.purchase(product: .consumable2)
        case 2: self.purchase(product: .nonConsumable)
        case 3: self.purchase(product: .autoRenew)
        case 4: self.purchase(product: .nonRenew)
        case 5: self.purchase(product: .free)
        default:
            print("restore")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
            print("here \(product.localizedTitle)")
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                print("Transaction completed successfully.")
                print(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                print(transaction.error.debugDescription )
                print(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
                
            case SKPaymentTransactionState.restored:
                print("Transaction completed successfully.")
                print(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
                
            default:
                NSLog(String(transaction.transactionState.rawValue))
                break
            }
        }
    }
    

}
