//
//  MenuBarViewController.swift
//  silde menu
//
//  Created by Sakkaphong on 1/16/18.
//  Copyright © 2018 Sakkaphong. All rights reserved.
//

import UIKit

protocol MenuBarDelegate {
    func SetupMenuBar(Controller: UIViewController , navigation : UINavigationController?)
    func Dismiss()
}

internal enum SelectRow:Int {
    
    case News , Building , ServiceRequest , Product , Alert , Profile , LogOut
    
    static var Count: Int { return SelectRow.LogOut.hashValue + 1}

    var Text : String {
        switch self {
        case .News :
            return "News"
        case .Building :
            return "Building"
        case .ServiceRequest:
            return "Service Request"
        case .Product:
            return "Product"
        case .Alert:
            return "Alert"
        case .Profile:
            return "My Profile"
        case .LogOut:
            return "Log Out"
        }
    }
    
    static var CurrentPage:Int {
        get {
            return UserDefaults.standard.integer(forKey: "CurrentPage")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CurrentPage")
        }
    }
}

class MenuBarViewController: UIViewController {
    
    @IBOutlet weak var MenuBackgroundView: UIView!
    @IBOutlet weak var BackgroundView: UIView!
    
    @IBOutlet weak var MyTableView: UITableView!
    
    static let Blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    
    static var CurrentNavigationController : UINavigationController!
    static var CurrentNavigation : UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        self.SetupTableView()
        self.RegisterLocalNotifcation()
        self.SetupShadowBackgroundView()
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
        
        UIView.animate(withDuration: 0.5) {
            self.MenuBackgroundView.transform = CGAffineTransform( translationX: ScreenSize.SCREEN_WIDTH / 1.5 , y: 0.0 )
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
            
            guard self.MenuBackgroundView.frame.origin.x < -(self.MenuBackgroundView.frame.size.width / 5) else {
                self.MoveMenuBackToCenter()
                return
            }
            self.Dismiss()
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    private func SetupNavigationBar() {
        UIView.animate(withDuration: 0.5) {
            MenuBarViewController.CurrentNavigation.transform = CGAffineTransform( translationX: ScreenSize.SCREEN_WIDTH / 1.5 , y: 0.0 )
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
    
    private func PushViewController(Viewcontroller : String) {
        Dismiss()
        MenuBarViewController.CurrentNavigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Viewcontroller), animated: true)
    }
}

// ---------------------------------- Delegate ----------------------------------

extension MenuBarViewController : MenuBarDelegate {
    
    func SetupMenuBar(Controller: UIViewController , navigation : UINavigationController?) {
        MenuBarViewController.CurrentNavigationController = navigation
        guard let nav = navigation?.navigationBar else { return }
        
        let MenuController = MenuBarViewController(nibName: "MenuBarViewController", bundle: nil)
        MenuController.modalPresentationStyle = .overCurrentContext
        Controller.present(MenuController, animated: false) {
            MenuBarViewController.CurrentNavigation = nav
            self.SetupBlur(view : Controller.view)
            self.SetupNavigationBar()
            UIApplication.shared.statusBarStyle = .lightContent
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
            UIApplication.shared.statusBarStyle = .default
            self.dismiss(animated: false, completion: nil)
        }
    }
}

// ---------------------------------- TableView ----------------------------------

extension MenuBarViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.Dismiss()
        
        guard SelectRow.CurrentPage != indexPath.row , let row = SelectRow(rawValue: indexPath.row) else { return }
        
        switch row {
        case .News:
            MenuBarViewController.CurrentNavigationController.popToRootViewController(animated: true)
        case .Building:
            self.PushViewController(Viewcontroller: "ABCDEFG")
        case .ServiceRequest:
            self.PushViewController(Viewcontroller: "ABCDEFG")
        case .Product:
            self.PushViewController(Viewcontroller: "ABCDEFG")
        case .Alert:
            self.PushViewController(Viewcontroller: "ABCDEFG")
        case .Profile:
            self.PushViewController(Viewcontroller: "ABCDEFG")
        case .LogOut:
            self.PushViewController(Viewcontroller: "ABCDEFG")
        }
        
        SelectRow.CurrentPage = row.hashValue
        
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
        return SelectRow.Count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MenuBarTableViewCell , let row = SelectRow(rawValue: indexPath.row) else { return UITableViewCell() }
        
        cell.TextLabel.text = row.Text
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (ScreenSize.SCREEN_HEIGHT / 667) * 50
    }
}


