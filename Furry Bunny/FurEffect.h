//
//  Furshader.h
//  Furry Bunny
//
//  Created by Martin Knoll on 23.06.12.
//  Copyright (c) 2012 Otto-von-Guericke-Universität Magdeburg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface FurEffect : NSObject <GLKNamedEffect>
@property (strong, nonatomic) GLKEffectPropertyTransform * transform;
@property (strong, nonatomic) GLKEffectPropertyLight * light0;
@property (strong, nonatomic) GLKEffectPropertyTexture * texture2d0;
@property (strong, nonatomic) GLKEffectPropertyTexture * texture2d1;
@property (nonatomic) float height;

@end
