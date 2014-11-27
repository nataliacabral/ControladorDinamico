//
//  SliderSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class SliderSoundObject : SoundObject, Touchable, ModulatorNode

{
    override var gridHeight:CGFloat { get { return 3 } }
    override var gridWidth:CGFloat { get { return 1 } }
    override var templateImageName:String { get { return "slider.png" } }

    var sliderHandle:SliderHandle?
    let sliderTrackTexture:SKTexture = SKTexture(imageNamed: "sliderTrack.png")
    
    let handlerWidthBorder:CGFloat = 3.5

    var modulators:Array<Modulator> = Array<Modulator>()

    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
        self.loadHandle()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.texture = self.sliderTrackTexture
        self.loadHandle()
    }
    
    override init(gridSize:CGFloat) {
        super.init(gridSize:gridSize)
        self.texture = self.sliderTrackTexture
    }
    
    override func startPhysicalBody() {
        for obj in self.children {
            let sliderObj:SliderHandle = obj as SliderHandle
            self.sliderHandle = sliderObj
       }
    }
        
    func loadHandle()
    {
        self.sliderHandle = nil
        self.removeAllChildren()
        if (self.sliderHandle == nil) {
            self.sliderHandle = SliderHandle()
            self.sliderHandle!.anchorPoint = CGPoint(x: 0, y: 0)

            self.sliderHandle!.size.width = 0
            self.sliderHandle!.size.height = 0
            self.sliderHandle!.position.x = 0;
            self.sliderHandle!.position.y = 0;

            self.addChild(self.sliderHandle!);
        }
    }
    
    override func updateGridSize(gridSize:CGFloat)
    {
        super.updateGridSize(gridSize)
        self.sliderHandle!.size.width = self.size.width - (self.handlerWidthBorder * 2)
        let ratio:CGFloat = self.sliderHandle!.texture!.size().width / self.sliderHandle!.size.width
        self.sliderHandle!.size.height = self.sliderHandle!.texture!.size().height / ratio
        self.sliderHandle!.position.x = self.handlerWidthBorder
        self.sliderHandle!.position.y = self.size.height / 2
    }

    override func currentSoundIntensity() -> Float
    {
        return self.sliderHandle!.currentSoundIntensity()
    }

    override func touchStarted(position:CGPoint)
    {
    }
    
    override func touchMoved(position:CGPoint)
    {
        self.sliderHandle!.touchMoved(position)
    }
    
    override func touchEnded(position:CGPoint)
    {
    }
    
    func setModule(module:Float)
    {
        for modulator in self.modulators {
            modulator.modulate(module)
        }
    }
    
    func addModulator(modulator:Modulator) {
        self.modulators.append(modulator)
    }
    
//    override func copy() -> AnyObject
//    {
//        var result:SliderSoundObject = SliderSoundObject(
//            texture:self.texture,
//            color:self.color,
//            size:self.size
//        )
//        result.sliderHandle = self.sliderHandle
//        result.sliderHandleTexture = self.sliderHandleTexture
//        result.sliderTrackTexture = self.sliderTrackTexture
//        result.position = self.position
//        return result
//    }
}