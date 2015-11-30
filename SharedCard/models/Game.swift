//
//  Game.swift
//  FightTheLandLord
//
//  Created by  Zhao Shi Lin on 24/11/15.
//  Copyright © 2015年  Zhao Shi Lin. All rights reserved.
//

import Foundation
extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}
enum GameResult{
    case WIN
    case LOSE
    case DRAW
}
class Game:NSObject{
    
    var players:[Player]
    var currentTurn:Player?
    var cards:[Card]
    let numOfCardPack = 4
    
    override convenience init(){
        let emptyPlayers:[Player] = []
        self.init(enteredPlayers: emptyPlayers)
    }
    
    init(enteredPlayers:[Player]){
        self.cards = []
        self.players = enteredPlayers
        super.init()
        initCards()
    }
    
    func initCards(){
        cards.removeAll()
        for var index = 0; index < self.numOfCardPack; ++index {
            for rank in Card.rankString{
                for type in CardType.allValues{
                    var value = Card.getCardValue(rank)
                    var newCard = Card(cardType: type, cardValue: value, cardString: rank)
                    cards.append(newCard)
                    
                }
            }
        }
        RandomCard()
    }
    
    
    //start Game, assigned cards to all players
    func startGame(){
        if(players.count<2){
            return
        }
        RandomPlayer()
        
        if(cards.count<players.count*10){
            initCards()
        }
        for var player in players{
            player.cards.removeAll()
            player.hideCard = cards.removeLast()
            player.cards.append(cards.removeLast())
        }
    }
    
    func getCard(Id:String)->Card{
        var filterPlayers:[Player] = players.filter{ $0.Id == Id}
        var assignedCard:Card = cards.removeLast()
        filterPlayers[0].cards.append(assignedCard)
        return assignedCard
    }

    


    func getPlayer(playerId:String)->Player{
        return players.filter{ $0.Id == playerId}[0]
    }
    
    private func getRemainingCardCount()->Int{
        return cards.count
    }
    

    
    
    //stopAccpetingCard
    func stopGettingCard(playerId:String){
        var stopPlayer = players.filter{ $0.Id == playerId }[0]
        stopPlayer.stopGettingCard()
    }
    
    
    //enter a new player
    func addPlayer(player:Player){
        if(!players.contains{ (element) -> Bool in return element.Id == player.Id}){
            players.append(player)
        }
    }
    
    //get result of particular player
    func getReuslt(playerId:String)->GameResult{
        var currnetPlayer:Player = players.filter{ $0.Id == playerId }[0]
        var maxValue = -1
        for player in players{
            if(player.Id != currnetPlayer.Id && player.isCardValueValid()){
                maxValue = max(maxValue,player.getCardsValue())
            }
        }
        
        var numOfMaxValueCount = maxValue > 0 ? players.filter{ $0.getCardsValue() == maxValue }.count : 0
        
        if(maxValue<0 && !currnetPlayer.isCardValueValid()){
            return GameResult.DRAW
        }
        else if(maxValue<0){
            return GameResult.WIN
        }
        else if(!currnetPlayer.isCardValueValid()){
            return GameResult.LOSE
        }
        else{
            if(numOfMaxValueCount == players.count){
                return GameResult.DRAW
            }
            else {
                return currnetPlayer.getCardsValue() >= maxValue ? GameResult.WIN : GameResult.LOSE
            }
        }
        
    }
    
    //return players according to their corresponding GameResult
    func getPlayerBaseOnReuslt(resultType:GameResult)->[Player]{
        return players.filter{ getReuslt($0.Id) == resultType }
    }
    
    func RandomCard(){
        cards.shuffle()
    }
    func RandomPlayer(){
        players.shuffle()
    }
    
    
    
    
}