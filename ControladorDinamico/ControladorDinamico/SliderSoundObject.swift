//
//  SliderSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SliderSoundObject : SoundObject, Pannable
{
    override var gridHeight:CGFloat { get { return 3 } }
    override var gridWidth:CGFloat { get { return 1 } }
    //override var imageName:String { get { return "slider.png" } }
    override var imageName:String { get { return "sliderTrack" } }
    
    var sliderHandleImageName:String { get { return "sliderHandle.png" } }
    var sliderTrackImageName:String { get { return "sliderTrack" } }

    var sliderHandle:SKSpriteNode?
    var sliderHandleTexture:SKTexture?
    var sliderTrackTexture:SKTexture?
    
    let handlerWidthBorder:CGFloat = 5
    let handlerHeightBorder:CGFloat = 10

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
    }
    
    override init(gridSize:CGFloat) {
        super.init(gridSize:gridSize)
    }
    
    func loadHandle()
    {
        self.removeAllChildren()
        self.sliderHandle = SKSpriteNode(texture: self.sliderHandleTexture)
        self.sliderHandle!.anchorPoint = CGPoint(x: 0, y: 0)

        self.sliderHandle!.size.width = 0
        self.sliderHandle!.size.height = 0
        self.sliderHandle!.position.x = 0;
        self.sliderHandle!.position.y = self.handlerHeightBorder;

        self.addChild(self.sliderHandle!);
    }
    
    func panStarted(position:CGPoint) {
        for obj in self.children {
            let node:SKSpriteNode = obj as SKSpriteNode
            node.position.y = position.y
        }
    }
    func panMoved(translation:CGPoint) {
        let maximumPos = self.size.height - handlerHeightBorder
        let minimumPos = handlerHeightBorder
        for obj in self.children {
            let node:SKSpriteNode = obj as SKSpriteNode
            node.position.y += translation.y
            if (node.position.y < minimumPos) {
                node.position.y = minimumPos
            }
            if (node.position.y + node.size.height > maximumPos){
                node.position.y = maximumPos - node.size.height
            }
        }
    }
    func panEnded() {
        
    }
    
    func loadTextures() {
        self.sliderHandleTexture = SKTexture(imageNamed: self.sliderHandleImageName);
        self.sliderTrackTexture = SKTexture(imageNamed: self.sliderTrackImageName);
    }
    
    override func updateGridSize(gridSize:CGFloat)
    {
        super.updateGridSize(gridSize)
        self.sliderHandle!.size.width = self.size.width - (self.handlerWidthBorder * 2)
        let ratio:CGFloat = self.sliderHandleTexture!.size().width / self.sliderHandle!.size.width
        self.sliderHandle!.size.height = self.sliderHandleTexture!.size().height / ratio
        self.sliderHandle!.position.x = self.handlerWidthBorder
    }
}