//
//  MainNavigation.swift
//  silde menu
//
//  Created by Sakkaphong on 3/19/18.
//  Copyright © 2018 Sakkaphong. All rights reserved.
//

import UIKit

class MainNavigation: UINavigationController , UINavigationControllerDelegate {

    let Menu : MenuBarDelegate = MenuBarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;
    }

    @objc func MenuBar() {
        
        self.Menu.SetupMenuBar(Controller: self, navigation: self)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let LeftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        LeftButton.contentMode = .scaleAspectFit
        LeftButton.addTarget(self, action: #selector(MainNavigation.MenuBar), for: .touchUpInside)
        
        let MenuBarImage:UIImageView = UIImageView()
        MenuBarImage.frame = LeftButton.frame
        MenuBarImage.image = #imageLiteral(resourceName: "Icon_Menu")
        LeftButton.addSubview(MenuBarImage)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:LeftButton);
    }
}
