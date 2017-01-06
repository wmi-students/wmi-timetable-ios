	//
//  ShowLessonsController.swift
//  planWMI
//
//  Created by wojek on 17/10/2016.
//  Copyright © 2016 wojek. All rights reserved.
//

import UIKit
import Foundation


class ShowLessonsController: UITableViewController{
    var xs : [String :[Schedule]]?
    var delegate : ViewController?
    var what: String?
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = false
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
            return (xs?.keys.count)!
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = Array((xs?.keys)!)
        
        return (Array)(keys)[section]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array((xs?.keys)!)
        
        let sekt = (Array)(keys)[section]
        return (xs![sekt]?.count)!
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customlessoncell", for: indexPath)
        let keys = Array((xs?.keys)!)
        cell.textLabel?.text = (xs? [keys[indexPath.section]]?[indexPath.item].subject)!+" "+(xs? [keys[indexPath.section]]?[indexPath.item].getHourString())!
        cell.detailTextLabel?.text = xs? [keys[indexPath.section]]?[indexPath.item].group
        return cell
    }
}
