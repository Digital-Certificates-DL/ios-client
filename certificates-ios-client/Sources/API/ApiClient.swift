////
////  ApiClient.swift
////  certificates-ios-client
////
////  Created by Jonikorjk on 16.05.2023.
////
//
//import Foundation
//import Alamofire
//
//protocol ApiClientProvider: AnyObject {
//
//}
//
//class ApiClient {
//    static let shared = ApiClient()
//
//    func getCertificates() async -> [Certificate] {
//
//    }
//
//    private func parsingCertificates(_ certificates: [String: [[String]]]) -> [Certificate] {
//        let certificates = certificates["result1"]
//
//    }
//
//    private func getCertificatesFromAF() async -> [String: [[String]]] {
//        await withUnsafeContinuation { continuation in
//            AF.request("https://script.googleusercontent.com/macros/echo?user_content_key=J6buTV5x-2wY_I8Wpp9XT4qFaC6bIKg8X4qN82cNZnBq1Zxh7N1P5GgzAZNUgOw-rWgEFTgUZXck0xkVQTHnwkg3hCAIDQdLm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnMExAVbLgu_OvrTyJbFzp7VnQMXP5N6ZBiDL1daUbxC5bLyUtlW9p6DC7wiA2qVziWAiUva1N7ZbOOfA_3npVNjd8iUjuBvOBtz9Jw9Md8uu&lib=MqxSBsS-_kO-yCSPTYdB8Zta9yFOYf39W", method: .get).response { result in
//                switch result.result {
//                case .success(let data):
//                    guard let data = data,
//                          let result = try? JSONSerialization.jsonObject(with: data) as? [String: [[String]]] else {
//                        continuation.resume(returning: [:])
//                        return
//                    }
//                    continuation.resume(returning: result)
//                case .failure(let error):
//                    print(error)
//                    continuation.resume(returning: [:])
//                }
//            }
//        }
//
//    }
//}
