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

public enum HeaderRow : Int {
    case Staff , Manager , General
    
    static var Count: Int { return HeaderRow.General.hashValue + 1 }
    
    var Text : String {
        switch self {
        case .Staff:
            return "พนักงาน"
        case .Manager:
            return "ระบบจัดการพนักงาน"
        case .General:
            return "ทั่วไป"
        }
    }
    
    var Status : Bool {
        switch self {
        case .Staff :
            return StaffRow(rawValue: 0)?.Status ?? false || StaffRow(rawValue: 1)?.Status ?? false || StaffRow(rawValue: 2)?.Status ?? false
        case .Manager :
            return ManagerRow(rawValue: 0)?.Status ?? false || ManagerRow(rawValue: 1)?.Status ?? false
        case .General :
            return GeneralRow(rawValue: 0)?.Status ?? false || GeneralRow(rawValue: 1)?.Status ?? false || GeneralRow(rawValue: 2)?.Status ?? false || GeneralRow(rawValue: 3)?.Status ?? false
        }
    }
}

public enum StaffRow:Int {
    
    case ClockInClockOut , TimeAttendance , Appointment
    
    static var Count: Int { return StaffRow.Appointment.hashValue + 1 }
    
    var Image : UIImage {
        switch self {
        case .ClockInClockOut :
            return #imageLiteral(resourceName: "Photo_Table_Clock")
        case .TimeAttendance :
            return #imageLiteral(resourceName: "Photo_Table_TimeAttendance")
        case .Appointment :
            return #imageLiteral(resourceName: "Photo_Table_Appointment")
        }
    }
    
    var Text : String {
        switch self {
        case .ClockInClockOut :
            return "เข้า - ออก งาน"
        case .TimeAttendance :
            return "ประวัติการเข้างาน"
        case .Appointment :
            return "นัดหมาย"
        }
    }
    
    var Status : Bool {
        switch self {
        case .ClockInClockOut :
            return true
        case .TimeAttendance :
            return true
        case .Appointment :
            return true
        }
    }
}

public enum ManagerRow:Int {
    
    case Request , ManageTeam
    
    static var Count: Int { return ManagerRow.ManageTeam.hashValue + 1 }
    
    var Image : UIImage {
        switch self {
        case .Request :
            return #imageLiteral(resourceName: "Photo_Table_Alert")
        case .ManageTeam :
            return #imageLiteral(resourceName: "Photo_Table_ManageTeam")
        }
    }
    
    var Text : String {
        switch self {
        case .Request :
            return "คำร้องขอ"
        case .ManageTeam :
            return "แผนก"
        }
    }
    
    var Status : Bool {
        switch self {
        case .Request :
            return true
        case .ManageTeam :
            return true
        }
    }
}

public enum GeneralRow:Int {
    
    case Alert , RoomBooking , Staff , Setting
    
    static var Count: Int { return GeneralRow.Setting.hashValue + 1 }
    
    var Image : UIImage {
        switch self {
        case .Alert:
            return #imageLiteral(resourceName: "Photo_Table_Alert")
        case .RoomBooking:
            return #imageLiteral(resourceName: "Photo_Table_RoomBooking")
        case .Staff:
            return #imageLiteral(resourceName: "Photo_Table_Staff")
        case .Setting:
            return #imageLiteral(resourceName: "Photo_Table_Setting")
        }
    }
    
    var Text : String {
        switch self {
        case .Alert:
            return "แจ้งเตือน"
        case .RoomBooking:
            return "จองห้องประชุม"
        case .Staff:
            return "ข้อมูลพนักงานทั้งหมด"
        case .Setting:
            return "ตั้งค่า"
        }
    }
    
    var Status : Bool {
        switch self {
        case .Alert :
            return true
        case .RoomBooking :
            return true
        case .Staff :
            return true
        case .Setting :
            return true
        }
    }
}

class MenuBarViewController: UIViewController {
    
    @IBOutlet weak var UserBackgroundView: UIView!
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UserEmailLabel: UILabel!
    
    @IBOutlet weak var MenuBackgroundView: UIView!
    @IBOutlet weak var BackgroundView: UIView!

