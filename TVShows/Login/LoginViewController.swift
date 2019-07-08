//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 08/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnClick.layer.cornerRadius = 20
        btnClick.clipsToBounds = true
    }
    var NumberOfTaps = 0
    @IBAction func Mybutton(_ sender: Any) {
        
    
        
//    print("Any string you like!")
        NumberOfTaps += 1
        printOnLabel.text = String(NumberOfTaps)
    }
    
    @IBOutlet weak var btnClick: UIButton!
    @IBOutlet weak var printOnLabel: UILabel!
}
