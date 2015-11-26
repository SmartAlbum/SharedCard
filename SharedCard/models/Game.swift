//
//  Game.swift
//  FightTheLandLord
//
//  Created by  Zhao Shi Lin on 24/11/15.
//  Copyright © 2015年  Zhao Shi Lin. All rights reserved.
//

import Foundation
class Game{
    var players:[Player]
    var cards:[Card]
    init(){
        cards = []
        for i in 1...13{
            for type in CardType.fourValues{
                cards.append(Card(cardType: type, cardValue: i))
            }
        }
        cards.append(<#T##newElement: Card##Card#>)
        players = []
    }
}