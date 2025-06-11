
import processing.serial.*;
PShape objModel;
PShape objModel2;
int estado=0;
color cor;
PImage flor;
PImage flor2;
int numFlores = 15;
float[] x2 = new float[numFlores];
float[] y2 = new float[numFlores];
float[] speed = new float[numFlores];
float[] floatOffset = new float[numFlores];

boolean ratohover=true;
float rotposicao=0;
float rotvel=TWO_PI/50;
int xmodelo, ymodelo;
int tamanhomodelo=200;
Serial myPort;
PFont minhaFonte;
PImage verdantia;
PImage fundo;
PImage tab;
PImage tab2;
String sensorValue = "";
boolean intro = true;
boolean fundos = false;
boolean rodar=false;
int linespacing = 50;
int l;
int alturasensordeluz = 75;
int alturasensordehumidadeAr = 275;
int alturasensordetemperatura = 475;
int alturasensordehumidade = 675;

int espaço;
int x, y;

String data="";
String[] results;

float temp=0;
float humAr=0;
float humSolo=0;
float luz=0;

void setup() {
  size(1200, 750, P3D);
  noStroke();
  background(#F4F5F0);
  objModel = loadShape("fada.obj");
  objModel2 = loadShape("lilFairy.obj");
  hint(ENABLE_DEPTH_SORT);
  minhaFonte = createFont("Calder.ttf", 30); 
  textFont(minhaFonte);  
  espaço= 110;
  tamanhomodelo=300;
  fill(50);
  l = width / 2 ;
  textAlign(LEFT, CENTER);
  x = width / 2;
  y = height / 2;
  xmodelo=250;
  ymodelo= height-100;
  flor = loadImage("folhas.png");
  flor2 = loadImage("flower2.png");
  verdantia= loadImage("verdantia.png");
  fundo = loadImage("fundo.png");
  tab = loadImage("tab.png");
  tab2 = loadImage("tab2.png");
  cor= color(0);
  // Coloca o teu PNG na pasta "data"
  for (int i = 0; i < numFlores; i++) {
    x2[i] = random(width);
    y2[i] = random(height);
    speed[i] = random(0.5, 2);
    floatOffset[i] = random(TWO_PI);
  }
  println(Serial.list());
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  myPort.clear();
}

void draw() {
  background(#F4F5F0);
  if(data!=""){
    results=split(data,',');
    humAr=float(results[0]);
    temp=float(results[1]);
    humSolo=float(results[2]);
    luz=float(results[3]);
  }

  if (estado==0) {
    if (fundos) {
      imageMode(CENTER);
      image(fundo, x, y);
    }
    if (mouseX > 0 && mouseX < width && mouseY > y && mouseY < height) {
      fundos=true;
    } else {
      fundos=false;
    }

    imageMode(CENTER);
    image(verdantia, x, y+13);

    textFont(minhaFonte, 25);  
    fill(0);
    textAlign(CENTER, CENTER);
    text("Clique na imagem para começar", width / 2, height - 80);
  } 
  else if(estado==1){
    if (ratohover) {
      if (mouseX > width/2-tamanhomodelo/2 &&
        mouseX < width/2 + tamanhomodelo/2 &&
        mouseY > height/2-tamanhomodelo-200 &&
        mouseY < height/2 + tamanhomodelo/2) {
        //rotposicao = map(mouseX, xmodelo + tamanhomodelo/2, width, -TWO_PI, TWO_PI);  // roda suavemente
        rotposicao+=rotvel;
      }
    }
    for (int i = 0; i < numFlores; i++) {
    //imagens a flutuar
      float yFloat = y2[i] + sin(frameCount * 0.03 + floatOffset[i]) * 10;
      hint(DISABLE_DEPTH_MASK);
      image(flor2, x2[i], yFloat, 384, 216); 
      x2[i] += speed[i];
      hint(ENABLE_DEPTH_MASK);
      if (x2[i] > width + 50) {
        x2[i] = -50;
        y2[i] = random(height);
      }
    }

    // Luzes
    ambientLight(150, 150, 150);
    directionalLight(255, 255, 255, -1, -1, -1);
    pushMatrix();
    translate(width/2, height-100);
    rotateZ(PI);
    rotateY(rotposicao);
    scale(tamanhomodelo);
    shape(objModel, 0, 0);
    popMatrix();
    textFont(minhaFonte); 
    textAlign(LEFT, LEFT);
    
    imageMode(CENTER);
    tab2.resize(300, 120);
    image(tab2, width/2-350, height/2);
    image(tab2, width/2+350, height/2);
    textFont(minhaFonte); 
    textAlign(LEFT, LEFT);
    fill(0);
    textSize(20);
    text("PLANT STATS",width/2-350-100, height/2+10);
    text("WATERING SYSTEM", width/2+350-100, height/2+10);
    
    
  }
  
  
  else if(estado==2) {
    // Página dos sensores

    if (ratohover) {
      if (mouseX > xmodelo-tamanhomodelo/2 &&
        mouseX < xmodelo + tamanhomodelo/2 &&
        mouseY > ymodelo-tamanhomodelo-200 &&
        mouseY < ymodelo + tamanhomodelo/2) {
        //rotposicao = map(mouseX, xmodelo + tamanhomodelo/2, width, -TWO_PI, TWO_PI);  // roda suavemente
        rotposicao+=rotvel;
      }
    }
    for (int i = 0; i < numFlores; i++) {
   //imagens a flutuar
      float yFloat = y2[i] + sin(frameCount * 0.03 + floatOffset[i]) * 10;
      hint(DISABLE_DEPTH_MASK);
      image(flor, x2[i], yFloat, 384, 216); 
      x2[i] += speed[i];
      hint(ENABLE_DEPTH_MASK);
      if (x2[i] > width + 50) {
        x2[i] = -50;
        y2[i] = random(height);
      }
    }

    // Luzes
    ambientLight(150, 150, 150);
    directionalLight(255, 255, 255, -1, -1, -1);
    pushMatrix();
    translate(xmodelo, ymodelo);
    rotateZ(PI);
    rotateY(rotposicao);
    scale(tamanhomodelo);
    shape(objModel, 0, 0);
    popMatrix();
    textFont(minhaFonte); 
    textAlign(LEFT, LEFT);

    
    fill(0);
    textSize(30);
    text(" LUZ: " + luz, l, alturasensordeluz);
    text(" HUMIDADE DO AR: " + humAr, l, alturasensordehumidadeAr);
    text(" TEMPERATURA: " + temp, l, alturasensordetemperatura);
    text(" HUMIDADE DO SOLO: " + humSolo, l, alturasensordehumidade);
    imageMode(CENTER);
    image(tab, l, alturasensordeluz-espaço);
    image(tab, l, alturasensordehumidadeAr-espaço);
    image(tab, l, alturasensordehumidade-espaço);
    image(tab, l, alturasensordetemperatura-espaço);

    if ((frameCount / 10) % 2 == 0) {
      fill(cor);
      textSize(22);
      if(luz<600){
          text(" Aviso: Pouca luz!", l, alturasensordeluz+linespacing );
      }
      if(luz>900){
          text(" Aviso: Demasiada luz!", l, alturasensordeluz+linespacing );
      }
      if(humAr<40){
          text(" Aviso: Ar demasiado seco!", l, alturasensordehumidadeAr+linespacing );
      }
      if(humAr>70){
          text(" Aviso: Ar demasiado húmido!", l, alturasensordehumidadeAr+linespacing );
      }
      if(temp<24){
          text(" Aviso: Temperatura demasiado baixa!", l, alturasensordetemperatura+linespacing );
      }
      if(temp>32){
          text(" Aviso: Temperatura demasiado alta!", l, alturasensordetemperatura+linespacing );
      }
      if(humSolo<125){
          text(" Aviso: Solo demasiado húmido!", l, alturasensordehumidade+linespacing );
      }
      if(humSolo>150){
          text(" Aviso: Solo demasiado seco!", l, alturasensordehumidade+linespacing );
      }
    }
    fill(cor);
    textSize(22);
    if(luz>=600 && luz<=900){
       text(" Intensidade da luz adequada.", l, alturasensordeluz+linespacing );
    }
    if(humAr>=40 && humAr<=70){
       text(" Humidade do ar adequada.", l, alturasensordehumidadeAr+linespacing );
    }
    if(temp>=24 && temp<=32){
       text(" Temperatura adequada.", l, alturasensordetemperatura+linespacing );
    }
    if(humSolo>=125 && humSolo<=150){
       text(" Humidade do solo adequada.", l, alturasensordehumidade+linespacing );
    }
  }
}

    //tab2.resize(300, 120);
    //image(tab2, width/2-350, height/2);

void mousePressed() {
  if (estado==0) {
    estado=1;
  }
  if(estado==1){
    if(mouseX>width/2-500 && mouseX < width/2-200 && mouseY > height/2-120 && mouseY < height/2 +120){
      estado=2;
    }
  }
}

void serialEvent(Serial myPort) {
  String val = myPort.readString().trim();
  if (val != null && val.length() > 0) {
    //println(val);
    data = val;
  }
}
