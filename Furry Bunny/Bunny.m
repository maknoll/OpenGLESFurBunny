//
//  Bunny.m
//  Furry Bunn
//
//  Created by Martin Knoll on 17.06.12.
//  Copyright (c) 2012 Otto-von-Guericke-Universität Magdeburg. All rights reserved.
//

#import "Bunny.h"
#import "bunny_blender.h"

@interface Bunny() {
  GLuint _vertexBuffer;
  GLuint _indexBuffer;
}
@end

@implementation Bunny

- (Bunny *)init
{
  glGenBuffers(1, &_vertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(MeshVertexData), &MeshVertexData[0].vertex, GL_STATIC_DRAW);
  
//  glGenBuffers(1, &_indexBuffer);
//  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
//  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(bunnyIndices), bunnyIndices, GL_STATIC_DRAW);
  return self;
}

- (void)prepare
{
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
  //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glEnableVertexAttribArray(GLKVertexAttribNormal);
  glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, (void *)0);
  glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 32, (void *)12);
  glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, (void *)24);
}

- (void)draw
{  
  glDrawArrays(GL_TRIANGLES, 0, sizeof(MeshVertexData) / 32);
  //glDrawElements(GL_TRIANGLES, sizeof(bunnyIndices) / sizeof(GLuint), GL_UNSIGNED_INT, (void *)0);
}

- (GLKTextureInfo *)leopardTexture
{
  if (_leopardTexture == nil) {
    NSError * error;
    NSString * texturePath = [[NSBundle mainBundle] pathForResource:@"fur" ofType:@"png"];
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderGenerateMipmaps, [NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
                              //[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderGenerateMipmaps];
    _leopardTexture = [GLKTextureLoader textureWithContentsOfFile:texturePath options:options error:&error];
    if (error) NSLog(@"%@", error);
  }
  return _leopardTexture;
}

- (GLKTextureInfo *)zebraTexture
{
  if (_zebraTexture == nil) {
    NSError * error;
    NSString * texturePath = [[NSBundle mainBundle] pathForResource:@"zebra" ofType:@"png"];
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderGenerateMipmaps, [NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
    //[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderGenerateMipmaps];
    _zebraTexture = [GLKTextureLoader textureWithContentsOfFile:texturePath options:options error:&error];
    if (error) NSLog(@"%@", error);
  }
  return _zebraTexture;
}

- (GLKTextureInfo *)tigerTexture
{
  if (_tigerTexture == nil) {
    NSError * error;
    NSString * texturePath = [[NSBundle mainBundle] pathForResource:@"tiger" ofType:@"png"];
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderGenerateMipmaps, [NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
    //[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderGenerateMipmaps];
    _tigerTexture = [GLKTextureLoader textureWithContentsOfFile:texturePath options:options error:&error];
    if (error) NSLog(@"%@", error);
  }
  return _tigerTexture;
}

- (GLKTextureInfo *)noiseTexture
{
  if (_noiseTexture == nil) {
    NSError * error;
    NSString * texturePath = [[NSBundle mainBundle] pathForResource:@"fur_noise" ofType:@"png"];
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderGenerateMipmaps, [NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
    //[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderGenerateMipmaps];
    _noiseTexture = [GLKTextureLoader textureWithContentsOfFile:texturePath options:options error:&error];
    if (error) NSLog(@"%@", error);
  }
  return _noiseTexture;
}

@end
