//
//  Items.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/2/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit

enum MoldType: Int, CustomStringConvertible {
    case unknown = 0, slime, cave, sad, angry, alien, freckled, bacteria, flower, rock, hypno, pimply, aluminum, virus, bee, sick, rainbow,circuit, olive, coconut, dead, water, hologram,  zombie, cloud, sand, coffee, storm, x, glass, orange, crystal, disaffected, nuclear, astronaut, slinky, magma, samurai, strawberry, tshirt, cryptid, angel, invisible, star, metaphase
    
    var spriteName: String {
        let spriteNames = [
            "Slime Mold",
            "Cave Mold",
            "Sad Mold",
            "Angry Mold",
            "Alien Mold",
            "Freckled Mold",
            "Bacteria Mold",
            "Flower Mold",
            "Rock Mold",
            "Hypno Mold",
            "Pimply Mold",
            "Aluminum Mold",
            "Virus Mold",
            "Bee Mold",
            "Sick Mold",
            "Rainbow Mold",
            "Circuit Mold",
            "Olive Mold",
            "Coconut Mold",
            "Dead Mold",
            "Water Mold",
            "Hologram Mold",
            "Zombie Mold",
            "Cloud Mold",
            "Sand Mold",
            "Coffee Mold",
            "Storm Mold",
            "X Mold",
            "Glass Mold",
            "Orange Mold",
            "Crystal Mold",
            "Disaffected Mold",
            "Nuclear Mold",
            "Astronaut Mold",
            "Slinky Mold",
            "Magma Mold",
            "Samurai Mold",
            "Strawberry Mold",
            "TShirt Mold",
            "Cryptid Mold",
            "Angel Mold",
            "Invisible Mold",
            "Star Mold",
            "Metaphase Mold"]
        
        return spriteNames[rawValue - 1]
    }
    static func random() -> MoldType {
        return MoldType(rawValue: Int(arc4random_uniform(42)) + 1)!
    }
    var description: String {
        return spriteName
    }
    var price: BInt {
        let prices = [
            BInt("200"),
            BInt("2560"),
            BInt("10200"),
            BInt("51100"),
            BInt("25000"),
            BInt("75000"),
            BInt("106000"),
            BInt("1040000"),
            BInt("1260000"),
            BInt("25000000"),
            BInt("60000000"),
            BInt("300000000"),
            BInt("575000000"),
            BInt("2100000000"),
            BInt("9600000000"),
            BInt("32000000000"),
            BInt("78000000000"),
            BInt("236000000000"),
            BInt("996000000000"),
            BInt("4500000000000"),
            BInt("87000000000000"),
            BInt("198000000000000"),
            BInt("120000000000000"),
            BInt("430000000000000"),
            BInt("790000000000000"),
            BInt("1970000000000000"),
            BInt("2400000000000000"),
            BInt("5670000000000000"),
            BInt("6700000000000000"),
            BInt("32200000000000000"),
            BInt("64500000000000000"),
            BInt("99800000000000000"),
            BInt("170000000000000000"),
            BInt("543540000000000000"),
            BInt("680000000000000000"),
            BInt("8762300000000000000"),
            BInt("9878900000000000000"),
            BInt("87670000000000000000"),
            BInt("567000000000000000000"),
            BInt("64378000000000000000000"),
            BInt("75927800000000000000000"),
            BInt("999999999999999999999999999"),
            BInt("0"),
            BInt("0")
        ]
        
        return prices[rawValue - 1]!
    }
    var pointsPerSecond: BInt {
        let PPS = [
            BInt("10"),
            BInt("55"),
            BInt("115"),
            BInt("500"),
            BInt("2500"),
            BInt("7500"),
            BInt("1060"),
            BInt("1240"),
            BInt("1860"),
            BInt("4500"),
            BInt("13000"),
            BInt("21000"),
            BInt("40000"),
            BInt("67000"),
            BInt("120000"),
            BInt("320000"),
            BInt("2000000"),
            BInt("3500000"),
            BInt("4500000"),
            BInt("6560000"),
            BInt("120000000"),
            BInt("190000000"),
            BInt("430000000"),
            BInt("800000000"),
            BInt("24000000000"),
            BInt("42700000000"),
            BInt("79000000000"),
            BInt("670000000000"),
            BInt("1900000000000"),
            BInt("1980000000000"),
            BInt("6450000000000"),
            BInt("32000000000000"),
            BInt("680000000000000"),
            BInt("1700000000000000"),
            BInt("34354000000000000"),
            BInt("68789000000000000"),
            BInt("77623000000000000"),
            BInt("776700000000000000"),
            BInt("467000000000000000"),
            BInt("5437990000000000000"),
            BInt("6592737800000000000"),
            BInt("999999999999999999999"),
            BInt("999999"),
            BInt("0"),
        ]
        
        return PPS[rawValue - 1]!
    }
}

class Mold: CustomStringConvertible {
    let moldType: MoldType
    let name: String
    var price: BInt
    var sprite: SKSpriteNode?
    var level: Int
    var PPS: BInt
    
    init(moldType: MoldType) {
        self.moldType = moldType
        self.name = moldType.description
        self.price = moldType.price
        self.level = 0
        self.PPS = moldType.pointsPerSecond
    }

    var description: String {
        return "type:\(moldType)"
    }
    
}
