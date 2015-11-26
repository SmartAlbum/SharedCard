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
    case BlackJoker
    case RedJoker
    static let fourValues = [Heart, Spade, Diamond, Club]
}

class Card {
    var type:CardType
    var value:Int
    init(cardType:CardType,cardValue:Int){
        type = cardType
        value = cardValue
    }
}