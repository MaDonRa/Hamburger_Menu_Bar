//
//  ViewController.swift
//  silde menu
//
//  Created by Sakkaphong on 1/16/18.
//  Copyright © 2018 Sakkaphong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        MenuBarViewController.CurrentPage = [HeaderRow.Staff.hashValue,StaffRow.ClockInClockOut.hashValue]
    }
}

