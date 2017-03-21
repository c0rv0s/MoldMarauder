//
//  Breeding Combos.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/8/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import Foundation

class Combo {
    var parents: Array<Mold>
    var child: Mold
    
    init(parents: Array<Mold>, child: Mold) {
        self.parents = parents
        self.child = child
    }
}

class Combos {
    var allCombos: Array<Combo>!
    var comboAlien = [Mold(moldType: MoldType.slime), Mold(moldType: MoldType.angry)]
    var comboFreckled = [Mold(moldType: MoldType.slime), Mold(moldType: MoldType.cave), Mold(moldType: MoldType.sad)]
    var comboHypno = [Mold(moldType: MoldType.alien), Mold(moldType: MoldType.angry), Mold(moldType: MoldType.freckled)]
    var comboPimply = [Mold(moldType: MoldType.freckled), Mold(moldType: MoldType.angry), Mold(moldType: MoldType.cave)]
    var comboRainbow = [Mold(moldType: MoldType.slime), Mold(moldType: MoldType.alien), Mold(moldType: MoldType.hypno), Mold(moldType: MoldType.sad)]
    var comboRock = [Mold(moldType: MoldType.cave), Mold(moldType: MoldType.angry)]
    var comboCircuit = [Mold(moldType: MoldType.aluminum), Mold(moldType: MoldType.freckled)]
    var comboHologram = [Mold(moldType: MoldType.circuit), Mold(moldType: MoldType.alien)]
    var comboStorm = [Mold(moldType: MoldType.hypno), Mold(moldType: MoldType.cloud)]
    var comboBacteria = [Mold(moldType: MoldType.slime), Mold(moldType: MoldType.cave)]
    var comboVirus = [Mold(moldType: MoldType.bacteria)]
    var comboFlower = [Mold(moldType: MoldType.slime), Mold(moldType: MoldType.cave)]
    var comboBee = [Mold(moldType: MoldType.flower), Mold(moldType: MoldType.freckled)]
    var comboX = [Mold(moldType: MoldType.rainbow), Mold(moldType: MoldType.hologram)]
    var comboDisaffected = [Mold(moldType: MoldType.rainbow), Mold(moldType: MoldType.circuit), Mold(moldType: MoldType.crystal)]
    var comboOlive = [Mold(moldType: MoldType.flower), Mold(moldType: MoldType.bacteria), Mold(moldType: MoldType.bee)]
    var comboCoconut = [Mold(moldType: MoldType.flower), Mold(moldType: MoldType.cave), Mold(moldType: MoldType.bee)]
    var comboSick = [Mold(moldType: MoldType.bacteria), Mold(moldType: MoldType.slime)]
    var comboDead = [Mold(moldType: MoldType.sick), Mold(moldType: MoldType.bacteria)]
    var comboZombie = [Mold(moldType: MoldType.dead), Mold(moldType: MoldType.virus)]
    var comboAluminum = [Mold(moldType: MoldType.rock), Mold(moldType: MoldType.angry)]
    var comboCloud = [Mold(moldType: MoldType.rainbow), Mold(moldType: MoldType.flower)]
    var comboWater = [Mold(moldType: MoldType.hypno), Mold(moldType: MoldType.rock), Mold(moldType: MoldType.pimply)]
    var comboCrystal = [Mold(moldType: MoldType.hypno), Mold(moldType: MoldType.rock), Mold(moldType: MoldType.water), Mold(moldType: MoldType.storm)]
    var comboNuclear = [Mold(moldType: MoldType.zombie), Mold(moldType: MoldType.storm), Mold(moldType: MoldType.crystal)]
    var comboAstronaut = [Mold(moldType: MoldType.alien), Mold(moldType: MoldType.nuclear)]
    var comboSand = [Mold(moldType: MoldType.rock), Mold(moldType: MoldType.aluminum), Mold(moldType: MoldType.angry), Mold(moldType: MoldType.pimply), Mold(moldType: MoldType.water)]
    var comboGlass = [Mold(moldType: MoldType.sand), Mold(moldType: MoldType.water), Mold(moldType: MoldType.slime)]
    var comboCoffee = [Mold(moldType: MoldType.coconut), Mold(moldType: MoldType.water), Mold(moldType: MoldType.bacteria)]
    var comboSlinky = [Mold(moldType: MoldType.rainbow), Mold(moldType: MoldType.coconut), Mold(moldType: MoldType.circuit),Mold(moldType: MoldType.nuclear)]
    var comboMagma = [Mold(moldType: MoldType.rock), Mold(moldType: MoldType.nuclear)]
    var comboSamurai = [Mold(moldType: MoldType.aluminum), Mold(moldType: MoldType.magma)]
    var comboOrange = [Mold(moldType: MoldType.coconut), Mold(moldType: MoldType.sand), Mold(moldType: MoldType.bacteria)]
    var comboStrawberry = [Mold(moldType: MoldType.orange), Mold(moldType: MoldType.water), Mold(moldType: MoldType.bacteria), Mold(moldType: MoldType.slinky)]
    var comboTshirt = [Mold(moldType: MoldType.orange), Mold(moldType: MoldType.strawberry), Mold(moldType: MoldType.coffee), Mold(moldType: MoldType.circuit)]
    var comboCryptid = [Mold(moldType: MoldType.hologram), Mold(moldType: MoldType.astronaut), Mold(moldType: MoldType.tshirt), Mold(moldType: MoldType.nuclear), Mold(moldType: MoldType.samurai)]
    var comboAngel = [Mold(moldType: MoldType.hologram), Mold(moldType: MoldType.slinky), Mold(moldType: MoldType.tshirt), Mold(moldType: MoldType.nuclear), Mold(moldType: MoldType.flower)]
    var comboInvisible = [Mold(moldType: MoldType.cryptid), Mold(moldType: MoldType.angel)]
    
