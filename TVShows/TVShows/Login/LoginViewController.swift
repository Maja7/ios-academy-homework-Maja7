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
    private var currentUser: User?
    private var currentLoggedUser: LoginData?
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "splash-logo")!, iconInitialSize: CGSize(width: 129, height: 148), backgroundColor: .white)
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateSplashScreen()
        configureUI()
        if (isUserSelected()){
            rememberMeButton.isSelected.toggle();
            emailField.text = UserDefaults.standard.string(forKey: "Email")
            passwordField.text = UserDefaults.standard.string(forKey: "Password")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func loginButton(_ sender: Any) {
        guard
            let username = emailField.text,
            let password = passwordField.text,
            !username.isEmpty,
            !password.isEmpty
            else {
                showAlert(title: "Login error",  message: "Please enter username and password")
                return
        }
        (userHasStoredCredentials()) ? _loginUserWith(email: UserDefaults.standard.string(forKey: "Email")!, password: UserDefaults.standard.string(forKey: "Password")!) : _loginUserWith(email: emailField.text!, password: passwordField.text!)
    }
    
    @IBAction func registerButton(_ sender: Any){
        guard
            let username = emailField.text,
            let password = passwordField.text,
            !username.isEmpty,
            !password.isEmpty
            else {
                showAlert(title: "Registration error",  message: "Please enter username and password")
                return
        }
        _alamofireCodableRegisterUserWith(email: emailField.text!, password: passwordField.text!)
    }
    
    @IBAction func rememberMeButton(_ sender: Any) {
        if rememberMeButton.isSelected {
            clearInputFields()
            rememberMeButton.isSelected.toggle()
        }else{
            UserDefaults.standard.set(true, forKey: "RememberMeIsSelected")
            UserDefaults.standard.set(emailField.text, forKey: "Email")
            UserDefaults.standard.set(passwordField.text, forKey: "Password")
            rememberMeButton.isSelected.toggle()
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
            ) as! HomeViewController
        
        homeViewController.loggedUser = currentLoggedUser!.token
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
    
    private func showAlert(title: String,  message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {
        }
    }
    
    private func userHasStoredCredentials() -> Bool{
        guard
            let emailCredentials = UserDefaults.standard.string(forKey: "Email"),
            let passwordCredentials = UserDefaults.standard.string(forKey: "Password"),
            !emailCredentials.isEmpty,
            !passwordCredentials.isEmpty
            else {
                return false
        }
        return true
    }
    
    private func isUserSelected() -> Bool{
        if UserDefaults.standard.bool(forKey: "RememberMeIsSelected") { return true} else {return false}
    }
    
    private func clearInputFields(){
        emailField.text = ""
        passwordField.text = ""
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<LoginData>) in
                switch response.result {
                case .success(let response):
                    //print( "Success: \(response)")
                    guard let self = self else { return }
                    self.currentLoggedUser = response
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.goToHomePage()
                case .failure(let error):
                    print("API failure: \(error)")
                    self!.showAlert(title: "API Failure", message:"API failure during login: \(error)")
                    MBProgressHUD.hide(for: self!.view, animated: true)
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<User>) in
                switch response.result {
                case .success(let user):
                    //print("Success: \(user)")
                    guard let self = self else { return }
                    self.currentUser = user
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self._loginUserWith(email: email, password: password)
                case .failure(let error):
                    print("API failure: \(error)")
                    self!.showAlert(title: "API Failure", message:"API failure during registration: \(error)")
                    MBProgressHUD.hide(for: self!.view, animated: true)
                }
        }
    }
    
}
