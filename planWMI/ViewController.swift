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

extension Array {
    
    func groupBy<G: Hashable>(groupClosure: (Element) -> G) -> [G: [Element]] {
        var dictionary = [G: [Element]]()
        
        for element in self {
            let key = groupClosure(element)
            var array: [Element]? = dictionary[key]
            
            if (array == nil) {
                array = [Element]()
            }
            
            array!.append(element)
            dictionary[key] = array!
        }
        
        return dictionary
    }
}
class ViewController: UIViewController{
    var kierunki: [String] = []
    var lata: [String] = []
    var grupy: [String] = []
    var selectedkierunek : String = ""
    var selectedgroup : String = ""
    var selectedrok : String = ""
    var schedules : [Schedule] = []
    var meetings : [Int: [Schedule]] = [:]
    var delegate : LessonsViewController? = nil

    @IBOutlet weak var kierunek: UIButton!
    @IBOutlet weak var rok: UIButton!
    @IBOutlet weak var group: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
                navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        if delegate?.kierunek == nil{
            setKierunek(kierunek: kierunki[0])
        }else{
            setKierunek(kierunek: (delegate?.kierunek)!)
        }
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
        if delegate?.rok == nil {
            self.setRok(rok: self.lata[0])
        }else{
            self.setRok(rok: (delegate?.rok)!)
        }
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
    @IBAction func selected(_ sender: Any) {
        let viewController:LessonsViewController = self.delegate!
        viewController.applySelection(kier: selectedkierunek, gr: selectedgroup, rok: selectedrok)
        dismiss(animated: true, completion: nil)
        
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
            let viewController:LessonsViewController = (segue.destination as? LessonsViewController)!
            viewController.xs = [:]
            var sched:[Schedule] = schedules.filter({$0.study == self.selectedkierunek && ($0.group == self.selectedgroup || $0.group == "1WA") && $0.year == self.selectedrok})
            sched.sort(by: {($0.when! < $1.when!)})
            self.meetings = [:]
            for r in sched{
                if self.meetings[r.getWeekOfYear()] == nil{
                    self.meetings[r.getWeekOfYear()] = []
                }
                (self.meetings[r.getWeekOfYear()])!.append(r)
            }
            
            viewController.meetings = self.meetings
        }
        
    }


}


