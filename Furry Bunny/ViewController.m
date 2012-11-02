//
//  ViewController.m
//  Furry Bunny
//
//  Created by Martin Knoll on 17.06.12.
//  Copyright (c) 2012 Otto-von-Guericke-Universität Magdeburg. All rights reserved.
//

#import "ViewController.h"
#import "bunny.h"
#import "SettingsViewController.h"

enum
{
  UNIFORM_MODELVIEWPROJECTION_MATRIX,
  UNIFORM_NORMAL_MATRIX,
  UNIFORM_TEXTURE0,
  UNIFORM_TEXTURE1,
  UNIFORM_HEIGHT,
  UNIFORM_DIFFUSE,
  UNIFORM_LIGHT_POSITION,
  NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

@interface ViewController () {
  GLuint _program;
  
  GLKMatrix4 _projectionMatrix;
  GLKMatrix4 _modelViewMatrix;
  GLKMatrix3 _normalMatrix;
  GLKMatrix4 _modelViewProjectionMatrix;
  float _rotation;
  
  GLuint _vertexArray;
  GLuint _vertexBuffer;
  CMAttitude * _attitude;
  NSInteger shells;
  float furLength;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) Bunny * bunny;
@property (strong, nonatomic) CMMotionManager * motionManager;
- (void) initGL;
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end


@implementation ViewController

//lazy property initializers
- (Bunny *)bunny
{
  if (_bunny == nil)
    _bunny = [[Bunny alloc] init];
  return _bunny;
}

- (CMMotionManager *)motionManager
{
  if (_motionManager == nil)
    _motionManager = [[CMMotionManager alloc] init];
  return _motionManager;
}

- (EAGLContext *)context
{
  if (_context == nil) {
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  }
  return _context;
}

// View and GL init stuff
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  GLKView * view = (GLKView *)self.view;
  view.context = self.context;
  view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
  view.drawableMultisample = GLKViewDrawableMultisample4X;
  view.delegate = self;
  self.preferredFramesPerSecond = 60;
  self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
  [self.motionManager startDeviceMotionUpdates];
  
  UIPanGestureRecognizer * pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(pan:)];
  [view addGestureRecognizer:pangr];
  
  [self initGL];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  [self.motionManager stopDeviceMotionUpdates];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void) initGL {
  
  [EAGLContext setCurrentContext:self.context];
  
  shells = 8;
  furLength = 0.04;
  self.effect = [[GLKBaseEffect alloc] init];
  self.effect.light0.enabled = GL_TRUE;
  self.effect.lightModelAmbientColor = (GLKVector4){0.5, 0.5, 0.5, 1.0};
  self.effect.texture2d0.envMode = GLKTextureEnvModeModulate;
  self.effect.texture2d0.target = GLKTextureTarget2D;
  self.effect.texture2d0.name = self.bunny.leopardTexture.name;
  self.effect.texture2d1.envMode = GLKTextureEnvModeModulate;
  self.effect.texture2d1.target = GLKTextureTarget2D;
  self.effect.texture2d1.name = self.bunny.noiseTexture.name;
  [self.effect prepareToDraw];
  float aspect = self.view.bounds.size.height / self.view.bounds.size.width;
  _projectionMatrix = GLKMatrix4MakeOrtho(-1, 1, -aspect, aspect, -1, 1);
  _modelViewMatrix = GLKMatrix4Identity;
  
  glEnable(GL_DEPTH_TEST);
  
  [self loadShaders];
}

// Render loop methods
- (void)update
{
  _attitude = self.motionManager.deviceMotion.attitude;
  CMRotationMatrix rotationMatrix = _attitude.rotationMatrix;
  
  GLKMatrix4 rotationMatrix4 = (GLKMatrix4){
    rotationMatrix.m11, rotationMatrix.m21, rotationMatrix.m31, 0,
    rotationMatrix.m12, rotationMatrix.m22, rotationMatrix.m32, 0,
    rotationMatrix.m13, rotationMatrix.m23, rotationMatrix.m33, 0,
    0, 0, 0, 1
  };
  rotationMatrix4 = GLKMatrix4RotateX(rotationMatrix4, M_PI / 2);
  
  GLKMatrix4 rotatedProjectionMatrix;
  if (self.motionManager.deviceMotionAvailable) {
    rotatedProjectionMatrix = GLKMatrix4Multiply(_projectionMatrix, rotationMatrix4);
  } else {
    rotatedProjectionMatrix = _projectionMatrix;
  }
  
  _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(_modelViewMatrix), NULL);
  _modelViewProjectionMatrix = GLKMatrix4Multiply(rotatedProjectionMatrix, _modelViewMatrix);
  self.effect.transform.modelviewMatrix = _modelViewMatrix;
  self.effect.transform.projectionMatrix = rotatedProjectionMatrix;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  glUseProgram(_program);
  glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
  glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
  glUniform1i(uniforms[UNIFORM_TEXTURE0], 0);
  glUniform1i(uniforms[UNIFORM_TEXTURE1], 1);
  glUniform1f(uniforms[UNIFORM_HEIGHT], (GLfloat)0.0);
  glUniform4f(uniforms[UNIFORM_DIFFUSE], 1, 1, 1, 1);
  glUniform4f(uniforms[UNIFORM_LIGHT_POSITION], 0, 0, 1, 0);
  [self.bunny prepare];
  [self.bunny draw];
  glEnable(GL_BLEND);
	glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  for (int i = 1; i <= shells; i++) {
    float shadow = 1.1 - (shells - i) * 0.05;
    glUniform4f(uniforms[UNIFORM_DIFFUSE], shadow, shadow, shadow, 1);
    glUniform1f(uniforms[UNIFORM_HEIGHT], (GLfloat)i * (furLength / shells));
    [self.bunny draw];
  }
  glDisable(GL_BLEND);
  glUseProgram(0);
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
  //  NSLog(@"in glkViewControllerUpdate");
}

