
//这是导入两个包，这俩包让你能用ARDUINO通信和Video加载功能，*的意思是导入这个包的全部功能

import processing.serial.*;
import processing.video.*;

//这句是说我有一个叫movie的Moive类型东西

Movie movie; 
int bgcolor;   
int fgcolor;
Serial myPort;                      
int[] serialInArray = new int[3];    
int serialCount = 0;                
int xpos, ypos;                 
boolean firstContact = false;  
     
//下面这句 我先定义触发我video的开关的初始状态是FALSE

boolean toggle=false;
void setup() {
  size(800, 600);  // Stage size
  noStroke();      // No border on the next thing drawn

//小球的初始位置是中间
  xpos = width/2;
  ypos = height/2;


  println(Serial.list());

//这句是找到Serial,也就是你ARDUINO开放的数据发送的端口的设备的列表LIST 中的第四个
//第四个是因为打印出来你的设备列表 你的ARDUINO 是正数第四

  String portName = Serial.list()[4];
  
 //定义port我也不知道为啥 反正定义出来 就可以收数据了
 
  myPort = new Serial(this, portName, 9600);
  
  //定义movie(这部分涉及“类”的问题)，有空再讲，总之就是创建一个物体
  
  movie = new Movie(this, "angry.mov"); 
	
  //定义movie是一直loop状态
  
  movie.loop();
}
//这部分我也不清楚 但是不可缺少 他是movie被读取的功能
void movieEvent(Movie movie) {
  movie.read();
}
//无限循环的画图部分

void draw() {

//我先画个背景，颜色是BGCOLOR，好像没定义 ，你可以定义；

  background(bgcolor);
//我设定以下图形的颜色填充是255,0,0
  fill(255,0,0);
  
//我再画个圆，xpos,ypos是arduino传过来的，是最下面的function做到的
  ellipse(xpos, ypos, 20, 20);
  //如果xpos 比这个小 比这个大 那么toggle 就变成真
  if(xpos>95&xpos<200){
  toggle=true;
  }
  
 //如果为真 那么就画出来MOVIE
  if(toggle==true){
  image(movie,0,0);
  }
}
//这部分使得你xpos 是arduino传过来的数据
void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller. 
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    if (inByte == 'A') { 
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    } 
  } 
  else {
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte;
    serialCount++;

    // If we have 3 bytes:
    if (serialCount > 2 ) {
      xpos = serialInArray[0];
      ypos = serialInArray[1];
      fgcolor = serialInArray[2];

      // print the values (for debugging purposes only):
      println(xpos + "\t" + ypos + "\t" + fgcolor);

      // Send a capital A to request new sensor readings:
      myPort.write('A');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}
