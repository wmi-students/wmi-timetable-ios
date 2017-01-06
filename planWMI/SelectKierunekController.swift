//
//  SelectKierunekController.swift
//  planWMI
//
//  Created by wojek on 15/10/2016.
//  Copyright © 2016 wojek. All rights reserved.
//

import UIKit
import Foundation


class SelectKierunekController: UITableViewController{
    var xs : [String]?
    var delegate : ViewController?
    var what: String?
    
    override func viewDidLoad() {
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xs!.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        cell.textLabel?.text = xs? [indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n = indexPath.row
        self.delegate?.setSomething(kierunek: (xs?[n])!, what: what!)
        self.dismiss(animated: true, completion: nil)
    }
}
