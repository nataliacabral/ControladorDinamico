//
//  SliderSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SliderSoundObject : SoundObject
{
    override var gridHeight:CGFloat { get { return 3 } }
    override var gridWidth:CGFloat { get { return 1 } }
    override var imageName:String { get { return "slider.png" } }
    
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
        self.texture = self.sliderTrackTexture
    }
    
    override init(gridSize:CGFloat) {
        super.init(gridSize:gridSize)
        self.texture = self.sliderTrackTexture
    }
    
    func loadHandle()
    {
        self.removeAllChildren()
        self.sliderHandle = SliderHandle(texture: self.sliderHandleTexture)
        self.sliderHandle!.anchorPoint = CGPoint(x: 0, y: 0)

        self.sliderHandle!.size.width = 0
        self.sliderHandle!.size.height = 0
        self.sliderHandle!.position.x = 0;
        self.sliderHandle!.position.y = 0;

        self.addChild(self.sliderHandle!);
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
        self.sliderHandle!.position.y = self.size.height / 2
    }
}