/*
polar in 3d :
x = r * sin(theta) * cos(phi)
y = r * sin(theta) * sin(phi)
z = r * cos(theta)

where theta is angle of latitude
and phi angle of longitude

*/

import peasy.*;
PVector[][] globe;
int total = 25;
float r = 200;
//float a, b, m, n1, n2, n3;
PShader myShader;

PeasyCam cam;


void setup() {
  colorMode(HSB, 100, 100, 100);
  size(600,600, P3D);
  //camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  cam = new PeasyCam(this, 200);
  globe = new PVector[total + 1][total + 1];
  myShader = loadShader("myfrag.glsl", "myvert.glsl");
  //noStroke();
  strokeWeight(5);
}

float makeSuperShape(float theta, float n1, float n2, float n3, float m) {
  float a = 1, b = 1;
  float p1 = pow( abs((1/a)*cos(m*theta/4)),n2);
  float p2 = pow( abs((1/b)*sin(m*theta/4)),n3);
  return pow(p1+p2, -1/n1);
}

void makeSphere() {
  for(int i=0; i< total+1; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = makeSuperShape(lat, 3.9, 58.9, 67.3, 1.3);
    
    for(int j=0; j< total+1; j++) {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = makeSuperShape(lon, 9.9, 53.0, 38.8, 29.8);
      
      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 * cos(lat);
      float z = r * r2 * sin(lat);
      
      globe[i][j] = new PVector(x,y,z); 
    }
  }
  //r += noise(frameCount*0.1)*2 - 1;
}

void draw() {
  //camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  
  shader(myShader);
  myShader.set("modelviewInv", ((PGraphicsOpenGL) g).modelviewInv);
  //myShader.set("u_time", frameCount*0.1);
  background(0);
  //translate(width/2, height/2); // peasy handles translation
  lights();
  

  
  makeSphere();
  
  for(int i=0; i < total; i++) {
    //noFill();
    //stroke(100,0,100);
    
    beginShape(TRIANGLE_STRIP);
    
    for(int j=0; j < total + 1; j++) {
      fill(map(j, 0, total, 0, 100), 100, 100);
      PVector v1 = globe[i][j];
      PVector v2 = globe[i+1][j];
      vertex(v1.x, v1.y, v1.z);
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
  resetShader();
}