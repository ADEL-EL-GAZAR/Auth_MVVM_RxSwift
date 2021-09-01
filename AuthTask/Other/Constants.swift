//
//  Constants.swift
//  AuthTask
//
//  Created by FAB LAB on 01/09/2021.
//

import UIKit

let K_Main_URL = "https://store.zeew.eu"
let K_API_URL = K_Main_URL + "/v1"
let K_Device_ID = UIDevice.current.identifierForVendor!.uuidString
let K_Defaults = UserDefaults.standard
let K_Notifications = NotificationCenter.default
let K_AppDelegate = UIApplication.shared.delegate as! AppDelegate
let K_SceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
let K_Parse_Error = "Something is not correct, please try again later"
let K_Server_Error = "Something happened. Please try again later"
let K_Invalid_Access = "يرجى تسجيل الدخول اولا لاتمام العملية"


enum Saved { //keys of userDefaults
    static let token = "token"
    static let fcmToken = "fcmToken"
    static let deviceToken = "deviceToken"
}

enum StoryBoards {
    case Main

    var storyboard: UIStoryboard {
        switch self {
        case .Main:
            return UIStoryboard(name: "Main", bundle: nil)
        }
    }
    
    func viewController(identifier: String) -> UIViewController {
        return self.storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
