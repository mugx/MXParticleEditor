//
//  Shader.fsh
//  ProjectKyut
//
//  Created by mugx on 09/05/15.
//  Copyright (c) 2015 mugx. All rights reserved.
//

//--- uniform ---//
uniform sampler2D Texture;

//--- varying ---//
varying vec4 colorMaterialVertex;
varying vec4 colorLightVertex;
varying float alphaVertex;
varying vec2 textureCoordinatesVertex;

void main()
{
  gl_FragColor = (colorMaterialVertex + colorLightVertex) * texture2D(Texture, textureCoordinatesVertex) * alphaVertex;
}