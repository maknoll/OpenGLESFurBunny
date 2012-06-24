//
//  Shader.fsh
//  OpenGLES
//
//  Created by Martin Knoll on 17.06.12.
//  Copyright (c) 2012 Otto-von-Guericke-Universität Magdeburg. All rights reserved.
//

varying highp vec4 colorVarying;
varying highp vec2 v_texCoord;
uniform sampler2D texture0;
uniform sampler2D texture1;

highp vec4 fur;
highp vec4 noise;

void main() {
  fur = texture2D(texture0, v_texCoord) * (colorVarying + 0.4);
  noise = texture2D(texture1, v_texCoord);
  gl_FragColor = vec4(fur.xyz, noise.x);
}