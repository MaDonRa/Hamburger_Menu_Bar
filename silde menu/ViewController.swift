//
//  ViewController.swift
//  silde menu
//
//  Created by Sakkaphong on 1/16/18.
//  Copyright © 2018 Sakkaphong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let Menu : MenuBarDelegate = MenuBarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.red
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.Show)))
        
    }

    @objc func Show() {

        self.Menu.SetupMenuBar(Controller: self, navigation: self.navigationController?.navigationBar)
 
    }

}

