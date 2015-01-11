//
//  HorizontalSliderSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 1/11/15.
//  Copyright (c) 2015 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

struct HorizontalSliderStatus
{
    var sliderPosition:CGFloat
}

class HorizontalSliderSoundObject : SoundObject, Touchable, ModulatorNode
    
{
    override var gridHeight:CGFloat { get { return 1 } }
    override var gridWidth:CGFloat { get { return 3 } }
    
    var sliderHandle:HorizontalSliderHandle?
    let sliderTrackTexture:SKTexture = SKTexture(imageNamed: "slider_horizontal_track.png")
    let sliderEditTexture:SKTexture = SKTexture(imageNamed: "slider_horizontal.png")
    
    let handlerWidthBorder:CGFloat = 3.5
    
    var modulators:Array<Modulator> = Array<Modulator>()
    
    var status:HorizontalSliderStatus = HorizontalSliderStatus(sliderPosition: CGFloat(0))
    var savedStatus : Array<HorizontalSliderStatus> = Array<HorizontalSliderStatus>(count: 4, repeatedValue: HorizontalSliderStatus(sliderPosition: CGFloat(0)))
    
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: sliderEditTexture, color: color, size: size)
        self.iconImageName = "slider_horizontal_icon.png"
    }

    override init(gridSize:CGFloat) {
        super.init(gridSize:gridSize)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadHandle()
    {
        self.sliderHandle = nil
        self.removeAllChildren()
        if (self.sliderHandle == nil) {
            self.sliderHandle = HorizontalSliderHandle()
            self.sliderHandle!.size.height = self.size.height - (self.handlerWidthBorder * 2)
            let ratio:CGFloat = self.sliderHandle!.texture!.size().height / self.sliderHandle!.size.height
            self.sliderHandle!.size.width = self.sliderHandle!.texture!.size().width / ratio
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
        var result:HorizontalSliderSoundObject = HorizontalSliderSoundObject(
            texture:self.texture,
            color:self.color,
            size:self.size
        )
        result.texture = sliderTrackTexture
        result.position = self.position
        result.loadHandle()
        
        return result
    }
    
    override func saveStatus(slot:Int)
    {
        self.status.sliderPosition = self.sliderHandle!.position.x
        self.savedStatus[slot] = self.status;
    }
    
    override func loadStatus(slot:Int)
    {
        self.status = self.savedStatus[slot];
        self.sliderHandle!.position.x = self.status.sliderPosition
    }
}