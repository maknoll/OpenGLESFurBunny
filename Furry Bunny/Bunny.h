//
//  Bunny.h
//  Furry Bunny
//
//  Created by Martin Knoll on 17.06.12.
//  Copyright (c) 2012 Otto-von-Guericke-Universität Magdeburg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Bunny : NSObject
- (void)draw;
- (void)prepare;
@property (strong, nonatomic) GLKTextureInfo * leopardTexture;
@property (strong, nonatomic) GLKTextureInfo * zebraTexture;
@property (strong, nonatomic) GLKTextureInfo * tigerTexture;
@property (strong, nonatomic) GLKTextureInfo * noiseTexture;
@end
