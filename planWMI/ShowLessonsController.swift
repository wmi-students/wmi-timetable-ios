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
import Alamofire
import SwiftDate


class ShowLessonsController: ButtonBarPagerTabStripViewController{

    var delegatectrl : ViewController?
    var what: String?
    var kierunki : [String] = []
    var schedules : [Schedule] = []
    var meetings : [Int: [Schedule]] = [:]

    override func viewDidLoad() {

                settings.style.buttonBarBackgroundColor = view.backgroundColor
        settings.style.selectedBarBackgroundColor = view.tintColor
        settings.style.selectedBarHeight = 4
        settings.style.buttonBarItemBackgroundColor = view.backgroundColor
        settings.style.buttonBarItemTitleColor = UIColor.lightGray
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
    
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
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
            
            
        }else{
            let meet_groups = meetings.keys.sorted()
            for key in meet_groups
            {
                var s : DateInRegion = DateInRegion()
                var el : ChildExampleViewController = ChildExampleViewController(itemInfo: IndicatorInfo(title: "\(meetings[key]![0].getShortDateString())"))
                el.setItems(itms: meetings[key]!)

                tabs.append(el)
            }
        }
        guard isReload else {
            return tabs
        }
        childViewControllers = tabs

        return tabs
        
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
            var dts:[String] = []
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
                    let dte : String  = itm.getDateString()
                    if xs[dte] == nil{
                        xs[dte] = []
                    }
                    xs[dte]!.append(itm)
                }
                dts = (Array)(xs.keys).sorted()
                self.label?.reloadData()
            }
            override func viewDidLoad() {
                super.viewDidLoad()
                label = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.height))
                
                
                
                label?.backgroundColor = view.backgroundColor
                view.addSubview(label!)
                label?.dataSource = self
                view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
                view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -50))
            }

            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                let sekt = dts[section]
                var cnt : Int = 0
                if xs[sekt] != nil {
                 cnt = (xs[sekt]?.count)!
                }
                return cnt
            }

            func numberOfSections(in tableView: UITableView) -> Int {
                return dts.count
                
            }
            func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                return dts[section]
            }
            func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 1
            }
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
                let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
                label?.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
                let kiz = dts[indexPath.section]
                guard self.xs[kiz] != nil else {
                    return cell
                }
                guard self.xs[kiz]![indexPath.item] != nil else {
                    return cell
                }
                let keys = dts
                cell.hour.text = (self.xs[keys[indexPath.section]]?[indexPath.item].getHourString())
                cell.lesson.text = (self.xs [keys[indexPath.section]]?[indexPath.item].subject)!
                cell.classroom.text = (self.xs [keys[indexPath.section]]?[indexPath.item].room1)!
                cell.classroom1.text = (self.xs[keys[indexPath.section]]?[indexPath.item].room2)
                //   cell.detailTextLabel?.t ext = xs [keys[indexPath.section]]?[indexPath.item].group
                return cell
            }
            func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
                view.tintColor = UIColor.blue
            }
            
        }
