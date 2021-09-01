//
//  LoginVC.swift
//  AuthTask
//
//  Created by FAB LAB on 01/09/2021.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import RxSwift
import RxCocoa
import ARSLineProgress

class LoginVC: UIViewController {
    
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!

    var loginManager:LoginManager?
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginManager = LoginManager()
//        GIDSignIn.sharedInstance.delegate = self
//        GIDSignIn.sharedInstance.presentingViewController = self
        
        bindViews()
        subscribeToErrorMessage()
        subscribeToLoginButton()
        subscribeToApiResponse()

    }
    
    @IBAction func btnSignUpPressed(_ sender: Any) {
        let vc = StoryBoards.Main.viewController(identifier: "RegisterVC")
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnSignInWithFacebookPressed(_ sender: Any) {
        btnFacebookTapped()
    }
    
    @IBAction func btnSignInWithGooglePressed(_ sender: Any) {
        let configuration = GIDConfiguration(clientID: "131047975752-1oh738sobep3v29ogmopgltmd7dr56gd.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: self) { user, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                let userId = user?.userID
                let fullName = user?.profile?.name
                let email = user?.profile?.email

                // Details received successfully
                print("id:\(userId ?? "")")
                print("name:\(fullName ?? "")")
                print("email:\(email ?? "")")
                
                self.alertError(message: "id:\(userId ?? "")" + "\n" + "name:\(fullName ?? "")" + "\n" + "email:\(email ?? "")")

                GIDSignIn.sharedInstance.signOut()
            }
        }
    }
}

extension LoginVC {
    
    func bindViews() {
        // textFields
        txtEmailAddress.rx.text.orEmpty.bind(to: viewModel.emailBehavior).disposed(by: disposeBag)
        txtPassword.rx.text.orEmpty.bind(to: viewModel.passwordBehavior).disposed(by: disposeBag)
        // loginButton
        viewModel.isValid().bind(to: btnLogin.rx.isEnabled).disposed(by: disposeBag)
        viewModel.isValid().map { $0 ? 1 : 0.3 }.bind(to: btnLogin.rx.alpha).disposed(by: disposeBag)
    }
    
    func subscribeToLoading() {
        viewModel.loadingBehavior.subscribe { (isLoading) in
//            if isLoading {
                ARSLineProgress.show()
//            } else {
//                ARSLineProgress.hide()
//            }
        }.disposed(by: disposeBag)
    }
    
    func subscribeToErrorMessage() {
        viewModel.errorMessageObservable.subscribe { (error) in
            self.alertError(message: error)
        }.disposed(by: disposeBag)
    }
    
    func subscribeToLoginButton() {
        btnLogin.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.login()
            }.disposed(by: disposeBag)
    }
    
    func subscribeToApiResponse() {
            viewModel.loginModelObservable.subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        }
}

extension LoginVC {
    // Implement these methods only if the GIDSignInUIDelegate is not a subclass of
    // UIViewController.

    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //        myActivityIndicator.stopAnimating()
    }

    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }

    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}

// facebook
extension LoginVC {

    func btnFacebookTapped() {
        if AccessToken.current != nil {
            fetchProfile(loginManager: loginManager!)
        } else {
            loginManager!.logIn(permissions: ["email","public_profile"], from: self, handler: { (loginResults: LoginManagerLoginResult?, error: Error?) -> Void in

                if loginResults != nil && !(loginResults?.isCancelled)! {
                    self.fetchProfile(loginManager: self.loginManager!)
                } else {    // Sign in request cancelled
                    self.alertError(message: error?.localizedDescription ?? "")
                }
            })
        }
    }

    func fetchProfile(loginManager: LoginManager) {
        let parameters = ["fields": "email,picture.type(large),name,gender,age_range,cover,timezone,verified,updated_time,education,religion,friends"]
        GraphRequest(graphPath: "me", parameters: parameters).start{ (connection,result,error)-> Void in

            if error != nil {   // Error occured while logging in
                // handle error
                self.alertError(message: error?.localizedDescription ?? "")
                return
            }

            // Details received successfully
            let dictionary = result as! [String: Any]
            print("id:\(dictionary["id"] as! String)")
            print("name:\(dictionary["name"] as! String)")
            print("email:\(dictionary["email"] as! String)")
            
            self.alertError(message: "id:\(dictionary["id"] as! String)" + "\n" + "name:\(dictionary["name"] as! String)" + "\n" + "email:\(dictionary["email"] as! String)")

            loginManager.logOut()

        }
    }

}
