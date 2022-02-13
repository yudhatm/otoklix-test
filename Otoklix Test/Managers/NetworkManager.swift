//
//  NetworkManager.swift
//  Otoklix Test
//
//  Created by Yudha on 13/02/22.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class NetworkManager {
    static let shared = NetworkManager()
    
    func getRequest<T: Codable> (_ baseURL: String = "", parameters: [String: Any] = [:]) -> Observable<T> {
        
        return Observable<T>.create { observer in
            let request = AF.request(baseURL, method: .get, parameters: parameters, encoding: URLEncoding.default)
                .responseDecodable { (responseData: AFDataResponse<T>) in
                    switch responseData.result {
                    case .success(let value):
                        print("response: \(value)")
                        if let statusCode = responseData.response?.statusCode, statusCode == 200 {
                            observer.onNext(value)
                            observer.onCompleted()
                        }
                        else {
                            observer.onError(NSError(domain: "networkError", code: responseData.response?.statusCode ?? -1, userInfo: nil))
                        }
                        
                    case .failure(let error):
                        print("Something went error")
                        print(responseData.response?.statusCode)
                        print(error)
                        print(error.localizedDescription)
                        print(responseData.result)
                        
                        observer.onError(error)
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func postRequest<T: Codable> (_ baseURL: String = "", parameters: [String: Any] = [:]) -> Observable<T> {
        
        return Observable<T>.create { observer -> Disposable in
            let request = AF.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseDecodable { (responseData: AFDataResponse<T>) in
                    switch responseData.result {
                    case .success(let value):
                        print("response: \(value))")

                        if let statusCode = responseData.response?.statusCode, statusCode == 200 {
                            observer.onNext(value)
                            observer.onCompleted()
                        }
                        else {
                            observer.onError(NSError(domain: "networkError", code: responseData.response?.statusCode ?? -1, userInfo: nil))
                        }
                        
                    case .failure(let error):
                        print("Something went error")
                        print(responseData.response?.statusCode)
                        print(error)
                        print(error.localizedDescription)
                        print(responseData.result)
                        
                        observer.onError(error)
                    }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func putRequest<T: Codable> (_ baseURL: String = "", parameters: [String: Any] = [:]) -> Observable<T> {
        
        return Observable<T>.create { observer -> Disposable in
            let request = AF.request(baseURL, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                .responseDecodable { (responseData: AFDataResponse<T>) in
                    switch responseData.result {
                    case .success(let value):
                        print("response: \(value))")
//
                        if let statusCode = responseData.response?.statusCode, statusCode == 200 {
                            observer.onNext(value)
                            observer.onCompleted()
                        }
                        else {
                            observer.onError(NSError(domain: "networkError", code: responseData.response?.statusCode ?? -1, userInfo: nil))
                        }
                        
                    case .failure(let error):
                        print("Something went error")
                        print(responseData.response?.statusCode)
                        print(error)
                        print(error.localizedDescription)
                        print(responseData.result)
                        
                        observer.onError(error)
                    }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func deleteRequest<T: Codable> (_ baseURL: String = "", parameters: [String: Any] = [:]) -> Observable<T> {
        
        return Observable<T>.create { observer -> Disposable in
            let request = AF.request(baseURL, method: .delete, parameters: parameters, encoding: URLEncoding.default)
                .responseDecodable { (responseData: AFDataResponse<T>) in
                    switch responseData.result {
                    case .success(let value):
                        print("response: \(value))")
//
                        if let statusCode = responseData.response?.statusCode, statusCode == 200 {
                            observer.onNext(value)
                            observer.onCompleted()
                        }
                        else {
                            observer.onError(NSError(domain: "networkError", code: responseData.response?.statusCode ?? -1, userInfo: nil))
                        }
                        
                    case .failure(let error):
                        print("Something went error")
                        print(responseData.response?.statusCode)
                        print(error)
                        print(error.localizedDescription)
                        print(responseData.result)
                        
                        observer.onError(error)
                    }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
