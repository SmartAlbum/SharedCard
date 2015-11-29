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
    var type:CardType
    var value:[Int]
    var rankString:String
    init(cardType:CardType,cardValue:[Int],cardString:String){
        value = cardValue
        type = cardType
        rankString = cardString
        super.init()
    }
}