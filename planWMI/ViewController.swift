//
//  ViewController.swift
//  planWMI
//
//  Created by wojek on 13/10/2016.
//  Copyright © 2016 wojek. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import RxCocoa
import RxSwift
import Dollar

class ViewController: UIViewController {
    var kierunki: [String] = []
    var lata: [String] = []
    var grupy: [String] = []
    var selectedkierunek : String = ""
    var selectedgroup : String = ""
    var selectedrok : String = ""
    var schedules : [Schedule] = []
    
    
    @IBOutlet weak var kierunek: UIButton!
    @IBOutlet weak var rok: UIButton!
    @IBOutlet weak var group: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.setKierunek(kierunek: self.kierunki[0])
            }
        }
        navigationController?.navigationBar.isHidden = true
    
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setKierunek(kierunek: String){
        self.kierunek.setTitle(kierunek, for: UIControlState.normal)
        self.selectedkierunek = kierunek
        self.lata = []
        for sched in schedules{
            
            if sched.study! == kierunek && (lata.contains(sched.year!) == false){
                self.lata.append(sched.year!)
            }
        }
        self.setRok(rok: self.lata[0])
    }
    func setRok(rok: String){
        self.rok.setTitle(rok, for: UIControlState.normal)
        self.grupy = []
        for sched in schedules{
            if sched.study! == self.selectedkierunek && sched.year! == rok && sched.group != "1WA" && (grupy.contains(sched.group!) == false) {
                self.grupy.append(sched.group!)
            }
        }
        self.setGroup(group: self.grupy[0])
        self.selectedrok = rok
    }
    func setGroup(group: String){
        self.group.setTitle(group, for: UIControlState.normal)
        self.selectedgroup = group
    }
    func setSomething(kierunek: String, what: String){
        if what == "kierunek"{
            self.setKierunek(kierunek: kierunek)
        }else if what == "rok"{
            self.setRok(rok: kierunek)
        }else if what == "grupa"{
            self.setGroup(group: kierunek)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "kierunek"{
            let viewController:SelectKierunekController = (segue.destination as? SelectKierunekController)!
            viewController.xs = kierunki
            viewController.what = "kierunek"
            viewController.delegate = self
        }else if segue.identifier == "rok"{
            let viewController:SelectKierunekController = (segue.destination as? SelectKierunekController)!
            viewController.xs = lata
            viewController.what = "rok"
            viewController.delegate = self
        }else if segue.identifier == "grupa"{
            let viewController:SelectKierunekController = (segue.destination as? SelectKierunekController)!
            viewController.xs = grupy
            viewController.what = "grupa"
            viewController.delegate = self
        }else if segue.identifier == "showlist"{
            let viewController:ShowLessonsController = (segue.destination as? ShowLessonsController)!
            viewController.xs = [:]
            var sched:[Schedule] = schedules.filter({$0.study == self.selectedkierunek && ($0.group == self.selectedgroup || $0.group == "1WA") && $0.year == self.selectedrok})
            sched.sort(by: {$0.when! < $1.when!})
            for sch:Schedule in sched{
                if viewController.xs?[sch.getDateString()] == nil{
                    viewController.xs?[sch.getDateString()] = [sch]
                }else{
                    viewController.xs?[sch.getDateString()]?.append(sch)
                }
            }
            viewController.delegate = self
        }
        
    }


}


