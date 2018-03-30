//
//  IAPHelper.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 1.03.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

struct IAPHelperNotificationObject {
  let productIdentifier: String?
  let error: Error?
}

enum IAPHelperError: Error {
  case noProductFound
  case noPurchasedProductFound

  var localizedDescription: String {
    switch self {
    case .noProductFound:
      return "No product found."
    case .noPurchasedProductFound:
      return "No purchased product found."
    }
  }
}

open class IAPHelper: NSObject {
  static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
  static let IAPHelperRestoreNotification = "IAPHelperRestoreNotification"
  static let IAPHelperPurchaseFailedNotification = "IAPHelperPurchaseFailedNotification"
  
  fileprivate let productIdentifiers: Set<ProductIdentifier>
  fileprivate var purchasedProductIdentifiers = Set<ProductIdentifier>()
  fileprivate var productsRequest: SKProductsRequest?
  fileprivate var productsRequestCompletionHandler: ProductRequestCompletionHandler?
  
  public init(productIds: Set<ProductIdentifier>) {
    productIdentifiers = productIds
    for productIdentifier in productIds {
      let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
      if purchased {
        purchasedProductIdentifiers.insert(productIdentifier)
      }
    }
    
    super.init()
    SKPaymentQueue.default().add(self)
  }
}

//MARK: StoreKit API
extension IAPHelper {
  public func requestProducts(completionHandler: @escaping ProductRequestCompletionHandler) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler

    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest?.delegate = self
    productsRequest?.start()
  }

  public func buyProduct(_ product: SKProduct) {
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }

  public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
    return purchasedProductIdentifiers.contains(productIdentifier)
  }

  public class func canMakePayments() -> Bool {
    return SKPaymentQueue.canMakePayments()
  }

  public func restorePurchases() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
}

//MARK: - SKProductsRequestDelegate
extension IAPHelper: SKProductsRequestDelegate {
  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    let products = response.products
    productsRequestCompletionHandler?(true, products)
    clearRequestAndHandler()
  }

  public func request(_ request: SKRequest, didFailWithError error: Error) {
    productsRequestCompletionHandler?(false, nil)
    clearRequestAndHandler()
  }

  private func clearRequestAndHandler() {
    productsRequest = nil
    productsRequestCompletionHandler = nil
  }
}

// MARK: - SKPaymentTransactionObserver
extension IAPHelper: SKPaymentTransactionObserver {
  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    print("Update Transaction")
    for transaction in transactions {
      if transaction.downloads.count > 0 {
        SKPaymentQueue.default().start(transaction.downloads)
      }
      
      switch (transaction.transactionState) {
      case .purchased:
        print("COMPLETE")
        complete(transaction: transaction)
        break
      case .failed:
        print("FAIL")
        fail(transaction: transaction)
        break
      case .restored:
        print("RESTORE")
        restore(transaction: transaction)
        break
      case .purchasing:
        print("Purchasing")
      case .deferred:
        print("Deferred")
      }
    }
  }

  public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    if queue.transactions.count == 0 {
      deliverPurchaseFailedNotificationFor(identifier: nil, error: IAPHelperError.noPurchasedProductFound)
      return
    }

    paymentQueue(queue, updatedTransactions: queue.transactions)
  }

  public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
    print("Restore failed")
    deliverPurchaseFailedNotificationFor(identifier: nil, error: error)
  }

  private func complete(transaction: SKPaymentTransaction) {
    deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }

  private func restore(transaction: SKPaymentTransaction) {
    if let productIdentifier = transaction.original?.payment.productIdentifier {
      deliverRestoreNotificationFor(identifier: productIdentifier)
    }

    SKPaymentQueue.default().finishTransaction(transaction)
  }

  private func fail(transaction: SKPaymentTransaction) {
    if let productIdentifier = transaction.original?.payment.productIdentifier,
      let transactionError = transaction.error as NSError? {
      print(transactionError.localizedDescription)
      deliverPurchaseFailedNotificationFor(identifier: productIdentifier, error: transactionError)
    }
    print(transaction.error?.localizedDescription)
    SKPaymentQueue.default().finishTransaction(transaction)
  }

  private func deliverPurchaseFailedNotificationFor(identifier: String?, error: Error?) {
    let obj = IAPHelperNotificationObject(productIdentifier: identifier, error: error)
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseFailedNotification),
                                    object: obj)
  }

  private func addProductToPurchased(identifier: String) {
    purchasedProductIdentifiers.insert(identifier)
    UserDefaults.standard.set(true, forKey: identifier)
    UserDefaults.standard.synchronize()
  }

  private func deliverPurchaseNotificationFor(identifier: String?) {
    guard let identifier = identifier else { return }

    addProductToPurchased(identifier: identifier)

    let obj = IAPHelperNotificationObject(productIdentifier: identifier, error: nil)
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                    object: obj)
  }

  private func deliverRestoreNotificationFor(identifier: String?) {
    guard let identifier = identifier else { return }

    addProductToPurchased(identifier: identifier)

    let obj = IAPHelperNotificationObject(productIdentifier: identifier, error: nil)
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperRestoreNotification),
                                    object: obj)
  }
}

extension IAPHelper: SKRequestDelegate {
  private func validateAppReceipt(_ receipt: Data) {
    let base64encodedReceipt = receipt.base64EncodedString()
    let requestDictionary = ["receipt-data": base64encodedReceipt]
    
    guard JSONSerialization.isValidJSONObject(requestDictionary) else { return }
    print("Validation")
    do {
      let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
      #if DEBUG
      let validationURLString = "https://sandbox.itunes.apple.com/verifyReceipt"
      #else
      let validationURLString = "https://buy.itunes.apple.com/verifyReceipt"
      #endif
      
      guard let validationURL = URL(string: validationURLString) else { return }
      
      let session = URLSession(configuration: URLSessionConfiguration.default)
      var request = URLRequest(url: validationURL)
      
      request.httpMethod = "POST"
      request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
      
      let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
        if let data = data, error == nil {
          do {
            let appReceiptJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            print(appReceiptJSON)
            guard let statusCode = appReceiptJSON?["status"] as? Int else { return }
            User.isPremiumVersionActive = statusCode == 0
          } catch {}
        }
      }
      
      task.resume()
    } catch {}
  }
  
  public func getAppReceipt() {
    guard let receiptURL = Bundle.main.appStoreReceiptURL else { return }
    do {
      let receipt = try Data(contentsOf: receiptURL)
      validateAppReceipt(receipt)
    } catch {
      let appReceiptRefreshRequest = SKReceiptRefreshRequest(receiptProperties: nil)
      appReceiptRefreshRequest.delegate = self
      appReceiptRefreshRequest.start()
    }
  }
  
  public func requestDidFinish(_ request: SKRequest) {
    guard let receiptURL = Bundle.main.appStoreReceiptURL else { return }
    do {
      let receipt = try Data(contentsOf: receiptURL)
      validateAppReceipt(receipt)
    } catch {}
  }
}
