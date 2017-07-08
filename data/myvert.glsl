uniform mat4 transform;
uniform mat3 normalMatrix;
uniform mat4 modelviewInv;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;



varying vec3 pos;

void main() {
  vec4 p = (position * modelviewInv);
  pos = p.xyz/p.w;
  gl_Position = transform * position;
}
