//
//  DataProvider.swift
//  planWMI
//
//  Created by user115090 on 5/1/17.
//  Copyright © 2017 wojek. All rights reserved.
//

import UIKit
import Alamofire
class DataProvider {

   static let sharedInstance = DataProvider()
    var kierunki : [String]
    var schedules : [Schedule]
    
    let URL = "https://wmitimetable.herokuapp.com/schedules.json"
    
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
            
        }
    }
    init(){
        kierunki = []
        schedules = []
        
    }
}
