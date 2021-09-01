//
//  LoginViewModel.swift
//  AuthTask
//
//  Created by FAB LAB on 01/09/2021.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftValidators
import Moya_ObjectMapper

class RegisterViewModel:NSObject {
    let disposeBag = DisposeBag()
    
    var firstNameBehavior = BehaviorRelay<String>(value: "")
    var lastNameBehavior = BehaviorRelay<String>(value: "")
    var emailAddressBehavior = BehaviorRelay<String>(value: "")
    var countryCodeBehavior = BehaviorRelay<String>(value: "")
    var phoneNumberBehavior = BehaviorRelay<String>(value: "")
    var passwordBehavior = BehaviorRelay<String>(value: "")
    var confirmPasswordBehavior = BehaviorRelay<String>(value: "")
    var referralCodeBehavior = BehaviorRelay<String>(value: "")
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    private var errorMessageSubject = PublishSubject<String>()
    var errorMessageObservable: Observable<String> {
        return errorMessageSubject
    }
    
    private var registerModelSubject = PublishSubject<LoginModel>()
    
    var registerModelObservable: Observable<LoginModel> {
        return registerModelSubject
    }
    
    var isFirstNameValid: Observable<Bool> {
        return firstNameBehavior.asObservable().map { fName -> Bool in
            return fName.count >= 6
        }
    }
    
    var isLastNameValid: Observable<Bool> {
        return lastNameBehavior.asObservable().map { lName -> Bool in
            return lName.count >= 6
        }
    }
    
    var isEmailValid: Observable<Bool> {
        return emailAddressBehavior.asObservable().map { email -> Bool in
            return Validator.isEmail().apply(email)
        }
    }

    var isPhoneValid: Observable<Bool> {
        return phoneNumberBehavior.asObservable().map { phone -> Bool in
            return phone.count == 10 || phone.count == 9
        }
    }
    
    var isPasswordValid: Observable<Bool> {
        return passwordBehavior.asObservable().map { password -> Bool in
            return password.count >= 6
        }
    }
    
    var isConfirmPasswordValid: Observable<Bool> {
        return confirmPasswordBehavior.asObservable().map { cPassword -> Bool in
            return cPassword.count >= 6
        }
    }
    
    var isReferralCodeValid: Observable<Bool> {
        return referralCodeBehavior.asObservable().map { code -> Bool in
            return code.count >= 4
        }
    }
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(isFirstNameValid, isLastNameValid, isEmailValid, isPhoneValid, isPasswordValid, isConfirmPasswordValid, isReferralCodeValid).map { isFirstNameValid, isLastNameValid, isEmailValid, isPhoneValid, isPasswordValid, isConfirmPasswordValid, isReferralCodeValid in
            return isFirstNameValid && isLastNameValid && isEmailValid && isPhoneValid && isPasswordValid && isConfirmPasswordValid && isReferralCodeValid && self.passwordBehavior.value == self.confirmPasswordBehavior.value
        }.startWith(false)
    }
    
    func register() {
        loadingBehavior.accept(true)
        ApiProvider.rx.request(.CustomerSignUp(action: "CustomerSignUp", first_name: firstNameBehavior.value, last_name: lastNameBehavior.value, username: emailAddressBehavior.value, phone_number: phoneNumberBehavior.value, user_country_code: countryCodeBehavior.value, password: passwordBehavior.value, referral_code: referralCodeBehavior.value))
            .mapObject(LoginModel.self)
            .subscribe { (value) in
                
                self.loadingBehavior.accept(false)
                if value.result?.success == 0 {
                    self.errorMessageSubject.onNext(value.result?.message ?? "")
                } else {
                    self.errorMessageSubject.onNext("customerId: \(value.result?.customerId ?? 0)")
                }
                self.registerModelSubject.onNext(value)
            } onError: { (error) in
                self.loadingBehavior.accept(false)
                self.errorMessageSubject.onNext(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}
