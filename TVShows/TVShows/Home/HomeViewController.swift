//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum on 16/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var LogedUser: UILabel!
    var LoginUser: LoginData = LoginData(token: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LogedUser.text = LoginUser.token
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

   
    
    

}
