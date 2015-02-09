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

struct SliderStatus
{
    var sliderPosition:CGFloat
}

class SliderSoundObject : SoundObject, Touchable, ModulatorNode

{
    override var gridHeight:CGFloat { get { return 3 } }
    override var gridWidth:CGFloat { get { return 1 } }

    var sliderHandle:SliderHandle?
    let sliderTrackTexture:SKTexture = SKTexture(imageNamed: "sliderTrack.png")
    let sliderEditTexture:SKTexture = SKTexture(imageNamed: "slider.png")

    let handlerWidthBorder:CGFloat = 3.5

    var modulators:Array<Modulator> = Array<Modulator>()
    
    var status:SliderStatus = SliderStatus(sliderPosition: CGFloat(0))
    var savedStatus : Array<SliderStatus> = Array<SliderStatus>(count: 4, repeatedValue: SliderStatus(sliderPosition: CGFloat(0)))

    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: sliderEditTexture, color: color, size: size)
        self.iconImageName = "slider_icon.png"
    }
    
    override init(gridSize:CGFloat) {
        super.init(gridSize:gridSize)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.savedStatus[0].sliderPosition = CGFloat(aDecoder.decodeFloatForKey("sliderPosition0"))
        self.savedStatus[1].sliderPosition = CGFloat(aDecoder.decodeFloatForKey("sliderPosition1"))
        self.savedStatus[2].sliderPosition = CGFloat(aDecoder.decodeFloatForKey("sliderPosition2"))
        self.savedStatus[3].sliderPosition = CGFloat(aDecoder.decodeFloatForKey("sliderPosition3"))
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeFloat(Float(self.savedStatus[0].sliderPosition), forKey: "sliderPosition0")
        aCoder.encodeFloat(Float(self.savedStatus[1].sliderPosition), forKey: "sliderPosition1")
        aCoder.encodeFloat(Float(self.savedStatus[2].sliderPosition), forKey: "sliderPosition2")
        aCoder.encodeFloat(Float(self.savedStatus[3].sliderPosition), forKey: "sliderPosition3")
    }
        
    func loadHandle()
    {
        self.sliderHandle = nil
        self.removeAllChildren()
        if (self.sliderHandle == nil) {
            self.sliderHandle = SliderHandle()

            self.sliderHandle!.size.width = self.size.width - (self.handlerWidthBorder * 2)
            let ratio:CGFloat = self.sliderHandle!.texture!.size().width / self.sliderHandle!.size.width
            self.sliderHandle!.size.height = self.sliderHandle!.texture!.size().height / ratio
            self.sliderHandle!.position.x = 0;
            self.sliderHandle!.position.y = 0;

            self.addChild(self.sliderHandle!);
        }
    }

    override func currentSoundIntensity() -> Float
    {
        return self.sliderHandle!.currentSoundIntensity()
    }

    override func touchStarted(position:CGPoint)
    {
        self.sliderHandle!.touchStarted(position)
    }
    
    override func touchMoved(position:CGPoint)
    {
        self.sliderHandle!.touchMoved(position)
    }
    
    override func touchEnded(position:CGPoint)
    {
        self.sliderHandle!.touchEnded(position)
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
    
    override func playObject() -> SoundObject
    {
        var result:SliderSoundObject = SliderSoundObject(
            texture:self.texture,
            color:self.color,
            size:self.size
        )
        result.texture = sliderTrackTexture
        result.position = self.position
        result.loadHandle()
        result.savedStatus = self.savedStatus

        return result
    }
    
    override func saveStatus(slot:Int)
    {
        self.status.sliderPosition = self.sliderHandle!.position.y
        self.savedStatus[slot] = self.status;
    }
    
    override func loadStatus(slot:Int)
    {
        self.status = self.savedStatus[slot];
        self.sliderHandle!.position.y = self.status.sliderPosition
    }
}