    @IBOutlet weak var MyTableView: UITableView!

    static let Blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))

    static var CurrentNavigationController : UINavigationController!
    static var CurrentNavigation : UINavigationBar!
    
    static var CurrentPage : [Int] = [HeaderRow.Staff.hashValue,StaffRow.ClockInClockOut.hashValue]
    
    private let Font = ResizeFont()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
 
        self.LocalProfile()
        self.SetupUICircle()
        self.SetupTableView()
        self.RegisterLocalNotifcation()
        self.SetupShadowBackgroundView()
    }
    
    override func viewDidLayoutSubviews() {
        self.SetupFontSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.ShowMenuBar()
    }

    private func RegisterLocalNotifcation() {

        self.BackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuBarViewController.Dismiss)))
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
    }
    
    private func SetupFontSize() {
        Font.LabelFontSizeArray([UserNameLabel,
                                 UserEmailLabel])
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
 
        if self.MenuBackgroundView.frame.origin.x > -(self.MenuBackgroundView.frame.size.width) &&
            self.MenuBackgroundView.frame.origin.x < -1 {
            self.MenuBackgroundView.center = CGPoint(x: self.MenuBackgroundView.center.x + X , y: self.MenuBackgroundView.center.y)
        } else {
            if self.MenuBackgroundView.frame.origin.x > -(self.MenuBackgroundView.frame.size.width) {
                self.MenuBackgroundView.center = CGPoint(x: self.MenuBackgroundView.center.x - 1 , y: self.MenuBackgroundView.center.y)
            } else {
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
        MenuBarViewController.CurrentNavigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Viewcontroller), animated: true)
    }
}

// ---------------------------------- Custom Function ----------------------------------

extension MenuBarViewController {
    
    private func LocalProfile() {
        self.UserNameLabel.text = "User : Guest"
        self.UserEmailLabel.text = "test_123@hotmail.com"
        self.UserImageView.image = #imageLiteral(resourceName: "Photo_RoomBooking_People")
    }
    
    private func SetupUICircle() {
        self.UserImageView.layer.masksToBounds = true
        self.UserImageView.layer.cornerRadius = (ScreenSize.SCREEN_HEIGHT/8) / 2.0
    }
    
    @objc private func UpdateProfile() {
        self.Dismiss()
        self.PushViewController(Viewcontroller: "ProfileViewController")
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
            MenuBarViewController.CurrentNavigation.transform = CGAffineTransform.identity
            UIApplication.shared.statusBarStyle = .default
            self.dismiss(animated: false, completion: nil)
        }
    }
}

// ---------------------------------- Alert ----------------------------------

extension MenuBarViewController {
    
    private func AlertServer(status : Int , error : String) {
        let alert = UIAlertController(title: "ผิดพลาด", message: "Error \(status) : \(error)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// ---------------------------------- TableView ----------------------------------

extension MenuBarViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.Dismiss()
        
        guard MenuBarViewController.CurrentPage != [indexPath.section,indexPath.row] , let Header = HeaderRow(rawValue: indexPath.section) else { return }
        
        switch Header {
        case .Staff:
            guard let row  = StaffRow(rawValue: indexPath.row) else { return }
            switch row {
                case .ClockInClockOut:
                MenuBarViewController.CurrentNavigationController.popToRootViewController(animated: true)
                case .TimeAttendance:
                PushViewController(Viewcontroller: "ABCDEFG")
                case .Appointment:
                PushViewController(Viewcontroller: "ABCDEFG")
            }
        case .Manager:
            guard let row  = ManagerRow(rawValue: indexPath.row) else { return }
            switch row {
            case .Request:
                MainNavigation.BackButton = false
                PushViewController(Viewcontroller: "ABCDEFG")
            case .ManageTeam:
                MainNavigation.BackButton = false
                PushViewController(Viewcontroller: "ABCDEFG")
            }
        case .General:
            guard let row  = GeneralRow(rawValue: indexPath.row) else { return }
            switch row {
            case .Alert:
                PushViewController(Viewcontroller: "ABCDEFG")
            case .RoomBooking:
                PushViewController(Viewcontroller: "ABCDEFG")
            case .Staff:
                PushViewController(Viewcontroller: "ABCDEFG")
            case .Setting:
                PushViewController(Viewcontroller: "ABCDEFG")
            }
        }
        
        MenuBarViewController.CurrentPage = [indexPath.section,indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 , let Header = HeaderRow(rawValue: section) else { return 0.1 }
        return Header.Status ? ScreenSize.SCREEN_HEIGHT/50 : 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard section != 0 , let Header = HeaderRow(rawValue: section) , Header.Status else { return nil }
        
        let BackgroundView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH/1.5, height: ScreenSize.SCREEN_HEIGHT/50))
        BackgroundView.backgroundColor = UIColor.clear
        
        let Line:UIView = UIView(frame: CGRect(x: 30, y: (BackgroundView.frame.size.height/2), width: BackgroundView.frame.size.width-60, height: 1))
        Line.backgroundColor = UIColor.gray
        BackgroundView.addSubview(Line)
        
        return BackgroundView
    }
}