// paning rotates the Bunny
- (void)pan:(UIPanGestureRecognizer *) recognizer
{
  if ((recognizer.state == UIGestureRecognizerStateChanged) ||
      (recognizer.state == UIGestureRecognizerStateEnded)) {
    CGPoint translation = [recognizer translationInView:self.view];
    [recognizer setTranslation:CGPointZero inView:self.view];
    GLKVector3 translationV = {translation.x, translation.y, 0};
    GLKMatrix4 rotationMatrix = GLKMatrix4RotateZ(GLKMatrix4Identity, _attitude.roll);
    translationV = GLKMatrix4MultiplyVector3(rotationMatrix, translationV);

    _modelViewMatrix = GLKMatrix4RotateY(_modelViewMatrix, translationV.x / 200.0);
  }
}

// Fur Changer

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  SettingsViewController * destination = segue.destinationViewController;
  destination.sender = self;
}

- (void)setZebra
{
  self.effect.texture2d0.name = self.bunny.zebraTexture.name;
  [self.effect prepareToDraw];
}

- (void)setLeopard
{
  self.effect.texture2d0.name = self.bunny.leopardTexture.name;
  [self.effect prepareToDraw];
}

- (void)setTiger
{
  self.effect.texture2d0.name = self.bunny.tigerTexture.name;
  [self.effect prepareToDraw];
}

- (void)changeShellsTo:(NSInteger)number
{
  shells = number;
}

- (void)changeFurLengthTo:(float)value
{
  furLength = value;
}

// modified Shader Loader from Xcode Template
- (BOOL)loadShaders
{
  GLuint vertShader, fragShader;
  NSString *vertShaderPathname, *fragShaderPathname;
  
  // Create shader program.
  _program = glCreateProgram();
  
  // Create and compile vertex shader.
  vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"fur" 
                                                       ofType:@"vsh"];
  if (![self compileShader:&vertShader 
                      type:GL_VERTEX_SHADER 
                      file:vertShaderPathname]) {
    NSLog(@"Failed to compile vertex shader");
    return NO;
  }
  
  // Create and compile fragment shader.
  fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"fur" 
                                                       ofType:@"fsh"];
  if (![self compileShader:&fragShader 
                      type:GL_FRAGMENT_SHADER 
                      file:fragShaderPathname]) {
    NSLog(@"Failed to compile fragment shader");
    return NO;
  }
  
  // Attach vertex shader to program.
  glAttachShader(_program, vertShader);
  
  // Attach fragment shader to program.
  glAttachShader(_program, fragShader);
  
  // Bind attribute locations.
  // This needs to be done prior to linking.
  glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
  glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
  glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "a_texCoord");
  
  // Link program.
  if (![self linkProgram:_program]) {
    NSLog(@"Failed to link program: %d", _program);
    
    if (vertShader) {
      glDeleteShader(vertShader);
      vertShader = 0;
    }
    if (fragShader) {
      glDeleteShader(fragShader);
      fragShader = 0;
    }
    if (_program) {
      glDeleteProgram(_program);
      _program = 0;
    }
    
    return NO;
  }
  
  // Get uniform locations.
  uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
  uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
  uniforms[UNIFORM_TEXTURE0] = glGetUniformLocation(_program, "texture0");
  uniforms[UNIFORM_TEXTURE1] = glGetUniformLocation(_program, "texture1");
  uniforms[UNIFORM_HEIGHT] = glGetUniformLocation(_program, "height");
  uniforms[UNIFORM_DIFFUSE] = glGetUniformLocation(_program, "diffuse");
  uniforms[UNIFORM_LIGHT_POSITION] = glGetUniformLocation(_program, "lightPosition");
  
  // Release vertex and fragment shaders.
  if (vertShader) {
    glDetachShader(_program, vertShader);
    glDeleteShader(vertShader);
  }
  if (fragShader) {
    glDetachShader(_program, fragShader);
    glDeleteShader(fragShader);
  }
  
  return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
  GLint status;
  const GLchar *source;
  
  source = (GLchar *)[[NSString stringWithContentsOfFile:file 
                                                encoding:NSUTF8StringEncoding 
                                                   error:nil] UTF8String];
  if (!source) {
    NSLog(@"Failed to load vertex shader");
    return NO;
  }
  
  *shader = glCreateShader(type);
  glShaderSource(*shader, 1, &source, NULL);
  glCompileShader(*shader);
  
#if defined(DEBUG)
  GLint logLength;
  glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetShaderInfoLog(*shader, logLength, &logLength, log);
    NSLog(@"Shader compile log:\n%s", log);
    free(log);
  }
#endif
  
  glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
  if (status == 0) {
    glDeleteShader(*shader);
    return NO;
  }
  
  return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
  GLint status;
  glLinkProgram(prog);
  
#if defined(DEBUG)
  GLint logLength;
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    NSLog(@"Program link log:\n%s", log);
    free(log);
  }
#endif
  
  glGetProgramiv(prog, GL_LINK_STATUS, &status);
  if (status == 0) {
    return NO;
  }
  
  return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
  GLint logLength, status;
  
  glValidateProgram(prog);
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    NSLog(@"Program validate log:\n%s", log);
    free(log);
  }
  
  glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
  if (status == 0) {
    return NO;
  }
  
  return YES;
}


@end
