//
//  Card.swift
//  FightTheLandLord
//
//  Created by  Zhao Shi Lin on 24/11/15.
//  Copyright © 2015年  Zhao Shi Lin. All rights reserved.
//

import Foundation
enum CardType{
    case Heart
    case Spade
    case Diamond
    case Club
    static let allValues = [Heart,Spade,Diamond,Club]
}

class Card:NSObject {
    static var rankString: [String] = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    var type:CardType
    var value:Int
    var rankString:String
    init(cardType:CardType,cardValue:Int,cardString:String){
        value = cardValue
        type = cardType
        rankString = cardString
        super.init()
    }
    
    static func getCardValue(rank:String)->Int{
        var value:Int = rank == "A" ? 1 : Int(rank) == nil ? 10 : Int(rank)!
        return value
    }
}