    init() {
        //slime plus cave equals alien
        self.allCombos = [Combo(parents: comboAlien, child: Mold(moldType: MoldType.alien))]
        self.allCombos.append(Combo(parents: comboFreckled, child: Mold(moldType: MoldType.freckled)))
        self.allCombos.append(Combo(parents: comboHypno, child: Mold(moldType: MoldType.hypno)))
        self.allCombos.append(Combo(parents: comboPimply, child: Mold(moldType: MoldType.pimply)))
        self.allCombos.append(Combo(parents: comboRainbow, child: Mold(moldType: MoldType.rainbow)))
        self.allCombos.append(Combo(parents: comboAluminum, child: Mold(moldType: MoldType.aluminum)))
        self.allCombos.append(Combo(parents: comboCircuit, child: Mold(moldType: MoldType.circuit)))
        self.allCombos.append(Combo(parents: comboHologram, child: Mold(moldType: MoldType.hologram)))
        self.allCombos.append(Combo(parents: comboStorm, child: Mold(moldType: MoldType.storm)))
        self.allCombos.append(Combo(parents: comboBacteria, child: Mold(moldType: MoldType.bacteria)))
        self.allCombos.append(Combo(parents: comboVirus, child: Mold(moldType: MoldType.virus)))
        self.allCombos.append(Combo(parents: comboFlower, child: Mold(moldType: MoldType.flower)))
        self.allCombos.append(Combo(parents: comboBee, child: Mold(moldType: MoldType.bee)))
        self.allCombos.append(Combo(parents: comboX, child: Mold(moldType: MoldType.x)))
        self.allCombos.append(Combo(parents: comboDisaffected, child: Mold(moldType: MoldType.disaffected)))
        self.allCombos.append(Combo(parents: comboOlive, child: Mold(moldType: MoldType.olive)))
        self.allCombos.append(Combo(parents: comboCoconut, child: Mold(moldType: MoldType.coconut)))
        self.allCombos.append(Combo(parents: comboSick, child: Mold(moldType: MoldType.sick)))
        self.allCombos.append(Combo(parents: comboDead, child: Mold(moldType: MoldType.dead)))
        self.allCombos.append(Combo(parents: comboZombie, child: Mold(moldType: MoldType.zombie)))
        self.allCombos.append(Combo(parents: comboRock, child: Mold(moldType: MoldType.rock)))
        self.allCombos.append(Combo(parents: comboCloud, child: Mold(moldType: MoldType.cloud)))
        self.allCombos.append(Combo(parents: comboWater, child: Mold(moldType: MoldType.water)))
        self.allCombos.append(Combo(parents: comboCrystal, child: Mold(moldType: MoldType.crystal)))
        self.allCombos.append(Combo(parents: comboNuclear, child: Mold(moldType: MoldType.nuclear)))
        self.allCombos.append(Combo(parents: comboAstronaut, child: Mold(moldType: MoldType.astronaut)))
        self.allCombos.append(Combo(parents: comboSand, child: Mold(moldType: MoldType.sand)))
        self.allCombos.append(Combo(parents: comboGlass, child: Mold(moldType: MoldType.glass)))
        self.allCombos.append(Combo(parents: comboCoffee, child: Mold(moldType: MoldType.coffee)))
        self.allCombos.append(Combo(parents: comboSlinky, child: Mold(moldType: MoldType.slinky)))
        self.allCombos.append(Combo(parents: comboMagma, child: Mold(moldType: MoldType.magma)))
        self.allCombos.append(Combo(parents: comboSamurai, child: Mold(moldType: MoldType.samurai)))
        self.allCombos.append(Combo(parents: comboOrange, child: Mold(moldType: MoldType.orange)))
        self.allCombos.append(Combo(parents: comboStrawberry, child: Mold(moldType: MoldType.strawberry)))
        self.allCombos.append(Combo(parents: comboTshirt, child: Mold(moldType: MoldType.tshirt)))
        self.allCombos.append(Combo(parents: comboCryptid, child: Mold(moldType: MoldType.cryptid)))
        self.allCombos.append(Combo(parents: comboAngel, child: Mold(moldType: MoldType.angel)))
        self.allCombos.append(Combo(parents: comboInvisible, child: Mold(moldType: MoldType.invisible)))
    }

}
