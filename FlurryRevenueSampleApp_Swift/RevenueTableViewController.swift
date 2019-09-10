//
//  RevenueTableViewController.swift
//  FlurryRevenueSampleApp_Swift
//
//  Created by Yilun Xu on 10/3/18.
//  Copyright © 2018 Flurry. All rights reserved.
//

import UIKit
import StoreKit
import Flurry_iOS_SDK


class RevenueTableViewController: UITableViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
   
    @IBOutlet weak var autoLogSwitch: UISwitch!
    
    var products = [String]()
    var verifiedProducts = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch products id from plist file
        
        if let path = Bundle.main.path(forResource: "products", ofType: "plist") {
            let info = NSDictionary(contentsOfFile: path)
            let array: Array = info?.object(forKey: "products") as! Array<String>
            self.products = array
        }
        
        let productSet: Set = Set(self.products)
        
        // init request
        let request = SKProductsRequest(productIdentifiers: productSet)
        request.delegate = self
        
        // send the request to the App Store
        request.start()
        
        // add self as an observer, be notified if one or more transactions are being updated
        paymentQueue.add(self)
        
        // record toggle position
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isAuto") != nil {
            autoLogSwitch.setOn(defaults.bool(forKey: "isAuto"), animated: true)
        } else {
            autoLogSwitch.setOn(true, animated: true)
            Flurry.setIAPReportingEnabled(true)
        }

    }
    
    // purchase the item
    func purchase(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            // create a payment and add this payment to the payment queue
            let payment = SKPayment(product: product)
            paymentQueue.add(payment)
        }
    }

    // MARK: - delegate mehod for SKProductRequestDelegate
    // Accepts the reponse from app store that contains the request products information
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.verifiedProducts = response.products
        for product in response.products {
            print("verified product: \(product.localizedTitle)")
        }
        print(verifiedProducts.count)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - delegate mehod for SKPaymentTransactionObserver
    // Tell the observer when one or more transactions are being updated
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased, SKPaymentTransactionState.restored:
                print("Transaction completed successfully.")
                print(transaction.payment.productIdentifier)
                if autoLogSwitch.isOn {
                    displayAlertWithTitle(title: "Success", message: "Payment went through successfully")
                } else {
                    Flurry.logPaymentTransaction(transaction) { (status) in
                        print("\(status)")
                    }
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                break
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                print(transaction.payment.productIdentifier)
                if autoLogSwitch.isOn {
                    displayAlertWithTitle(title: "Failed", message: "Payment did not go through successfully. Error: \(transaction.error.debugDescription)")
                } else {
                    Flurry.logPaymentTransaction(transaction) { (status) in
                        print("status : \(status)")
                    }
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                break
                
            default:
                print(String(transaction.transactionState.rawValue))
                print(transaction.payment.productIdentifier)
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        purchase(product: verifiedProducts[indexPath.row])
    }
    
    // MARK: - switch action
    @IBAction func updateAutoLogSwitch(_ sender: UISwitch) {
        print("value changed")
        Flurry.setIAPReportingEnabled(sender.isOn)
        defaults.set(sender.isOn, forKey: "isAuto")
    }
    
    // MARK: - alert
    func displayAlertWithTitle(title: String, message: String?) -> Void {
        // set alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        self.present(alertController, animated: true, completion: {
        let delay = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: delay){
                alertController.dismiss(animated: true, completion: nil)
            }
        })
        
    }
}
