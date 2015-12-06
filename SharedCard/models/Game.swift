//
//  Game.swift
//  FightTheLandLord
//
//  Created by  Zhao Shi Lin on 24/11/15.
//  Copyright © 2015年  Zhao Shi Lin. All rights reserved.
//

import Foundation
import MultipeerConnectivity
extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
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
    static let Instance = Game()
    
    private override convenience init(){
        let emptyPlayers:[Player] = []
        self.init(enteredPlayers: emptyPlayers)
    }
    
    private init(enteredPlayers:[Player]){
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
                    let value = Card.getCardValue(rank)
                    let newCard = Card(cardType: type, cardValue: value, cardString: rank)
                    cards.append(newCard)
                    
                }
            }
        }
        RandomCard()
    }
    
    
    //start Game, assigned cards to all players
    func startGame(){
//        if(players.count<2){
//            return
//        }
        RandomPlayer()
        
        if(cards.count<players.count*5){
            initCards()
        }
        for var player in players{
            player.stop = false
            player.cards.removeAll()
            player.hideCard = cards.removeLast()
            player.cards.append(cards.removeLast())
        }
        currentTurn = players[0]
    }
    
    func getCard()->Card?{
        if(currentTurn == nil){
            return nil
        }
        let assignedCard:Card = cards.removeLast()
        currentTurn!.cards.append(assignedCard)
        
        if(!currentTurn!.isAcceptingCard()){
            currentTurn?.stopGettingCard()
        }
        
        //determine a player to stop getting card.
        var nextPlayer:Player?
        for var offset = 1 ; offset < players.count  ; ++offset {
            let currentIndex = players.indexOf(currentTurn!)
            let index = (currentIndex! + offset) % players.count
            if(players[index].isAcceptingCard()){
                nextPlayer = players[index]
                break
            }
        }
        
        if(nextPlayer != nil){
            currentTurn = nextPlayer!
        }
        else if(!currentTurn!.isAcceptingCard()){
            //todo
            currentTurn = nil
            NSNotificationCenter.defaultCenter().postNotificationName("notifyGameEnd",object: nil)
        }
        
        return assignedCard
    }





    func getPlayer(playerId:MCPeerID)->Player?{
        if(players.filter{ $0.Id == playerId}.count>0){
            return players.filter{ $0.Id == playerId}[0]
        }
        else {
            return nil
        }
        
    }
    
    func getAllPlayers()->[Player]{
        return players
    }
    
    private func getRemainingCardCount()->Int{
        return cards.count
    }
    

    
    
    //stopAccpetingCard
    func stopGettingCard(playerId:MCPeerID){
        let stopPlayer = players.filter{ $0.Id == playerId }[0]
        stopPlayer.stopGettingCard()
        var currentPlayer:Player?
        for var offset = 1 ; offset < players.count  ; ++offset{
            let currentIndex = players.indexOf(stopPlayer)
            let index = (currentIndex! + offset) % players.count
            if(players[index].isCardValueValid() && !players[index].stop){
                currentPlayer = players[index]
                break
            }
        }
        if(currentPlayer != nil){
            currentTurn = currentPlayer!
        }
        else{
            //todo
            currentTurn = nil
            NSNotificationCenter.defaultCenter().postNotificationName("notifyGameEnd",object: nil)
        }
    }
    
    
    //enter a new player
    func addPlayer(player:Player){
        if(!players.contains{ (element) -> Bool in return element.Id == player.Id}){
            players.append(player)
        }
    }
    
    func removePlayer(playerId:MCPeerID){
        players.removeAtIndex(players.indexOf{ $0.Id == playerId }!)
    }
    
    func removeAllPlayer(){
        players.removeAll();
    }
    
    //get result of particular player
    func getReuslt(playerId:MCPeerID)->GameResult{
        let currnetPlayer:Player = players.filter{ $0.Id == playerId }[0]
        var maxValue = -1
        for player in players{
            if(player.Id != currnetPlayer.Id && player.isCardValueValid()){
                maxValue = max(maxValue,player.getCardsValue())
            }
        }
        
        let numOfMaxValueCount = maxValue > 0 ? players.filter{ $0.getCardsValue() == maxValue }.count : 0
        
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
        return players.filter{ getReuslt($0.Id!) == resultType }
    }
    
    func RandomCard(){
        cards = cards.shuffle()
    }
    func RandomPlayer(){
        players = players.shuffle()
    }
    
    func getCurrentPlayer()->Player?{
        return currentTurn
    }
    
    func playerReady(playerId:MCPeerID)->Int{
        let targetPlayers = players.filter{ $0.Id == playerId }
        if(targetPlayers.count>0){
            let player = targetPlayers[0]
            player.ready = true
        }
        return players.filter{ $0.ready }.count
    }
    
    func playerCount()->Int{
        return players.count
    }
    
    
}