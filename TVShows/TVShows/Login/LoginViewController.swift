//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 08/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import RevealingSplashView
import MBProgressHUD
import Alamofire
import CodableAlamofire

final class LoginViewController: UIViewController {

     // MARK: - Outlets
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    // MARK: - Properties

    var rememberMe: Bool = false
    var emailInput: String = ""
    var passwordInput: String = ""
    private var currentUser: User = User(email: "", type: "", id: "")
    private var currentLoggedUser: LoginData = LoginData(token: "")
    let revealingSplashView = RevealingSplashView.init(iconImage: UIImage(named: "splash-logo")!, iconInitialSize: CGSize(width: 129, height: 148), backgroundColor: .white)
    
     // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateSplashScreen()
        configureUI()
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HomeViewController
        {
            vc.LoginUser = currentLoggedUser
        }
    }
    
     // MARK: - Actions
    
    @IBAction func loginButton(_ sender: Any) {
        _loginUserWith(email: emailInput, password: passwordInput)
        
    }
       
    
    @IBAction func registerButton(_ sender: Any){
        getUserInputs()
        if(emailInput.isEmpty && passwordInput.isEmpty){
            showAlert(failureError: "Email and password are empty!")
        }else{
            _alamofireCodableRegisterUserWith(email: emailInput, password: passwordInput)
            _loginUserWith(email: emailInput, password: passwordInput)
        }
    }
    
    @IBAction func rememberMeButton(_ sender: Any) {
        if !rememberMe {
            saveFilledInputFields()
            rememberMeButton.setImage(UIImage (named: "ic-checkbox-filled"), for: .normal)
            rememberMe = true
        }else{
            clearInputFields()
            rememberMeButton.setImage(UIImage (named: "ic-checkbox-empty"), for: .normal)
            rememberMe = false
        }
    }
    
     // MARK: - Private functions
    private func configureUI() {
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
    }
    
    private func animateSplashScreen(){
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = .twitter
        revealingSplashView.startAnimation()
    }
    
    private func getUserInputs(){
        emailInput = emailField.text!
        passwordInput = passwordField.text!
    }
    
    private func clearInputFields(){
        emailField.text = ""
        passwordField.text = ""
    }
    private func saveFilledInputFields(){
        emailField.text = currentUser.email
        passwordField.text = passwordInput
    }
    
    private func showProgressHud(){
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
    }
    
    private func goToHomePage(){
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Home", bundle: bundle)
        let homeViewController = storyboard.instantiateViewController(
            withIdentifier: "HomeViewController"
        )
        
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    private func showAlert(failureError:String){
        let alertController = UIAlertController(title: "Alert", message: failureError, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
    }
    
}

    // MARK: - Login + automatic JSON parsing
    
    private extension LoginViewController {
        
        func _loginUserWith(email: String, password: String) {
            showProgressHud()
            let parameters: [String: String] = [
                "email": email,
                "password": password
            ]
            Alamofire
                .request(
                    "https://api.infinum.academy/api/users/sessions",
                    method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default)
                .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<LoginData>) in
                switch response.result {
                    case .success(let response):
                        print( "Success: \(response)")
                        self.currentLoggedUser = response
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.goToHomePage()
                    case .failure(let error):
                        print("API failure: \(error)")
                        self.showAlert(failureError: "API failure: \(error)")
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
            }
        }
    
}
 
// MARK: - Register + automatic JSON parsing

private extension LoginViewController {
    
    func _alamofireCodableRegisterUserWith(email: String, password: String) {
        showProgressHud()
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/users",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<User>) in
                switch response.result {
                case .success(let user):
                    print("Success: \(user)")
                    self.currentUser = user
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .failure(let error):
                    print("API failure: \(error)")
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
        }
    }
    
}
