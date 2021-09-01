//
//  LoginViewModel.swift
//  AuthTask
//
//  Created by FAB LAB on 01/09/2021.
//

import Foundation
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import RxSwift
import RxCocoa
import SwiftValidators
import Moya_ObjectMapper

class LoginViewModel:NSObject {
    let disposeBag = DisposeBag()
    
    var emailBehavior = BehaviorRelay<String>(value: "")
    var passwordBehavior = BehaviorRelay<String>(value: "")
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    private var errorMessageSubject = PublishSubject<String>()
    var errorMessageObservable: Observable<String> {
        return errorMessageSubject
    }
    
    private var loginModelSubject = PublishSubject<LoginModel>()
    
//    private var loginWithSocialSubject = PublishSubject<User>()
//
//    var loginWithSocialObservable: Observable<User> {
//        return loginWithSocialSubject
//    }
    
    var loginModelObservable: Observable<LoginModel> {
        return loginModelSubject
    }
    
    var isEmailValid: Observable<Bool> {
        return emailBehavior.asObservable().map { email -> Bool in
            return Validator.isEmail().apply(email)
        }
    }
    
    var isPasswordValid: Observable<Bool> {
        return passwordBehavior.asObservable().map { password -> Bool in
            return password.count >= 6
        }
    }
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(isEmailValid, isPasswordValid).map { isEmailValid, isPasswordValid in
            return isEmailValid && isPasswordValid
        }.startWith(false)
    }
    
    func login() {
        loadingBehavior.accept(true)
        ApiProvider.rx.request(.CustomerLogin(username: emailBehavior.value, password: passwordBehavior.value, device_id: "FCM_TOKEN", device_type: "ANDROID"))
            .mapObject(LoginModel.self)
            .subscribe { (value) in
                
                self.loadingBehavior.accept(false)
                if value.result?.success == 0 {
                    self.errorMessageSubject.onNext(value.result?.message ?? "")
                } else {
                    self.errorMessageSubject.onNext("customerId: \(value.result?.customerId ?? 0)")
                }
                self.loginModelSubject.onNext(value)
            } onError: { (error) in
                self.loadingBehavior.accept(false)
                self.errorMessageSubject.onNext(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
//    func loginWithSocial(user: User, socialType: String) {
//        loadingBehavior.accept(true)
//        ApiProvider.rx.request(.socialLogin(socialId: user.uid, socialType: socialType, name: nil, email: nil, phone: nil, roleId: nil))
//            .mapObject(Login.self)
//            .subscribe { (value) in
//                if value.code == 200 {
//                    MyUserDefaults.setUser(value.data?.user)
//                    self.loginModelSubject.onNext(value)
//                } else if value.code == 404 {
//                    self.socialTypeBehavior.accept(socialType)
//                    self.loginWithSocialSubject.onNext(user)
//                }
//            } onError: { (error) in
//                self.loadingBehavior.accept(false)
//                self.errorMessageSubject.onNext(error.localizedDescription)
//                print(error)
//            }.disposed(by: disposeBag)
//    }
//
//    func loginWithGoogle(vc: UIViewController) {
//        loadingBehavior.accept(true)
//        // Google SignIn
//        GIDSignIn.sharedInstance()?.presentingViewController = vc
//
//        // Automatically sign in the user.
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().signIn()
//    }
//
//    func loginWithFacebook(vc: UIViewController) {
//        loadingBehavior.accept(true)
//        let loginManager = LoginManager()
//        loginManager.logIn(permissions: [.publicProfile, .email], viewController: vc) { (result) in
//            self.loadingBehavior.accept(false)
//            switch result {
//            case .cancelled:
//                print("Cancel button click")
//            case .success:
//                guard let accessToken = AccessToken.current else {
//                    print("Failed to get access token")
//                    return
//                }
//                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//                // Perform login by calling Firebase APIs
//                Auth.auth().signIn(with: credential) { (user, error) in
//                    if let error = error {
//                        print(error)
//                        return
//                    }
//                    guard let user = user?.user else { return }
//                    self.loginWithSocial(user: user, socialType: "facebook")
//
//                    let firebaseAuth = Auth.auth()
//                    do {
//                        loginManager.logOut()
//                        try firebaseAuth.signOut()
//                    } catch let signOutError as NSError {
//                        print("Error signing out: %@", signOutError)
//                    }
//                }
//            default:
//                print("??")
//            }
//        }
//    }
//}
//
//// MARK: - GIDSignInUIDelegate
//extension LoginViewModel: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        self.loadingBehavior.accept(false)
//        if let error = error {
//            print(error)
//            return
//        }
//
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
//        Auth.auth().signIn(with: credential) { (user, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//            guard let user = user?.user else { return }
//            self.loginWithSocial(user: user, socialType: "google")
//
//            let firebaseAuth = Auth.auth()
//            do {
//                GIDSignIn.sharedInstance().signOut()
//                try firebaseAuth.signOut()
//            } catch let signOutError as NSError {
//                print("Error signing out: %@", signOutError)
//            }
//        }
//    }
}
