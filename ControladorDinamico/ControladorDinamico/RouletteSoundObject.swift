//
//  RouletteSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class RouletteSoundObject : SoundObject
{
    override var gridHeight:CGFloat { get { return 2 } }
    override var gridWidth:CGFloat { get { return 2 } }
    override var imageName:String { get { return "roulette.png" } }
    
    var rouletteSpinImageName:String { get { return "roulette_spinningpart.png" } }
    var rouletteBackgroundImageName:String { get { return "roulette_background.png" } }
    
    var rouletteSpin:RouletteSpin?
    var rouletteSpinTexture:SKTexture?
    var rouletteBackgroundTexture:SKTexture?
    
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
        self.loadTextures()
        self.loadHandle()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.texture = self.rouletteBackgroundTexture
    }
    
    override init(gridSize:CGFloat) {
        super.init(gridSize:gridSize)
        self.texture = self.rouletteBackgroundTexture
    }
    
    override func startPhysicalBody() {
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin:CGPoint(x:0,y:0), size:self.size))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.dynamic = false
        self.physicsBody?.mass = 5000
        self.physicsBody?.restitution = 0
        
        for obj in self.children {
            let sliderObj:RouletteSpin = obj as RouletteSpin
            sliderObj.physicsBody = SKPhysicsBody(rectangleOfSize: sliderObj.size,
                center:CGPoint(x:sliderObj.size.width / 2 , y:sliderObj.size.height / 2))
            sliderObj.physicsBody?.categoryBitMask = (1 << 3)
            sliderObj.physicsBody?.contactTestBitMask = 0
            sliderObj.physicsBody?.collisionBitMask = 0
            sliderObj.physicsBody?.dynamic = true
            sliderObj.physicsBody?.mass = 1
            sliderObj.physicsBody?.allowsRotation = true
            sliderObj.physicsBody?.friction = 0.9
            sliderObj.physicsBody?.restitution = 0
            sliderObj.physicsBody?.linearDamping = 0.9
            sliderObj.physicsBody?.angularDamping = 0.9

        }
    }
    
    func loadHandle()
    {
        self.removeAllChildren()
        self.rouletteSpin = RouletteSpin(texture: self.rouletteSpinTexture)
        self.rouletteSpin!.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.rouletteSpin!.size.width = 0
        self.rouletteSpin!.size.height = 0
        self.rouletteSpin!.position.x = 0;
        self.rouletteSpin!.position.y = 0;
        
        self.addChild(self.rouletteSpin!);
    }
    
    func loadTextures() {
        self.rouletteSpinTexture = SKTexture(imageNamed: self.rouletteSpinImageName);
        self.rouletteBackgroundTexture = SKTexture(imageNamed: self.rouletteBackgroundImageName);
    }
    
    override func updateGridSize(gridSize:CGFloat)
    {
        super.updateGridSize(gridSize)
        self.rouletteSpin!.size.width = self.size.width
        self.rouletteSpin!.size.height = self.size.height
        self.rouletteSpin!.position.x = 0
        self.rouletteSpin!.position.y = 0
    }

}