//
//  Game.swift
//  FightTheLandLord
//
//  Created by  Zhao Shi Lin on 24/11/15.
//  Copyright © 2015年  Zhao Shi Lin. All rights reserved.
//

import Foundation
class Game:NSObject{
    var players:[Player]
    var currentTurn:Player?
    var cards:[Card]
    
    override init(){
        cards = []
        players = []
        currentTurn = nil
        super.init()
    }
    
    func getCard(playerName:String)->Card?{
        return nil
    }
    
    func deny(palyerName:String){
        
    }
    
    //return winner
    func getWinner()->Player?{
        return nil
    }
    
    
    
    
    
}