extension MenuBarViewController : UITableViewDataSource {
    
    private func SetupTableView() {
        self.MyTableView.delegate = self
        self.MyTableView.dataSource = self
        self.MyTableView.separatorStyle = .none
        self.MyTableView.tableFooterView = UIView()
        self.MyTableView.register(UINib(nibName: "MenuBarTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HeaderRow.Count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let Header = HeaderRow(rawValue: section) else { return 0 }
        
        switch Header {
        case .Staff:
            return StaffRow.Count
        case .Manager:
            return ManagerRow.Count
        case .General:
            return GeneralRow.Count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MenuBarTableViewCell , let Header = HeaderRow(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch Header {
        case .Staff:
            guard let row = StaffRow(rawValue: indexPath.row) , row.Status else { return cell }
            cell.TextLabel.isHidden = false
            cell.IconImageView.isHidden = false
            cell.IconImageView.image = row.Image
            cell.TextLabel.text = row.Text
            
            if row.hashValue == StaffRow.Appointment.hashValue {
                cell.BackgroundBadgeView.isHidden = false
                cell.BadgeLabel.isHidden = false
                cell.BadgeLabel.text = "3"
            } else {
                cell.BackgroundBadgeView.isHidden = true
                cell.BadgeLabel.isHidden = true
            }
        case .Manager:
            guard let row = ManagerRow(rawValue: indexPath.row) , row.Status else { return cell }
            cell.TextLabel.isHidden = false
            cell.IconImageView.isHidden = false
            cell.IconImageView.image = row.Image
            cell.TextLabel.text = row.Text
            
            if row.hashValue == ManagerRow.Request.hashValue {
                cell.BackgroundBadgeView.isHidden = false
                cell.BadgeLabel.isHidden = false
                cell.BadgeLabel.text = "2"
            } else {
                cell.BackgroundBadgeView.isHidden = true
                cell.BadgeLabel.isHidden = true
            }
        case .General:
            guard let row = GeneralRow(rawValue: indexPath.row) , row.Status else { return cell }
            cell.TextLabel.isHidden = false
            cell.IconImageView.isHidden = false
            cell.IconImageView.image = row.Image
            cell.TextLabel.text = row.Text
        }

        guard MenuBarViewController.CurrentPage == [indexPath.section,indexPath.row] else {
            cell.contentView.backgroundColor = UIColor.groupTableViewBackground
            return cell
        }
   
        cell.contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let Header = HeaderRow(rawValue: indexPath.section) else { return 0 }
        switch Header {
        case .Staff:
            guard let row = StaffRow(rawValue: indexPath.row) , row.Status else { return 0 }
            return (ScreenSize.SCREEN_HEIGHT / 667) * 50
        case .Manager:
            guard let row = ManagerRow(rawValue: indexPath.row) , row.Status else { return 0 }
            return (ScreenSize.SCREEN_HEIGHT / 667) * 50
        case .General:
            guard let row = GeneralRow(rawValue: indexPath.row) , row.Status else { return 0 }
            return (ScreenSize.SCREEN_HEIGHT / 667) * 50
        }
    }
}

