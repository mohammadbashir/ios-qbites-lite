//
//  InAppManager.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 4/5/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//
import StoreKit

public typealias ProductID = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void
public typealias ProductPurchaseCompletionHandler = (_ success: Bool, _ productId: ProductID?) -> Void

// MARK: - IAPManager
public class IAPManager: NSObject  {
    private let productIDs: Set<ProductID>
    private var purchasedProductIDs: Set<ProductID>
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private var productPurchaseCompletionHandler: ProductPurchaseCompletionHandler?

    public init(productIDs: Set<ProductID>) {
        self.productIDs = productIDs
        self.purchasedProductIDs = productIDs.filter { productID in
            let purchased = UserDefaults.standard.bool(forKey: productID)
            if purchased {
                print("Previously purchased: \(productID)")
            } else {
                print("Not purchased: \(productID)")
            }
            return purchased
        }
        super.init()
//        SKPaymentQueue.default().add(self)
        
        if(!observerSet){
            SKPaymentQueue.default().add(self)
            observerSet = true
        }
    }
}

var observerSet = false

// MARK: - StoreKit API
extension IAPManager {
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler

        productsRequest = SKProductsRequest(productIdentifiers: productIDs)
        productsRequest!.delegate = self
        productsRequest!.start()
    }

    public func buyProduct(_ product: SKProduct, _ completionHandler: @escaping ProductPurchaseCompletionHandler) {
        productPurchaseCompletionHandler = completionHandler
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    public func isProductPurchased(_ productID: ProductID) -> Bool {
        return purchasedProductIDs.contains(productID)
    }

    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }

    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequestDelegate
extension IAPManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        guard !products.isEmpty else {
            print("Product list is empty...!")
            print("Did you configure the project and set up the IAP?")
            productsRequestCompletionHandler?(false, nil)
            return
        }
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }

    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver
extension IAPManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                queue.finishTransaction(transaction)
                break
            case .restored:
                restore(transaction: transaction)
                queue.finishTransaction(transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                fatalError()
            }
            
        }
    }

    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        productPurchaseCompleted(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        print("restore... \(productIdentifier)")
        productPurchaseCompleted(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        
        //restore code
    }

    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        var error = ""
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
            error = localizedDescription
        }

        productPurchaseCompletionHandler?(false, nil)
        SKPaymentQueue.default().finishTransaction(transaction)
        clearHandler()
        
        //fail code
        GlobalSubscriptionViewController?.purchuaseFail(error: error)
    }

    private func productPurchaseCompleted(identifier: ProductID?) {
        guard let identifier = identifier else { return }

        purchasedProductIDs.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        productPurchaseCompletionHandler?(true, identifier)
        clearHandler()
        
        //success code
        GlobalSubscriptionViewController?.purchaseSuccess()
    }

    private func clearHandler() {
        productPurchaseCompletionHandler = nil
    }

}

//func receiptValidation() {
//    let SUBSCRIPTION_SECRET = "822bba45b44a4d789a2c19f046305a71"
//    let receiptPath = Bundle.main.appStoreReceiptURL?.path
//    if FileManager.default.fileExists(atPath: receiptPath!)
//    {
//        var receiptData:NSData?
//        do{
//            receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
//        }
//        catch{
//            print("ERROR: " + error.localizedDescription)
//        }
//        //let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//        let base64encodedReceipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
//
//        print(base64encodedReceipt!)
//
//
//        let requestDictionary = ["receipt-data":base64encodedReceipt!,"password":SUBSCRIPTION_SECRET]
//
//        guard JSONSerialization.isValidJSONObject(requestDictionary) else {  print("requestDictionary is not valid JSON");  return }
//        do {
//            let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
//            let validationURLString = "https://sandbox.itunes.apple.com/verifyReceipt"  // this works but as noted above it's best to use your own trusted server
//            guard let validationURL = URL(string: validationURLString) else { print("the validation url could not be created, unlikely error"); return }
//            let session = URLSession(configuration: URLSessionConfiguration.default)
//            var request = URLRequest(url: validationURL)
//            request.httpMethod = "POST"
//            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
//            let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
//                if let data = data , error == nil {
//                    do {
//                        let appReceiptJSON = try JSONSerialization.jsonObject(with: data)
//                        print("success. here is the json representation of the app receipt: \(appReceiptJSON)")
//                        // if you are using your server this will be a json representation of whatever your server provided
//                    } catch let error as NSError {
//                        print("json serialization failed with error: \(error)")
//                    }
//                } else {
//                    print("the upload task returned an error: \(String(describing: error))")
//                }
//            }
//            task.resume()
//        } catch let error as NSError {
//            print("json serialization failed with error: \(error)")
//        }
//
//    }
//}
//
//func receiptExists() -> Bool {
//
//    let receiptPath = Bundle.main.appStoreReceiptURL?.path
//    if FileManager.default.fileExists(atPath: receiptPath!)
//    {
//        return true
//    }
//    else{
//        return false
//    }
//
//}
//
//func getReceipt() -> NSData{
//    let receiptPath = Bundle.main.appStoreReceiptURL?.path
//
//    var receiptData = NSData()
//
//    if FileManager.default.fileExists(atPath: receiptPath!)
//    {
//
//        do{
//            receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
//        }
//        catch{
//            print("ERROR: " + error.localizedDescription)
//        }
//    }
//
//    return receiptData
//}
