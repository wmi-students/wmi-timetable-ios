//
//  Schedule.swift
//  planWMI
//
//  Created by wojek on 14/10/2016.
//  Copyright © 2016 wojek. All rights reserved.
//

import Foundation
import ObjectMapper

class Schedule : Mappable{
    var subject : String?
    var group : String?
    var study : String?
    var leader : String?
    var year: String?
    var room1 : String?
    var room2 : String?
    var when : Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group <- map["group"]
        study <- map["study"]
        leader <- map["leader"]
        year <- map["year"]
        room1 <- map["room1"]
        room2 <- map["room2"]
        subject <- map["subject"]
        var strdate : String = ""
        let dateFormatter = DateFormatter()
        strdate <- map["when"]
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        when = dateFormatter.date(from: strdate)
    }
    func getDateString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter.string(from: when!)
    }
    func getHourString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: when!)
    }}
