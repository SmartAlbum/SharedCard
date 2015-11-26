//
//  Player.swift
//  FightTheLandLord
//
//  Created by  Zhao Shi Lin on 24/11/15.
//  Copyright © 2015年  Zhao Shi Lin. All rights reserved.
//

import Foundation
enum Role{
    case Farmer
    case LandLord
    case Undefined
}
class Player{
    var cards:[Card] = []
    
    func SetCard(assignedCards:[Card]){
        self.cards = assignedCards
    }
}