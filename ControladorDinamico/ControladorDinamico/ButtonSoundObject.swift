//
//  ButtonSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonSoundObject : SoundObject, Touchable
{
    override var gridHeight:CGFloat { get { return 1 } }
    override var gridWidth:CGFloat { get { return 1 } }
    override var imageName:String { get { return "button.png" } }
    
    var selectedTextureName:String { get { return "buttonSelected.png" } }
    var selectedTexture:SKTexture?
    var stillTexture:SKTexture?

    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
        self.loadTextures();
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(gridSize:CGFloat) {
        super.init(gridSize:gridSize)
    }
    
    func touchStarted() {
        self.texture = self.selectedTexture;
    }

    func touchEnded() {
        self.texture = self.stillTexture;
    }
    
    func loadTextures() {
        self.selectedTexture = SKTexture(imageNamed: self.selectedTextureName);
        self.stillTexture = SKTexture(imageNamed: self.imageName);
    }
}