//screen dimensions
int screenHeight, screenWidth;

//drum machine parameters
int numberOfBeats;
int numberOfTracks;
int playHeadPosition;
int bpm;
boolean[] bTom1,bTom2,bTom3,bHiHat,bSnare,bKick;
boolean[] reference;

//audio variables
Maxim maxim;
AudioPlayer aTom1,aTom2,aTom3,aHiHat,aSnare,aKick;

//button variables
int xOffset,yOffset,buttonRadius,padding;
int x,y;

//background
PImage backgroundImage; 

//spider variables
PImage spiderImage,spiderImage1,spiderImage2; 
float spiderX,spiderY,incrX,incrY;
int spiderRadius;
int time;
int speed;
boolean reached=true;
int randomTrack;
int randomBeat;
int destX,destY;
int restTime,restTimer;
float spiderAngle;
int changeImageTime,changeImageTimer;
boolean image1=true;

void setup()
{
  //setup screen dimensions
  screenHeight=500;
  screenWidth=800;
  size(screenWidth,screenHeight);
  
  //setup drum machine parameters
  numberOfBeats=16;
  numberOfTracks=6;
  bpm=100;
  playHeadPosition=0;
  
  //setup audio variables
  maxim=new Maxim(this);
  aTom1=maxim.loadFile("tom1.wav");
  aTom1.setLooping(false);
  aTom2=maxim.loadFile("tom2.wav");
  aTom2.setLooping(false);
  aTom3=maxim.loadFile("tom3.wav");
  aTom3.volume(5);
  aTom3.setLooping(false);
  aHiHat=maxim.loadFile("hi-hat.wav");
  aHiHat.setLooping(false);
  aSnare=maxim.loadFile("snare.wav");
  aSnare.setLooping(false);
  aKick=maxim.loadFile("kick.wav");
  aKick.setLooping(false);
  
  bTom1=new boolean[numberOfBeats];
  bTom2=new boolean[numberOfBeats];
  bTom3=new boolean[numberOfBeats];
  bHiHat=new boolean[numberOfBeats];
  bSnare=new boolean[numberOfBeats];
  bKick=new boolean[numberOfBeats];
  reference=null;
  
  //setup button dimensions
  xOffset=175+15;
  yOffset=50+15;
  buttonRadius=30;
  padding=5;
  
  //setup background image
  backgroundImage = loadImage("background.png");
    
  //spider variables
  spiderImage1=loadImage("spider1.png");
  spiderImage2=loadImage("spider2.png");
  spiderImage=spiderImage1;
  spiderX=0;
  spiderY=0;  
  time=60;
  restTime=60;
  restTimer=0;
  spiderRadius=40;
  changeImageTime=10;
  changeImageTimer=0;
  
  frameRate(30);
  noStroke();
  imageMode(CENTER);
}

void draw()
{
  //draw background
  //background(255,255,255);
  image(backgroundImage, width/2, height/2);
  //draw buttons
  drawButtons();
  if(frameCount%numberOfTracks==0)
  {
    //play beats
    playBeats();
    //update playhead position
    playHeadPosition++;
    if(playHeadPosition==numberOfBeats)
    {
      playHeadPosition=0;
    }
  }
  drawSpider();
}
void drawButtons()
{
  rectMode(CENTER);  
  y=yOffset;
  for(int i=0;i<numberOfTracks;i++)
  {
    switch(i)
    {
      case 0 : reference=bTom1;
      break;
      case 1 : reference=bTom2;
      break;
      case 2 : reference=bTom3;
      break;
      case 3 : reference=bHiHat;
      break;
      case 4 : reference=bSnare;
      break;
      case 5 : reference=bKick;
      break;
    }
    x=xOffset;
    for(int j=0;j<numberOfBeats;j++)
    { 
      if(reference[j])
      {
        fill(0,0,0,150);
        ellipse(x,y,buttonRadius-20,buttonRadius-20);
      }
      x+=(buttonRadius+padding);
    }
    y+=(buttonRadius+padding);
  }
  fill(255,255,255,150);
  rect(xOffset+playHeadPosition*(buttonRadius+padding),y+15,15,10);
}
void playBeats()
{
  if(bTom1[playHeadPosition])
  {
    aTom1.cue(0);
    aTom1.play();
  }
  if(bTom2[playHeadPosition])
  {
    aTom2.cue(0);
    aTom2.play();
  }
  if(bTom3[playHeadPosition])
  {
    aTom3.cue(0);
    aTom3.play();
  }
  if(bHiHat[playHeadPosition])
  {
    aHiHat.cue(0);
    aHiHat.play();
  }
  if(bSnare[playHeadPosition])
  {
    aSnare.cue(0);
    aSnare.play();
  }
  if(bKick[playHeadPosition])
  {
    aKick.cue(0);
    aKick.play();
  }
}
void mousePressed()
{
  print("Click");
  y=yOffset;
  for(int i=0;i<numberOfTracks;i++)
  {
    switch(i)
    {
      case 0 : reference=bTom1;
      break;
      case 1 : reference=bTom2;
      break;
      case 2 : reference=bTom3;
      break;
      case 3 : reference=bHiHat;
      break;
      case 4 : reference=bSnare;
      break;
      case 5 : reference=bKick;
      break;
    }
    x=xOffset;
    for(int j=0;j<numberOfBeats;j++)
    { 
      if(overCircle(x,y,buttonRadius))
      {
        print("Overcircle");
        reference[j]=!reference[j];
      }
      x+=(buttonRadius+padding);
    }
    y+=(buttonRadius+padding);
  }
}
boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

void drawSpider()
{
  if(reached)
  {
    //print("reached");
    restTimer++;
    if(restTimer==restTime)
    {
      calculateNewLocation();      
      restTimer=0;
    }
  }
  else
  {
    spiderX=spiderX+incrX;
    spiderY=spiderY+incrY;
    if((spiderX-destX<=1&&spiderX-destX>=-1)&&(spiderY-destY<=1&&spiderY-destY>=-1))
    {
      reached=true;    
      //toggle
      switch(randomTrack)
      {
        case 0 : reference=bTom1;
        break;
        case 1 : reference=bTom2;
        break;
        case 2 : reference=bTom3;
        break;
        case 3 : reference=bHiHat;
        break;
        case 4 : reference=bSnare;
        break;
        case 5 : reference=bKick;
        break;
      }
      reference[randomBeat]=!reference[randomBeat];
    }
  }
  fill(255,255,255);
  //ellipse(spiderX,spiderY,spiderRadius,spiderRadius);
  pushMatrix();  
  translate(spiderX,spiderY);
  rotate(spiderAngle);
  if(!reached)
    changeImageTimer++;
  if(changeImageTimer==changeImageTime)
  {
    if(image1)
    {
      spiderImage=spiderImage1;      
    }
    else
    {    
      spiderImage=spiderImage2;
    }
    image1=!image1;
    changeImageTimer=0;
  }
  image(spiderImage,0,0);
  popMatrix();
}
void calculateNewLocation()
{
  //print("Location set");
  randomTrack=(int)random(6);
  randomBeat=(int)random(16);
  destX=xOffset+randomBeat*(buttonRadius+padding);
  destY=yOffset+randomTrack*(buttonRadius+padding);
  incrX=(destX-spiderX)/time;
  incrY=(destY-spiderY)/time;
  spiderAngle=atan((destY-spiderY)/(destX-spiderX));
  if(destX-spiderX<0)
  {
    spiderAngle-=PI;
  }
  reached=false;
  //print("\n",spiderX,spiderY,incrX,incrY,destX,destY);
}
