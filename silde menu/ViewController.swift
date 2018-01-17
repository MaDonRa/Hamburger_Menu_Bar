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

        self.SetupButtonOnNavigationBar()
    }
    
    private func SetupButtonOnNavigationBar() {
        
        let LeftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        LeftButton.contentMode = .scaleAspectFit
        LeftButton.addTarget(self, action: #selector(ViewController.MenuBar), for: .touchUpInside)
        
        let MenuBarImage:UIImageView = UIImageView()
        MenuBarImage.frame = LeftButton.frame
        MenuBarImage.image = #imageLiteral(resourceName: "Icon_Menu")
        LeftButton.addSubview(MenuBarImage)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:LeftButton)
    }

    @objc func MenuBar() {

        self.Menu.SetupMenuBar(Controller: self, navigation: self.navigationController)
 
    }

}

