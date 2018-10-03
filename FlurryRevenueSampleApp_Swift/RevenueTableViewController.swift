//
//  RevenueTableViewController.swift
//  FlurryRevenueSampleApp_Swift
//
//  Created by Yilun Xu on 10/3/18.
//  Copyright © 2018 Flurry. All rights reserved.
//

import UIKit
import StoreKit

enum InAppPurchaseItem: String {
    case consumableItem = "com.yahoo.flurryiap.flurry_test_consumable"
    case nonConsumableItem = "com.yahoo.flurryiap.flurry_test_nonconsumable"
    case autoRenewSubscription = "com.yahoo.flurryiap.flurry_test_autorenew"
    case freeItem = "com.yahoo.flurryiap.flurry_test_subscription_free"
    case nonRenewSubscription = "com.yahoo.flurryiap.flurry_test_subscription_nonrenew"
}

class RevenueTableViewController: UITableViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
   
    var verifiedProducts = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let products: Set = [InAppPurchaseItem.consumableItem.rawValue,
                             InAppPurchaseItem.nonConsumableItem.rawValue,
                             InAppPurchaseItem.autoRenewSubscription.rawValue,
                             InAppPurchaseItem.nonRenewSubscription.rawValue,
                             InAppPurchaseItem.freeItem.rawValue]
        
        // init request
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        
        // add self as an observer, be notified if one or more transactons are being updated
        paymentQueue.add(self)

    }
    
    // purchase the item
    func purchase(product: InAppPurchaseItem) {
        guard let productToPurchase = verifiedProducts.filter({$0.productIdentifier == product.rawValue}).first else {return}
        // add this payment to the payment queue
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }


    // MARK: - delegate mehod for SKProductRequestDelegate
    // Accepts the reponse from app store that contains the request products information
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.verifiedProducts = response.products
        for product in response.products {
            print("verified product: \(product.localizedTitle)")
        }
        print(verifiedProducts.count)
        tableView.reloadData()
    }
    
    // MARK: - delegate mehod for SKPaymentTransactionObserver
    // Tell the observer when one or more transactions are being updated
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
    
    // MARK: - table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return verifiedProducts.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ITEMS"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product =  verifiedProducts[indexPath.row]
        cell.textLabel?.text = product.localizedTitle
        let numberFormatter = NumberFormatter()
        let locale = product.priceLocale
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        cell.detailTextLabel?.text = numberFormatter.string(from: product.price)
        return cell
    }
    
}
