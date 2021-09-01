//
//  NetworkRequest.swift
//  ProductiveFamilies
//
//  Created by ADEL ELGAZAR on 10/3/20.
//  Copyright © 2020 ADEL ELGAZAR. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import ARSLineProgress

class NetworkRequest {
    
    /// responsible for sending requests to server in all application and handling the result in case of success or fail
    /// plus it containing loading popup and control showing and hiding it
    /// - Parameters:
    ///   - function: which request you need to call
    ///   - showLoading: show loading popup or not
    ///   - success: callback occur when response is success
    ///   - failure: callback occur when response is fail
    /// - Returns: nil
    func sendRequest(function:apiService, showLoading:Bool = true, success:@escaping(_ code:String, _ msg:String, _ response :Response)->(), failure:@escaping (_ code:String, _ msg:String, _ response :Response, _ errors:[NetworkValidationError])->()) {
        
        if showLoading {
            ARSLineProgress.show()
        }
        let provider = MoyaProvider<apiService>()
        provider.request(function) { (result) in
            if showLoading {
                ARSLineProgress.hide()
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    do {
                        let Dic = try response.mapJSON() as! [String: Any]
                        switch "\(Dic["responseCode"] ?? "")" {
                        case "0":
                            success("", "", response)
                        case "100":
                            failure("\(Dic["responseCode"] ?? "")", "\(Dic["responseMessage"] ?? "")", response, [])
                        case "101":
                            failure("\(Dic["responseCode"] ?? "")", "\(Dic["responseMessage"] ?? "")", response, [])
                        case "200":
                            success("\(response.statusCode)", "\(Dic["responseMessage"] ?? "")", response)
                        case "400":
                            let errors = try response.map(to: [NetworkValidationError].self, keyPath: "validationErrors")
                            failure("\(response.statusCode)", "\(Dic["responseMessage"] ?? "")", response, errors)
                        case "401":
                            failure("\(response.statusCode)", "\(Dic["responseMessage"] ?? "")", response, [])
                        case "403":
                            failure("\(response.statusCode)", "\(Dic["responseMessage"] ?? "")", response, [])
                        case "404":
                            failure("\(response.statusCode)", "\(Dic["responseMessage"] ?? "")", response, [])
                        case "422":
                            failure("\(response.statusCode)", "\(Dic["responseMessage"] ?? "")", response, [])
                        case "500":
                            failure("\(response.statusCode)", "\(Dic["responseMessage"] ?? "")", response, [])
                        case "600":
                            failure("\(Dic["responseCode"] ?? "")", "\(Dic["responseMessage"] ?? "")", response, [])
                        default:
                            failure("\(response.statusCode)", "", response, [])
//                            Toast(text: K_Server_Error).show()
                        }
                    } catch {
                        let userIdentifier = K_Defaults.string(forKey: Saved.userIdentifier) ?? ""
                        if userIdentifier.isEmpty {
                            self.login(eMailOrPhoneNumber: K_Defaults.string(forKey: Saved.phoneNumber) ?? "", password: K_Defaults.string(forKey: Saved.password) ?? "")
                        } else {
                            let tokenProvider = K_Defaults.integer(forKey: Saved.tokenProvider)
                            self.authenticateWithSocial(tokenProvider: tokenProvider, userIdentifier: userIdentifier)
                        }
                    }
                case .failure( _):
                    return
//                    Toast(text: error.localizedDescription).show()
                }
            }
        }
    }
    
    
    /// login request and it put here to be shared in application
    /// - Parameters:
    ///   - eMailOrPhoneNumber: your email or phone number
    ///   - password: your password
    func login(eMailOrPhoneNumber: String, password: String) {
        K_Network.sendRequest(function: apiService.authenticate(eMailOrPhoneNumber: eMailOrPhoneNumber, password: password), showLoading: false, success: { (code, msg, response)  in
            do {
                let user = try response.map(to: User.self, keyPath: "responseData")
                
                K_AppDelegate.saveUserData(user: user)
                K_Defaults.set(password, forKey: Saved.password)
                K_Defaults.set("", forKey: Saved.userIdentifier)
                K_Defaults.set(0, forKey: Saved.tokenProvider)
                K_AppDelegate.window?.rootViewController = StoryBoards.Main.viewController(identifier: "swMain")

            } catch {
            }
            
        }) { (code, msg, response, errors) in
        }
    }
    
    /// ogin request using social media data and it put here to be shared in application
    /// - Parameters:
    ///   - tokenProvider: social media type (see types in "Enum SocialProviders")
    ///   - userIdentifier: user identifier provided by social media
    ///   - name: name provided by social media
    ///   - email: email provided by social media
    func authenticateWithSocial(tokenProvider: Int, userIdentifier: String) {
        K_Network.sendRequest(function: apiService.authenticateWithSocial(tokenProvider: tokenProvider, userIdentifier: userIdentifier), success: { (code, msg, response)  in
            do {
                let user = try response.map(to: User.self, keyPath: "responseData")
                
                K_AppDelegate.saveUserData(user: user)
                K_Defaults.set(userIdentifier, forKey: Saved.userIdentifier)
                K_Defaults.set(tokenProvider, forKey: Saved.tokenProvider)
                K_AppDelegate.window?.rootViewController = StoryBoards.Main.viewController(identifier: "swMain")

            } catch {
            }
            
        }) { (code, msg, response, errors) in
        }
    }
}


/// this model is made to handle validation messages from the server
public class NetworkValidationError:Mappable {
    var field = ""
    var message = ""
    
    required public init (map: Mapper) throws {
        field = map.optionalFrom("field") ?? ""
        message = map.optionalFrom("message") ?? ""
    }
}
