//
//  ABCDEFViewController.swift
//  silde menu
//
//  Created by Sakkaphong on 3/26/18.
//  Copyright © 2018 Sakkaphong. All rights reserved.
//

import UIKit

class ABCDEFViewController: UIViewController {

    override func viewDidDisappear(_ animated: Bool) {
        MainNavigation.BackButton = false
    }
}
