//
//  Card.swift
//  FightTheLandLord
//
//  Created by  Zhao Shi Lin on 24/11/15.
//  Copyright © 2015年  Zhao Shi Lin. All rights reserved.
//

import Foundation
enum CardType: Int {
    case Spade = 1,Heart=2,Club=3, Diamond=4
    static let allValues = [Spade, Heart, Club, Diamond]
}
enum Planet: Int {
    case Mercury = 1, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
}
class Card:NSObject , NSCoding {
    
    static var rankString: [String] = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    var type:CardType
    var value:Int
    var rankString:String
    
    required init(coder aDecoder: NSCoder) {
        type = CardType(rawValue: aDecoder.decodeObjectForKey("type") as! Int)!
        value = aDecoder.decodeObjectForKey("value") as! Int
        rankString = aDecoder.decodeObjectForKey("rankString") as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(type.rawValue,forKey:"type")
        aCoder.encodeObject(value,forKey:"value")
        aCoder.encodeObject(rankString,forKey: "rankString")
    }
    
    init(cardType:CardType,cardValue:Int,cardString:String){
        value = cardValue
        type = cardType
        rankString = cardString
        super.init()
    }
    
    var typeValue:Int {
        get {
            return type.rawValue
        }
    }
    
    static func getCardValue(rank:String)->Int{
        let value:Int = rank == "A" ? 1 : Int(rank) == nil ? 10 : Int(rank)!
        return value
    }
    
    var imageValueStr:String{
        get{
            let value:String = rankString == "A" ? "1" : rankString
            return value
        }
    }
    
}