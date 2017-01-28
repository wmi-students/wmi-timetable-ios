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

class LessonsViewController: UIViewController {
    var kierunki : [String] = []
    @IBOutlet var facultz: UILabel!
    @IBOutlet var year: UILabel!
    var schedules : [Schedule] = []
    @IBOutlet var group: UILabel!
    var xs : [String :[Schedule]]?
    var meetings : [Int:[Schedule]]  = [:]
    var subview : ShowLessonsController? = nil
    var kierunek : String? = nil
    var rok : String? = nil
    var grupa : String? = nil
    @IBOutlet var navigatorBar: UINavigationBar!
    @IBAction func refresh(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        var updatedFrame = navigatorBar.bounds
        updatedFrame.size.height += 20
        

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigatorBar.setBackgroundImage(image, for: UIBarMetrics.default)
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
        self.rok = rok
        self.grupa = gr
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
    @IBOutlet var zer: UILabel!
    @IBOutlet var kier: UILabel!
    @IBOutlet var grup: UILabel!
    
}
