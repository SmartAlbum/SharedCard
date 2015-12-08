//
//  Player.swift
//  FightTheLandLord
//
//  Created by  Zhao Shi Lin on 24/11/15.
//  Copyright © 2015年  Zhao Shi Lin. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum Role{
    case Farmer
    case LandLord
    case Undefined
    
}
class Player:NSObject , NSCoding{
    
    var hideCard:Card? = nil
    var cards:[Card] = []
    var stop:Bool = false
    var Id:MCPeerID?
    var Name:String = ""
    var ready:Bool = true
    var result:GameResult?
    required init(coder aDecoder: NSCoder) {
        super.init()
        Id = aDecoder.decodeObjectForKey("Id") as! MCPeerID?
        cards = aDecoder.decodeObjectForKey("cards") as! [Card]
        stop = aDecoder.decodeObjectForKey("stop") as! Bool
        hideCard = aDecoder.decodeObjectForKey("hideCard") as! Card?
        Name = aDecoder.decodeObjectForKey("Name") as! String
        ready = aDecoder.decodeObjectForKey("ready") as! Bool
    }
    override init(){
        super.init()
    }
    
    func newGame(){
        self.stop = false
        self.cards.removeAll()
        self.hideCard = nil
        self.result = nil
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(Id,forKey:"Id")
        aCoder.encodeObject(cards,forKey:"cards")
        aCoder.encodeObject(stop,forKey:"stop")
        aCoder.encodeObject(hideCard,forKey:"hideCard")
        aCoder.encodeObject(Name,forKey:"Name")
        aCoder.encodeObject(ready,forKey:"ready")
        
    }
    
    func SetCard(assignedCards:[Card]){
        self.cards = assignedCards
    }
    
    func getCard(assignedCard:Card){
        cards.append(assignedCard)
    }
    
    func stopGettingCard(){
        stop = true
        //todo
        if(!self.isCardValueValid()){
            self.result = GameResult.LOSE
        }
    }
    func isAccepttingCard()->Bool{
        return !stop
    }
    
    
    //check card value is less and equal to 21
    func isCardValueValid()->Bool{
        
        let value = getCardsValue()
        return value <= 21 && value >= 0
    }
    
    func isAcceptingCard()->Bool{
        return isCardValueValid() && !stop && cards.count < 4
    }
    
    
    func getCardsValue()->Int{
        var containZero = self.cards.contains{ (element) -> Bool in
            return element.rankString == "A"
        }
        containZero = containZero || (hideCard != nil && hideCard!.rankString == "A")
        
        var value = hideCard == nil ? 0 : hideCard!.value
        
        for card in cards{
            value += card.value
        }
        if(containZero){
            value = value + 10 > 21 ? value : value + 10
        }
        return value
    }
    
    var cardValueStr:String{
        get{
            let value = self.getCardsValue()
            return String(value)
        }
    }

}