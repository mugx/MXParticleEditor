//
//  Shader.vsh
//  ProjectKyut
//
//  Created by mugx on 09/05/15.
//  Copyright (c) 2015 mugx. All rights reserved.
//

attribute vec4 positionAttribute;
attribute vec3 normalAttribute;
attribute vec2 textureCoordinatesAttribute;

//--- uniform ---//
uniform float lightPosition;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec3 ambientMaterial;
uniform vec3 specularMaterial;
uniform vec3 diffuseMaterial;
uniform vec3 colorMaterial;
uniform float shininessMaterial;
uniform float alpha;

//--- varying ---//
varying vec4 colorLightVertex;
varying vec4 colorMaterialVertex;
varying float alphaVertex;
varying vec2 textureCoordinatesVertex;

void main(void)
{
  vec3 N = normalize(normalMatrix * normalAttribute);
  vec3 L = normalize(vec3(0.0, 0, 10.0));
  vec3 E = normalize(vec3(0.0, 0, 10.0));
  vec3 H = normalize(L + E);
  float df = max(0.0, dot(N, L));
  float sf = max(0.0, dot(N, H));
  sf = pow(sf, shininessMaterial);
  
  colorLightVertex = vec4(ambientMaterial + sf * specularMaterial + df * diffuseMaterial, 1.0);
  colorMaterialVertex = vec4(colorMaterial, 1.0);
  alphaVertex = alpha;
  textureCoordinatesVertex = textureCoordinatesAttribute;
  gl_Position = modelViewProjectionMatrix * positionAttribute;
}
