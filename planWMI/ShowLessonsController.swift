		//
//  ShowLessonsController.swift
//  planWMI
//
//  Created by wojek on 17/10/2016.
//  Copyright © 2016 wojek. All rights reserved.
//

import UIKit
import Foundation
import XLPagerTabStrip


class ShowLessonsController: ButtonBarPagerTabStripViewController{
    var xs : [String :[Schedule]]?
    var delegatectrl : ViewController?
    var what: String?
    var meetings : [Int: [Schedule]] = [:]
    override func viewDidLoad() {
        buttonBarView.backgroundColor = .white
        settings.style.buttonBarBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor.brown
        settings.style.selectedBarHeight = 1
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemTitleColor = UIColor.darkGray
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    var isReload = false
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var tabs : [ChildExampleViewController] = []
        var childViewControllers : [ChildExampleViewController]  = []
        if meetings.keys.count == 0 {
            let child_1 = ChildExampleViewController(itemInfo: "...")
            let child_2 = ChildExampleViewController(itemInfo: "...")
            tabs  = [child_1, child_2]
            childViewControllers = [child_1, child_2]
        }else{
            for key in meetings.keys.sorted()
            {
                var el : ChildExampleViewController = ChildExampleViewController(itemInfo: IndicatorInfo(title: "\(key)"))
                el.setItems(itms: meetings[key]!)
                tabs.append(el)
            }
        }
        guard isReload else {
            return tabs
        }
        for (index, _) in childViewControllers.enumerated(){
            let nElements = childViewControllers.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index{
                swap(&childViewControllers[index], &childViewControllers[n])
            }
        }
        let nItems = 1 + (arc4random() % 8)
        return Array(childViewControllers.prefix(Int(nItems)))
    }
    
    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        }
        else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }
        }
        
        
        
        import Foundation
        import XLPagerTabStrip
        
        class ChildExampleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {
            var label : UITableView? = nil
            var itemInfo: IndicatorInfo = "View"
            var xs : [ String : [Schedule]] = [ : ]
            func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
                return self.itemInfo
            }
            init(itemInfo: IndicatorInfo) {
                self.itemInfo = itemInfo
                super.init(nibName: nil, bundle: nil)
            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            func setItems(itms:[Schedule]){
                for itm in itms{
                    var dte : String  = itm.getDateString()
                    if xs[dte] == nil{
                        xs[dte] = []
                    }
                    xs[dte]!.append(itm)
                }
                self.label?.reloadData()
            }
            override func viewDidLoad() {
                super.viewDidLoad()
                
                label = UITableView(frame: CGRect(x: 0, y: 150, width: self.view.frame.size.width, height: self.view.frame.height))
                
                
                
                view.addSubview(label!)
                label?.dataSource = self
                view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
                view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -50))
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
                        
                        self.setKierunek(kierunek: self.kierunki[0])
                    }
                }
            }
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                let keys = Array(xs.keys)
                
                let sekt = (Array)(keys)[section]
                var cnt : Int = 0
                if xs[sekt] != nil {
                 cnt = (xs[sekt]?.count)!
                }
                return cnt
            }

            func numberOfSections(in tableView: UITableView) -> Int {
                return xs.keys.count
                
            }
            func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                let keys = Array(xs.keys)
                
                return keys[section]
            }
                
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
                let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
                label?.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
                let keys = Array((xs.keys))
                
                cell.textLabel?.text = (xs [keys[indexPath.section]]?[indexPath.item].subject)!+" "+(xs [keys[indexPath.section]]?[indexPath.item].getHourString())!
             //   cell.detailTextLabel?.text = xs [keys[indexPath.section]]?[indexPath.item].group
                return cell
            }

            
        }
