//
//  RegisterVC.swift
//  AuthTask
//
//  Created by FAB LAB on 01/09/2021.
//

import UIKit
import RxSwift
import RxCocoa
import ARSLineProgress
import SKCountryPicker

class RegisterVC: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!

    @IBOutlet weak var viewCountryPicker: UIView!
    @IBOutlet weak var imgCountryLogo: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtReferralCode: UITextField!
    
    @IBOutlet weak var btnJoinUs: UIButton!
        
    let viewModel = RegisterViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCountryPicker.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectCountryAction)))
        
        bindViews()
        subscribeToErrorMessage()
        subscribeToJoinUsButton()
        subscribeToApiResponse()
    }
    
    @objc func selectCountryAction(sender : UITapGestureRecognizer) {
        // Invoke below static method to present country picker without section control
        // CountryPickerController.presentController(on: self) { ... }

        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: SKCountryPicker.Country) in
            
            self?.lblCountryCode.text = country.dialingCode
            self?.imgCountryLogo.image = country.flag
            self?.viewModel.countryCodeBehavior.accept(country.dialingCode ?? "")
        }
        
        // can customize the countryPicker here e.g font and color
        countryController.detailColor = UIColor.red
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterVC {
    
    func bindViews() {
        // textFields
        txtFirstName.rx.text.orEmpty.bind(to: viewModel.firstNameBehavior).disposed(by: disposeBag)
        txtLastName.rx.text.orEmpty.bind(to: viewModel.lastNameBehavior).disposed(by: disposeBag)
        txtEmailAddress.rx.text.orEmpty.bind(to: viewModel.emailAddressBehavior).disposed(by: disposeBag)
        txtPhoneNumber.rx.text.orEmpty.bind(to: viewModel.phoneNumberBehavior).disposed(by: disposeBag)
        txtPassword.rx.text.orEmpty.bind(to: viewModel.passwordBehavior).disposed(by: disposeBag)
        txtConfirmPassword.rx.text.orEmpty.bind(to: viewModel.confirmPasswordBehavior).disposed(by: disposeBag)
        txtReferralCode.rx.text.orEmpty.bind(to: viewModel.referralCodeBehavior).disposed(by: disposeBag)
        // loginButton
        viewModel.isValid().bind(to: btnJoinUs.rx.isEnabled).disposed(by: disposeBag)
        viewModel.isValid().map { $0 ? 1 : 0.3 }.bind(to: btnJoinUs.rx.alpha).disposed(by: disposeBag)
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
    
    func subscribeToJoinUsButton() {
        btnJoinUs.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.register()
            }.disposed(by: disposeBag)
    }
    
    func subscribeToApiResponse() {
            viewModel.registerModelObservable.subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        }
}
