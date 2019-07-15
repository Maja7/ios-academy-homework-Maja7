//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 08/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

     // MARK: - Outlets
    
    @IBOutlet private weak var increaseNumberOfTapsButton: UIButton!
    @IBOutlet private weak var printOnLabel: UILabel!


    // MARK: - Properties
    
    private var numberOfTaps: Int = 0
    
     // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}
