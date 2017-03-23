//
//  Items.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/2/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit

enum MoldType: Int, CustomStringConvertible {
    case unknown = 0, slime, cave, sad, angry, alien, pimply, freckled, hypno, rainbow, aluminum, circuit, hologram, storm, bacteria, virus, x, flower, bee, disaffected, olive, coconut, sick, dead, zombie, cloud, rock, water, crystal, nuclear, astronaut, sand, glass, coffee, slinky, magma, samurai, orange, strawberry, tshirt, cryptid, angel, invisible, star
    
    var spriteName: String {
        let spriteNames = [
            "Slime Mold",
            "Cave Mold",
            "Sad Mold",
            "Angry Mold",
            "Alien Mold",
            "Pimply Mold",
            "Freckled Mold",
            "Hypno Mold",
            "Rainbow Mold",
            "Aluminum Mold",
            "Circuit Mold",
            "Hologram Mold",
            "Storm Mold",
            "Bacteria Mold",
            "Virus Mold",
            "X Mold",
            "Flower Mold",
            "Bee Mold",
            "Disaffected Mold",
            "Olive Mold",
            "Coconut Mold",
            "Sick Mold",
            "Dead Mold",
            "Zombie Mold",
            "Cloud Mold",
            "Rock Mold",
            "Water Mold",
            "Crystal Mold",
            "Nuclear Mold",
            "Astronaut Mold",
            "Sand Mold",
            "Glass Mold",
            "Coffee Mold",
            "Slinky Mold",
            "Magma Mold",
            "Samurai Mold",
            "Orange Mold",
            "Strawberry Mold",
            "TShirt Mold",
            "Cryptid Mold",
            "Angel Mold",
            "Invisible Mold",
            "Star Mold"]
        
        return spriteNames[rawValue - 1]
    }
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    var greySpriteName: String {
        return spriteName + " Grey"
    }
    static func random() -> MoldType {
        return MoldType(rawValue: Int(arc4random_uniform(38)) + 1)!
    }
    var description: String {
        return spriteName
    }
    var price: BInt {
        let prices = [
            BInt("2000"),
            BInt("5000"),
            BInt("10000"),
            BInt("50000"),
            BInt("25000"),
            BInt("75000"),
            BInt("106000"),
            BInt("124000"),
            BInt("106000"),
            BInt("250000"),
            BInt("6000000"),
            BInt("3000000"),
            BInt("5750000"),
            BInt("960000000"),
            BInt("210000000"),
            BInt("320000000"),
            BInt("7800000000"),
            BInt("9960000000"),
            BInt("2000000000"),
            BInt("45000000000"),
            BInt("87000000000"),
            BInt("19800000000"),
            BInt("430000000000"),
            BInt("120000000000"),
            BInt("790000000000"),
            BInt("2400000000000"),
            BInt("5670000000000"),
            BInt("6700000000000"),
            BInt("19700000000000"),
            BInt("64500000000000"),
            BInt("998000000000000"),
            BInt("322000000000000"),
            BInt("680000000000000"),
            BInt("1700000000000000"),
            BInt("5435400000000000"),
            BInt("9878900000000000"),
            BInt("87623000000000000"),
            BInt("87670000000000000"),
            BInt("567000000000000000"),
            BInt("6437800000000000000"),
            BInt("7592780000000000000"),
            BInt("999999999999999999999"),
            BInt("0")]
        
        return prices[rawValue - 1]
    }
    var pointsPerSecond: BInt {
        let PPS = [
            BInt("20"),
            BInt("50"),
            BInt("100"),
            BInt("500"),
            BInt("2500"),
            BInt("7500"),
            BInt("1060"),
            BInt("1240"),
            BInt("1260"),
            BInt("4500"),
            BInt("13000"),
            BInt("40000"),
            BInt("21000"),
            BInt("67000"),
            BInt("120000"),
            BInt("320000"),
            BInt("3500000"),
            BInt("6560000"),
            BInt("2000000"),
            BInt("4500000"),
            BInt("190000000"),
            BInt("800000000"),
            BInt("430000000"),
            BInt("120000000"),
            BInt("24000000000"),
            BInt("79000000000"),
            BInt("42700000000"),
            BInt("67000000000"),
            BInt("190000000000"),
            BInt("645000000000"),
            BInt("198000000000"),
            BInt("320000000000"),
            BInt("6800000000000"),
            BInt("1700000000000"),
            BInt("3435400000000"),
            BInt("68789000000000"),
            BInt("77623000000000"),
            BInt("77670000000000"),
            BInt("46700000000000"),
            BInt("543799000000000"),
            BInt("659273780000000"),
            BInt("9999999999999999"),
            BInt("999999")]
        
        return PPS[rawValue - 1]
    }
}

class Mold: CustomStringConvertible {
    let moldType: MoldType
    let name: String
    let price: BInt
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
