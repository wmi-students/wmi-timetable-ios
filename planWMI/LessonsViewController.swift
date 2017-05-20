//
//  LessonsViewController.swift
//  planWMI
//
//  Created by user115090 on 1/22/17.
//  Copyright © 2017 wojek. All rights reserved.
//

import UIKit
import Alamofire
import ChameleonFramework
import YXJKxMenu
class LessonsViewController: UIViewController {
    let gradientLayer = CAGradientLayer()
    let gradientLayer1 = CAGradientLayer()
    var kierunki : [String] = []
    @IBOutlet var menu: UIBarButtonItem!
    var schedules : [Schedule] = []
    var ScreenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    @IBAction func dd(_ sender: Any) {
        var menuArray: [YXJKxMenuItem] = []
        
        for i in 0..<4 {
            let menuItem = YXJKxMenuItem("选项\(i)", image: UIImage(named: "\(i)"), target: self, action: nil)
            menuArray.append(menuItem!)
        }
        
        YXJKxMenu.setTitleFont(UIFont.systemFont(ofSize: 14))
        
        let option = OptionalConfiguration(
            arrowSize: 10,
            marginXSpacing: 10,
            marginYSpacing: 10,
            intervalSpacing: 10,
            menuCornerRadius: 3,
            maskToBackground: true,
            shadowOfMenu: false,
            hasSeperatorLine: true,
            seperatorLineHasInsets: false,
            textColor: Color(R: 82 / 255.0, G: 82 / 255.0, B: 82 / 255.0),
            menuBackgroundColor: Color(R: 1, G: 1, B: 1),
            setWidth: ( ScreenWidth - 15 * 2) / 2)
        let rect = CGRect(x:navigatorBar.frame.origin.x, y:0, width:navigatorBar.frame.size.width, height:64)
        
        // 特别说明,这里的fromRect之所以没有直接使用sender.frame是因为该button的高度并没有占满整个navigationBar的高度，所以直接填写的titleBar加上navigationBar的高度(64)
        YXJKxMenu.show(in: self.view, from: rect, menuItems: menuArray, withOptions: option)
    }
    var xs : [String :[Schedule]]?
    var meetings : [Int:[Schedule]]  = [:]
    var subview : ShowLessonsController? = nil
    var kierunek : String? = nil
    var rok : String? = nil
    var grupa : String? = nil
    @IBOutlet var navigatorBar: UINavigationBar!
    @IBAction func refresh(_ sender: Any) {
    }
    @IBOutlet var study: UILabel!
    @IBOutlet var group: UILabel!
    @IBOutlet var year: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        var updatedFrame = navigatorBar.bounds
        updatedFrame.size.height += 20
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(red: 0.0, green: 0, blue: 1.0, alpha: 1.0).cgColor as CGColor

        let color2 = UIColor(red: 1.0, green: 0, blue: 1.0, alpha: 1.0).cgColor as CGColor
    
        gradientLayer.colors = [color2, color1]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer1.colors = [color2, color1]
        gradientLayer1.locations = [0.0, 1.0]
        gradientLayer1.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer1.endPoint = CGPoint(x: 0, y: 0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        self.navigatorBar.layer.insertSublayer(gradientLayer1, at: 0)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
       navigatorBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
        
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  loadData(){
        let URL = "https://wmitimetable.herokuapp.com/schedules.json"
        Alamofire.request(URL).responseArray{ (response: DataResponse<[Schedule]>) in
            let resp = response.result.value
            if let resp = resp {
                for r in resp {
                    if self.kierunki.contains(r.study!) == false{
                        self.kierunki.append(r.study!)
                    }
                    self.schedules.append(r)
                    
                }
            }
            self.performSegue(withIdentifier: "selectMenu", sender: self)
        }
    }
    func reloadPagerTabStripView(){
        self.subview?.meetings = self.meetings
        self.subview?.reloadPagerTabStripView()
    }
    func applySelection(kier: String, gr: String, rok: String){
        self.kierunek = kier
        study.text = "Kierunek: "+kier
        self.rok = rok
        year.text = "Rok: "+rok
        self.grupa = gr
        group.text = "Grupa: "+gr
        var sched:[Schedule] = schedules.filter({$0.study == kier && ($0.group == gr || $0.group == "1WA") && $0.year == rok})
        sched.sort(by: {($0.when! < $1.when!)})
        self.meetings = [:]
        for r in sched{
            if self.meetings[r.getWeekOfYear()] == nil{
                self.meetings[r.getWeekOfYear()] = []
            }
            (self.meetings[r.getWeekOfYear()])!.append(r)
        }
        self.reloadPagerTabStripView()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectMenu"{
            let seg = segue.destination as! ViewController
            seg.kierunki = self.kierunki
            seg.schedules = self.schedules
            seg.delegate = self
        }else if segue.identifier == "subViewshow"{
            let seg = segue.destination as! ShowLessonsController
            self.subview = seg
        }

    }
    
}
