//
//  apiService.swift
//  AuthTask
//
//  Created by FAB LAB on 01/09/2021.
//

import Moya

let ApiProvider = MoyaProvider<apiService>()

enum apiService {
    case CustomerLogin(username:String, password:String, device_id:String, device_type:String)
    case CustomerSignUp(action:String, first_name:String, last_name:String, username:String, phone_number:String, user_country_code:String, password:String, referral_code:String)
}

// MARK: - TargetType Protocol Implementation
extension apiService: TargetType {
    var baseURL: URL { return URL(string: K_API_URL)! }
    
    var path: String {
        switch self {
        // Account
        case .CustomerLogin:
            return "/CustomerLogin"
        case .CustomerSignUp:
            return "/CustomerSignUp"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .CustomerLogin, .CustomerSignUp:
            return .post
        default:
            return .get
        }
    }
    
    
    var parameters: [String: Any]? {
        switch self {
        case .CustomerLogin(let username, let password, let device_id, let device_type):
            var parameters = [String: Any]()
            parameters["username"] = username
            parameters["password"] = password
            parameters["device_id"] = device_id
            parameters["device_type"] = device_type
            return parameters
        case .CustomerSignUp(let action, let first_name, let last_name, let username, let phone_number, let user_country_code, let password, let referral_code):
            var parameters = [String: Any]()
            parameters["action"] = action
            parameters["first_name"] = first_name
            parameters["last_name"] = last_name
            parameters["username"] = username
            parameters["phone_number"] = phone_number
            parameters["user_country_code"] = user_country_code
            parameters["password"] = password
            parameters["referral_code"] = referral_code
            return parameters
        default:
            return [String: Any]()
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        return JSONEncoding.default
    }
    
    var task: Task {
        switch self {
        case .CustomerLogin, .CustomerSignUp:
            return .requestParameters(parameters: parameters!, encoding: JSONEncoding.default)

        default:
            return .requestParameters(parameters: parameters!, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        print("\(K_Defaults.string(forKey: Saved.token) ?? "")")
        var parameters = [String: String]()
//        parameters["Authorization"] = "Bearer \(K_Defaults.string(forKey: Saved.token) ?? "")"
//        parameters["Accept-Language"] = "ar"
//        parameters["Accept"] = "application/json"
        return parameters
    }
    
    var sampleData: Data {
        return Data()
    }
    
}
