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
    
    @IBOutlet private weak var increaseNumberOfTapsButton: UIButton!
    @IBOutlet private weak var printOnLabel: UILabel!


    // MARK: - Properties
    
    private var numberOfTaps: Int = 0
    let revealingSplashView = RevealingSplashView.init(iconImage: UIImage(named: "splash-logo")!, iconInitialSize: CGSize(width: 129, height: 148), backgroundColor: .white)
    
     // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateSplashScreen()
        configureUI()
    }
    
     // MARK: - Actions
    
    @IBAction func Mybutton(_ sender: Any) {

    //  print("Any string you like!")
        numberOfTaps += 1
        printOnLabel.text = String(numberOfTaps)
    }
    
     // MARK: - Private functions
    private func configureUI() {
        increaseNumberOfTapsButton.layer.cornerRadius = 20
        increaseNumberOfTapsButton.clipsToBounds = true
    }
    
    private func animateSplashScreen(){
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = .twitter
        revealingSplashView.startAnimation()
    }
    
}
