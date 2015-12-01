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
class Player:NSObject{
    var hideCard:Card? = nil
    var cards:[Card] = []
    var stop:Bool = false
    var Id:String = ""
    var Name:String = ""
    
    
    func SetCard(assignedCards:[Card]){
        self.cards = assignedCards
    }
    
    func getCard(assignedCard:Card){
        cards.append(assignedCard)
    }
    
    func stopGettingCard(){
        stop = true
        //todo
    }
    func isAccepttingCard()->Bool{
        return !stop
    }
    //check card value is less and equal to 21
    func isCardValueValid()->Bool{
        
        var value = getCardsValue()
        return value <= 21 && value >= 0
    }
    
    func getCardsValue()->Int{
        var containZero = self.cards.contains{ (element) -> Bool in
            return element.rankString == "A"
        }
        containZero == containZero || hideCard!.rankString == "A"
        
        var value = hideCard!.value
        
        for card in cards{
            value += card.value
        }
        if(containZero){
            value = value + 10 > 21 ? value : value + 10
        }
        return value
    }
}