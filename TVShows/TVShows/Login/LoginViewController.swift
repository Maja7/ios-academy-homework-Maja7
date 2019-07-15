//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 08/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import RevealingSplashView

final class LoginViewController: UIViewController {

     // MARK: - Outlets
    
    @IBOutlet private weak var loginButton: UIButton!
    

    @IBOutlet private weak var rememberMeButton: UIButton!
    

    // MARK: - Properties
    
    private var numberOfTaps: Int = 0
    var rememberMe: Bool = false
    let revealingSplashView = RevealingSplashView.init(iconImage: UIImage(named: "splash-logo")!, iconInitialSize: CGSize(width: 129, height: 148), backgroundColor: .white)
    
     // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateSplashScreen()
        configureUI()
    }
    
     // MARK: - Actions
    
    @IBAction func LoginButton(_ sender: Any) {
        //  print("Any string you like!")
        numberOfTaps += 1
        }
    
    @IBAction func rememberMeButton(_ sender: Any) {
        if !rememberMe {
             rememberMeButton.setImage(UIImage (named: "ic-checkbox-filled"), for: .normal)
            rememberMe = true
        }else{
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
    
}
