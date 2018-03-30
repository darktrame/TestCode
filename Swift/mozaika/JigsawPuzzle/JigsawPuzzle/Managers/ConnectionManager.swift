//
//  ConnectionManager.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 12.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

fileprivate enum API: String {
  case getPicturesLibrary = "http://yourjigs.w10.hoster.by/api/picture/getpictureslibrary"//"http://yourjigsawpuzzleweb20180305111114.azurewebsites.net/api/picture/getpictureslibrary"
}

class ConnectionManager {
  static let sharedInstance = ConnectionManager()
  
  private func apiRequest(url: URL,
                           method: HTTPMethod,
                           parameters: Parameters?,
                           encoding: ParameterEncoding = URLEncoding.default,
                           completion: @escaping (_ response: JSON?, _ error: String?) -> Void) {
    Alamofire.request(url,
                      method: method, parameters: parameters,
                      encoding: encoding, headers: nil).responseJSON { (respond) in
                        switch respond.result {
                        case .success(let value):
                          if JSONSerialization.isValidJSONObject(value) {
                            if let data = try? JSONSerialization.data(withJSONObject: value, options: []) {
                              let json = try? JSON(data: data)
                              completion(json, nil)
                            }
                          } else {
                            completion(nil, "Error Serialization!")
                          }
                        case .failure(_):
                          completion(nil, "Error connection!")
                        }
    }
  }
  
  // MARK: - API
  func getPicturesLibrary(completion: @escaping (_ response: Array<PicturesModel>?, _ error: String?) -> Void) {
    guard let url = try? API.getPicturesLibrary.rawValue.asURL() else { return }
    apiRequest(url: url, method: .get, parameters: nil) { (response, error) in
      guard error == nil else { completion(nil, error); return }
      guard let json = response else { completion(nil, error); return }
      let pictures = JSONParser(json).parsePicturesLibrary()
      completion(pictures, nil)
    }
  }
}
