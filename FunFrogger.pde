int Level = 1;                  //control the game ...level inc from 1 to n 
float bandHeight;
float X ;                       //controls the x position of the frog
float Y;                       //controls the y position of the frog
float offset=0;                 //to move the hazards
float alterOffset=0.75;         // moving the hazards at an increased speed
float diameter;                 //size of the frog
String Message ;                //text displayed on the screen
boolean gameover=false;         
void setup() {
  fullScreen();
  bandHeight=height/(Level+4) ;            //size of each band 
  X=width/2;                                //initial x pos of frog
  Y=bandHeight*(Level+3)+(bandHeight/2);    //initial y pos of frog
}


void draw() {
clear();
  bandHeight = height/(Level+4);   // height of each band
  diameter = bandHeight/3;          //size of frog 
  drawWorld();                     //the background with different bands
  drawFrog(X, Y, diameter);        //green frog
  if (!drawHazards()) {             // if there is no collision do the follwing   
    drawFrog(X, Y, diameter);
    offset = (offset+alterOffset)%bandHeight;                   //changing speed
    Message = "Level "+ Level;
  } else {                        //if a collision occurs between a frog and any hazard then...
    gameover =true;                 //make bool gameover true so keys stop functioning in key pressed()
    Message = "Game is over";      
                   
  }
  displayMessage(Message);
}


void drawWorld() {
  for (int i = 0; i < Level+4; i++) {      // draw level+4 number of bands 
    if (i==0 || i==((Level+4)-1)) {
      fill(120, 150, 186);                 //colour for the top and bottom bands
    } else {
      fill(0);                          //colour for the middle bands (level+2) bands
    }
    noStroke();                       //no lines separating the bands
    rect(0, i*bandHeight, width, bandHeight);
  }
}

void drawFrog(float x, float y, float diam) {
  
  float legsize= diam/2;
  float distD = 0.5* diam;
  float theta =QUARTER_PI;
  fill(0, 100, 0);
  ellipse(x+(distD*cos(theta)), y-(distD*sin(theta)), legsize, legsize);       
  ellipse(x-(distD*cos(theta)), y-(distD*sin(theta)), legsize, legsize);       //front limbs
  theta =-QUARTER_PI;
  fill(0, 100, 0);
  ellipse(x+(distD*cos(theta)), y-(distD*sin(theta)), legsize, legsize);
  ellipse(x-(distD*cos(theta)), y-(distD*sin(theta)), legsize, legsize);       //back limbs
  theta =HALF_PI; 
  fill(0, 200, 0);
  ellipse(x+(distD*cos(theta)), y-(distD*sin(theta)), legsize, legsize);      //frog head
  fill(0, 255, 0);
  ellipse(x, y, diam, diam);                                                  //frog body
} 


void moveFrog(float xChange, float yChange) {

  if (objectInCanvas(X+xChange, Y+yChange, diameter)) {// checking if object is in the screen
    X=X+xChange;     //change the x position by bandheight either +ve or -ve
    Y=Y+yChange;     //change the y position by bandheight either +ve or -ve   depending on the key pressed
  }
  if (detectWin()) {    //if frog reaches the top band 
    X=width/2;                                //return back to the initial position 
    Y=bandHeight*(Level+3)+(bandHeight/2);
    Level++;                                //add level plus 1
  }
}

boolean objectInCanvas(float x, float y, float diam) {
  boolean  inCanvas = true;           //if object within the canvas
  diam = diam/2;                       
  if (x<-diam || x>width+diam || y<-diam || y>height+diam) {  //check x and y pos of frog
    inCanvas = false;                            //change bool to false if any condition is met
  }
  return inCanvas;
}
 


void keyPressed() { 
  
  float yCha= 0;                      //by how much y will change and in which direction depending on key and sign 
  float xCha= 0;                      //by how much x will change and in which direction depending on key and sign 
  if(!gameover) {                          //until there is no collision, the keys below can be used
  if (key=='W'||key == 'w' || key=='I' || key=='i') {
    yCha = - bandHeight;       //move towards the top
  }
  if (key=='S' ||key == 's' || key=='K' || key=='k') {
    yCha =  bandHeight;        //move towards the bottom
  }
  if (key=='d' ||key == 'D'|| key=='L' || key=='l') {
    xCha =  bandHeight;       //move right
  }
  if (key=='A' ||key == 'a'|| key=='J' || key=='j') {
    xCha = - bandHeight;       //move left
  }

  moveFrog(xCha, yCha);       //xcha and ycha gives the values to the func movefrog   
}
}


boolean drawHazard(int type, float x, float y, float size) {   //boolean function to return either true orr false 
  //accepts type of shape x and y pos and size of shape
 if (type==0) {      //particular shape
    fill(200, 55, 150);                              //colour
    ellipse(x, y, size, size);                     //shape
  } else if (type==1) { //particular shape 2
    fill(155, 90, 40); 
    rect(x-(size/2), y-(size/2), size, size );
  } else if (type==2) {  //particular shape 3
    fill(195, 10, 15); 
    ellipse(x, y, 1.5*size, size);
  }
if (objectsOverlap( x, y, X, Y, size, diameter)) {   //where X,Y and Diameter belong to the frog 
     return true;
  }
  return false;
}


boolean drawHazards() {    //boolean function to return either true orr false
  boolean result = false;
  for (int line=0; line<Level+2; line++) {
    float lineSpacing = (line+3)*bandHeight;
    float lineOffset = (line+3)*offset;
    if (line%2==0)
      lineOffset = lineSpacing-lineOffset;

    float x = -lineSpacing + lineOffset;
    float y = height-(line+1.5)*bandHeight;
    float size=0.5*bandHeight;
    do {

      if (drawHazard(line%3, x, y, size)) {
        result =true;
      }

      x += lineSpacing;
    } while (objectInCanvas(x, y, size));
  }
  return result;
}

void displayMessage(String m) {

  fill(0);
  textSize(bandHeight/3);
  textAlign(CENTER);                  //keeping the text at the centre 
  text( m, width/2, bandHeight/2  );   
}

boolean detectWin() {    //to move to next level if the boolean is true
  boolean Win = false;
  if (Y<=bandHeight) {
    Win =true;
  } 
  return Win;
}

boolean objectsOverlap(float x1, float y1, float x2, float 
  y2, float size1, float size2) {       //to end the game incase a frog and any hazard collide

  boolean cover = false;
  float spacex = x1 -x2;                             //distance btwn 2 x cords
  float spacey = y1 -y2;                             //distance btwn 2 y cords
  float space = sqrt(sq(spacex)+sq(spacey));         //distance between 2 shapes 
  if (space<(size1+size2)/2) {      
    cover = true;
  }
  return cover;
}
