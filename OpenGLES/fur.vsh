//
//  Shader.vsh
//  bla
//
//  Created by Martin Knoll on 16.06.12.
//  Copyright (c) 2012 Otto-von-Guericke-Universität Magdeburg. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 a_texCoord;

varying highp vec4 colorVarying;
varying highp vec2 v_texCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec4 lightPosition;
uniform float height;
uniform vec4 diffuse;

void main()
{
  vec3 eyeNormal = normalize(normalMatrix * normal);
  
  float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition.xyz)));
  
  colorVarying = diffuse * nDotVP;
  v_texCoord = a_texCoord;
  
  vec3 position3 = position.xyz + normal * height;
  
  gl_Position = modelViewProjectionMatrix * vec4(position3, 1.0);
}
