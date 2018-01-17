//
//  MenuBarViewController.swift
//  silde menu
//
//  Created by Sakkaphong on 1/16/18.
//  Copyright © 2018 Sakkaphong. All rights reserved.
//

import UIKit

protocol MenuBarDelegate {
    func SetupMenuBar(Controller: UIViewController , navigation : UINavigationBar?)
    func Dismiss()
}

class MenuBarViewController: UIViewController {

    @IBOutlet weak var MenuBackgroundView: UIView!
    @IBOutlet weak var BackgroundView: UIView!

    @IBOutlet weak var MyTableView: UITableView!
    
    static let Blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))

    static var CurrentNavigation : UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
 
        self.SetupTableView()
        self.RegisterLocalNotifcation()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        self.ShowMenuBar()
    }
    
    private func RegisterLocalNotifcation() {
        
        self.BackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuBarViewController.Dismiss)))
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
    }

    private func SetupShadowBackgroundView() {
        
        self.MenuBackgroundView.layer.shadowColor = UIColor.black.cgColor
        self.MenuBackgroundView.layer.shadowOpacity = 0.5
        self.MenuBackgroundView.layer.shadowOffset = CGSize(width: 3, height: 0)
        self.MenuBackgroundView.layer.shadowRadius = 3
        self.MenuBackgroundView.layer.masksToBounds = false
    }
    
    private func ShowMenuBar() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.MenuBackgroundView.transform = CGAffineTransform( translationX: ScreenSize.SCREEN_WIDTH / 2 , y: 0.0 )
        }) { (done) in
            self.SetupShadowBackgroundView()
        }
    }

    private func MoveMenuBackToCenter() {

        UIView.animate(withDuration: 0.5, animations: {
            self.MenuBackgroundView.frame.origin.x = 0
            self.MoveNavigationBar(X: self.MenuBackgroundView.frame.maxX)
        })
    }
    
    private func MoveMenu(X : CGFloat) {
 
        if self.MenuBackgroundView.frame.origin.x > -(self.MenuBackgroundView.frame.size.width) && self.MenuBackgroundView.frame.origin.x < -1 {
            self.MenuBackgroundView.center = CGPoint(x: self.MenuBackgroundView.center.x + X , y: self.MenuBackgroundView.center.y)
        } else {
            if self.MenuBackgroundView.frame.origin.x > -(self.MenuBackgroundView.frame.size.width) {
                self.MenuBackgroundView.center = CGPoint(x: self.MenuBackgroundView.center.x - 1 , y: self.MenuBackgroundView.center.y)
            }
            else {
                self.Dismiss()
            }
        }
        
        self.MoveNavigationBar(X: self.MenuBackgroundView.frame.maxX)
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {

        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {

            self.MoveMenu(X: gestureRecognizer.translation(in: self.view).x)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if gestureRecognizer.state == .ended {
            
            guard self.MenuBackgroundView.frame.origin.x < -(self.MenuBackgroundView.frame.size.width / 3) else {
                self.MoveMenuBackToCenter()
                return
            }
            self.Dismiss()
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }

    private func SetupNavigationBar() {
        UIView.animate(withDuration: 0.5) {
            MenuBarViewController.CurrentNavigation.transform = CGAffineTransform( translationX: ScreenSize.SCREEN_WIDTH / 2 , y: 0.0 )
        }
    }
    
    private func SetupBlur(view : UIView) {
        MenuBarViewController.Blur.frame = CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT)
        MenuBarViewController.Blur.alpha = 0.7
        MenuBarViewController.Blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(MenuBarViewController.Blur)
    }
    
    private func MoveNavigationBar(X : CGFloat) {
        MenuBarViewController.CurrentNavigation.transform = CGAffineTransform( translationX: X , y: 0.0 )
    }
}

// ---------------------------------- TableView ----------------------------------

extension MenuBarViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MenuBarViewController : UITableViewDataSource {
    
    private func SetupTableView() {
        self.MyTableView.delegate = self
        self.MyTableView.dataSource = self
        self.MyTableView.tableFooterView = UIView()
        self.MyTableView.register(UINib(nibName: "MenuBarTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MenuBarTableViewCell else { return UITableViewCell() }
        
        cell.TextLabel.text = "eiei \(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (ScreenSize.SCREEN_HEIGHT / 667) * 50
    }
}

// ---------------------------------- Delegate ----------------------------------

extension MenuBarViewController : MenuBarDelegate {

    func SetupMenuBar(Controller: UIViewController , navigation : UINavigationBar?) {
        guard let nav = navigation else { return }
        
        let MenuController = MenuBarViewController(nibName: "MenuBarViewController", bundle: nil)
        MenuController.modalPresentationStyle = .overCurrentContext
        Controller.present(MenuController, animated: false) {
            MenuBarViewController.CurrentNavigation = nav
            self.SetupBlur(view : Controller.view)
            self.SetupNavigationBar()
        }
    }
    
    @objc func Dismiss() {
        
        self.view.gestureRecognizers?.removeAll()
        NotificationCenter.default.removeObserver(self)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.MenuBackgroundView.transform = CGAffineTransform.identity
            MenuBarViewController.CurrentNavigation.transform = CGAffineTransform.identity
            MenuBarViewController.Blur.removeFromSuperview()
        }) { (done) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
