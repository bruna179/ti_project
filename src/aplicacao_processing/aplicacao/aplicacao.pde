import processing.video.*;
import processing.serial.*;
import gifAnimation.*;
PImage planta;
PShape objModel;
PShape roupa;
int estado=0;
color cor;
PImage flor;
PImage flor2;
PImage backArrow;
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

Capture cam;
PImage frame, m, dominantColorImage;
boolean mudarroupa = false;
int[] colorCounts;
color dominantColor;
color storedDominantColor; // Store the first dominant color
boolean firstFrameProcessed = false; // Track if we've processed the first frame
boolean regaativa = false;
int highestCount = 0;
int colorResolution = 20;
int colorBins;

int espaço;
int x, y;

String data="";
String[] results;

float temp=0;
float humAr=0;
float humSolo=0;
float luz=0;

String currentPlant = "basil";
String[] plantas = {"basil", "snakePlant", "anthurium", "cyclamen"};
int[] luzMinA = {600, 400, 450, 400};
int[] luzMaxA = {900, 700, 700, 650};
int[] humArMinA = {40, 40, 60, 50};
int[] humArMaxA = {70, 70, 80, 60};
int[] humSoloMinA = {300, 300, 300, 300};
int[] humSoloMaxA = {600, 720, 600, 600};
int[] tempMinA = {24, 18, 21, 10};
int[] tempMaxA = {32, 30, 29, 18};

int luzMin;
int luzMax;
int humArMin;
int humArMax;
int humSoloMin;
int humSoloMax;
int tempMin;
int tempMax;

PImage manj, anth, cycla, snake;
Gif manjG, anthG, cyclaG, snakeG;

void setup() {
  size(1200, 750, P3D);
  noStroke();
  background(#F4F5F0);
  objModel = loadShape("fada.obj");
  roupa = loadShape("roupa.obj");
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
  planta= loadImage("planta.jpg");
  fundo = loadImage("fundo.png");
  tab = loadImage("tab.png");
  tab2 = loadImage("tab2.png");
  backArrow = loadImage("seta.png");
  manj = loadImage("manjericao2.png");
  cor= color(0);

  manj = loadImage("manjericao2.png");
  manjG = new Gif(this, "manjGif.gif");
  manjG.loop();
  anth = loadImage("anthurium1.png");
  anthG = new Gif(this, "anthuriumGif.gif");
  anthG.loop();
  cycla = loadImage("cyclamen4.png");
  cyclaG = new Gif(this, "cyclamenGif.gif");
  cyclaG.loop();
  snake = loadImage("snakeplant2.png");
  snakeG = new Gif(this, "snakeGif.gif");
  snakeG.loop();


  colorBins = 256 / colorResolution;
  colorCounts = new int[colorBins * colorBins * colorBins];
  dominantColorImage = createImage(100, 100, RGB);

  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("No cameras found.");
    exit();
  } else {
    cam = new Capture(this, cameras[0]);
    cam.start();
  }

  
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
  image(cam, 0, 0, width/2, height/2);
  background(#F4F5F0);

  if (cam.available()) {
    cam.read();
    frame = cam.copy();
    m = new PImage(frame.width, frame.height, ARGB);

    resetColorCounts();
    highestCount = 0;
    dominantColor = color(0);

    cam.loadPixels();
    m.loadPixels();

    // Find dominant color
    for (int y = 0; y < frame.height; y++) {
      for (int x = 0; x < frame.width; x++) {
        int loc = x + y * frame.width;
        color current = frame.pixels[loc];
        countColor(current);
      }
    }


    if (!firstFrameProcessed) {
      storedDominantColor = dominantColor;
      updateDominantColorImage(storedDominantColor);
      firstFrameProcessed = true;
    }

    // Update the display image with the current dominant color (for visualization)
    updateDominantColorImage(dominantColor);
  }

if (data != null && data.contains(",")) {
  String[] valores = data.split(",");
  if (valores.length == 4) {
     humAr = float(valores[0]);
     temp = float(valores[1]);
     humSolo = float(valores[2]);
    luz = float(valores[3]);

    
  }
}


  if (currentPlant=="basil") {
    luzMin=luzMinA[0];
    luzMax=luzMaxA[0];
    humArMin=humArMinA[0];
    humArMax=humArMaxA[0];
    humSoloMin=humSoloMinA[0];
    humSoloMax=humSoloMaxA[0];
    tempMin=tempMinA[0];
    tempMax=tempMaxA[0];
  }
  if (currentPlant=="snakePlant") {
    luzMin=luzMinA[1];
    luzMax=luzMaxA[1];
    humArMin=humArMinA[1];
    humArMax=humArMaxA[1];
    humSoloMin=humSoloMinA[1];
    humSoloMax=humSoloMaxA[1];
    tempMin=tempMinA[1];
    tempMax=tempMaxA[1];
  }
  if (currentPlant=="anthurium") {
    luzMin=luzMinA[2];
    luzMax=luzMaxA[2];
    humArMin=humArMinA[2];
    humArMax=humArMaxA[2];
    humSoloMin=humSoloMinA[2];
    humSoloMax=humSoloMaxA[2];
    tempMin=tempMinA[2];
    tempMax=tempMaxA[2];
  }
  if (currentPlant=="cyclamen") {
    luzMin=luzMinA[3];
    luzMax=luzMaxA[3];
    humArMin=humArMinA[3];
    humArMax=humArMaxA[3];
    humSoloMin=humSoloMinA[3];
    humSoloMax=humSoloMaxA[3];
    tempMin=tempMinA[3];
    tempMax=tempMaxA[3];
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


  //Menu Principal
  else if (estado==1) {
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
    translate(width/2, height/2+150);
    rotateZ(PI);
    rotateY(rotposicao);
    scale(tamanhomodelo*0.85);

    shape(objModel, 0, 0);
    shape(roupa, 0, 0);
    roupa.setTexture(planta);
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
    text("PLANT STATS", width/2-350-100, height/2+10);
    text("CHOOSE PLANT", width/2+350-100, height/2+10);


  }


  // Página dos sensores
  else if (estado==2) {
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

    if (mudarroupa) {

      storedDominantColor = dominantColor;
      updateDominantColorImage(storedDominantColor);
      roupa.setTexture(dominantColorImage);
      mudarroupa = false;
    }


    dominantColorImage.loadPixels();
    for (int i = 0; i < dominantColorImage.pixels.length; i++) {
      dominantColorImage.pixels[i] = storedDominantColor;
    }
    dominantColorImage.updatePixels();

    ambientLight(150, 150, 150);
    directionalLight(255, 255, 255, -1, -1, -1);
    pushMatrix();
    translate(xmodelo, ymodelo);
    rotateZ(PI);
    rotateY(rotposicao);
    scale(tamanhomodelo);
    shape(objModel, 0, 0);
    shape(roupa, 0, 0);
    popMatrix();
    textFont(minhaFonte);
    textAlign(LEFT, LEFT);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(15);
    text("Clica para mudar a cor da minha", 250, 50);

    text("roupa para a da tua planta!", 250, 65);

    backArrow.resize(int(150 * 0.75), int(55*0.75));
    image(backArrow, 80, 700);
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
      if (luz<luzMin) {
        text(" Aviso: Pouca luz!", l, alturasensordeluz+linespacing );
      }
      if (luz>luzMax) {
        text(" Aviso: Demasiada luz!", l, alturasensordeluz+linespacing );
      }
      if (humAr<humArMin) {
        text(" Aviso: Ar demasiado seco!", l, alturasensordehumidadeAr+linespacing );
      }
      if (humAr>humArMax) {
        text(" Aviso: Ar demasiado húmido!", l, alturasensordehumidadeAr+linespacing );
      }
      if (temp<tempMin) {
        text(" Aviso: Temperatura demasiado baixa!", l, alturasensordetemperatura+linespacing );
      }
      if (temp>tempMax) {
        text(" Aviso: Temperatura demasiado alta!", l, alturasensordetemperatura+linespacing );
      }
      if (humSolo<humSoloMin) {
        text(" Aviso: Solo demasiado húmido!", l, alturasensordehumidade+linespacing );
      }
      if (humSolo>humSoloMax) {
        text(" Aviso: Solo demasiado seco!", l, alturasensordehumidade+linespacing );
      }
    }
    fill(cor);
    textSize(22);
    if (luz>=luzMin && luz<=luzMax) {
      text(" Intensidade da luz adequada.", l, alturasensordeluz+linespacing );
    }
    if (humAr>=humArMin && humAr<=humArMax) {
      text(" Humidade do ar adequada.", l, alturasensordehumidadeAr+linespacing );
    }
    if (temp>=tempMin && temp<=tempMax) {
      text(" Temperatura adequada.", l, alturasensordetemperatura+linespacing );
    }
    if (humSolo>=humSoloMin && humSolo<=humSoloMax) {
      text(" Humidade do solo adequada.", l, alturasensordehumidade+linespacing );
    }
  }


  //Mudar de planta (estado = 3)
  if (estado== 3) {
    backArrow.resize(int(150 * 0.75), int(55*0.75));
    image(backArrow, 80, 700);
    textAlign(LEFT, LEFT);
    fill(0);
    textSize(30);
    text("MANJERICÃO", 180, 330);
    text("ANTÚRIO", 250, height-70);
    text("CÍCLAME", width-350, 330);
    text("ESPADA DE SÃO JORGE", width-500, height-70);

    if (currentPlant=="basil") {
      image(manjG, 300, 150, 300, 280);
      cycla.resize(300, 300);
      image(cycla, width-300, 150);
      snake.resize(250, 300);
      image(snake, width-300, height-230);
      anth.resize(300, 300);
      image(anth, 300, height-230);
    }
    if (currentPlant=="cyclamen") {
      manj.resize(300, 280);
      image(manj, 300, 150);
      image(cyclaG, width-300, 150, 300, 300);
      snake.resize(250, 300);
      image(snake, width-300, height-230);
      anth.resize(300, 300);
      image(anth, 300, height-230);
    }
    if (currentPlant=="snakePlant") {
      manj.resize(300, 280);
      image(manj, 300, 150);
      cycla.resize(300, 300);
      image(cycla, width-300, 150);
      image(snakeG, width-300, height-230, 250, 300);
      anth.resize(300, 300);
      image(anth, 300, height-230);
    }
    if (currentPlant=="anthurium") {
      manj.resize(300, 280);
      image(manj, 300, 150);
      cycla.resize(300, 300);
      image(cycla, width-300, 150);
      snake.resize(250, 300);
      image(snake, width-300, height-230);
      image(anthG, 300, height-230, 300, 300);
    }
  }
  verificaValores();
}

//tab2.resize(300, 120);
//image(tab2, width/2, height/2+250);

void mousePressed() {
  if (estado == 0) {
    mudarroupa = false;
    estado = 1;
  } 
  
  else if (estado == 1) {
    mudarroupa = false;
    if (mouseX > width/2 + 350 - 150 && mouseX < width/2 + 350 + 150 &&
      mouseY > height/2 - 60 && mouseY < height/2 + 60) {
          estado = 3;
 }
  
     else  if (mouseX > width/2-500 && mouseX < width/2-200 && mouseY > height/2-120 && mouseY < height/2+120) {
      estado = 2;
     }
  
    }

   else if (estado == 2) {
    // Verifica primeiro se clicou na seta (backArrow)
    if (mouseX > 80 - (150 * 0.75)/2 && mouseX < 80 + (150 * 0.75)/2 &&
      mouseY > 700 - (55 * 0.75)/2 && mouseY < 700 + (55 * 0.75)/2) {
      estado = 1;
      mudarroupa = false; // Garante que não ative mudança de roupa
    }
    // Só verifica o clique no modelo se não foi na seta
    else if (mouseX > xmodelo - tamanhomodelo/2 &&
      mouseX < xmodelo + tamanhomodelo/2 &&
      mouseY > ymodelo - tamanhomodelo - 200 &&
      mouseY < ymodelo + tamanhomodelo/2) {
      mudarroupa = true;
    }
  } else if (estado == 3) {
    // Verifica se clicou na seta (backArrow)
    if (mouseX > 80 - (150 * 0.75)/2 && mouseX < 80 + (150 * 0.75)/2 &&
      mouseY > 700 - (55 * 0.75)/2 && mouseY < 700 + (55 * 0.75)/2) {
      estado = 1;
    } else if (mouseX > 150 && mouseX < 450 && mouseY > 10 && mouseY < 280) {
      currentPlant = "basil";
    } else if (mouseX > width-300-125 && mouseX < width-300+125 && mouseY > height-230-150 && mouseY < height-230+150) {
      currentPlant = "snakePlant";
    } else if (mouseX > 150 && mouseX < 450 && mouseY > height-230-150 && mouseY < height-230+150) {
      currentPlant = "anthurium";
    } else if (mouseX > width-300-150 && mouseX < width-300+150 && mouseY > 0 && mouseY < 300) {
      currentPlant = "cyclamen";
    }
  }
}

void countColor(color c) {
  int r = min((int)(red(c)) / colorResolution, colorBins - 1);
  int g = min((int)(green(c)) / colorResolution, colorBins - 1);
  int b = min((int)(blue(c)) / colorResolution, colorBins - 1);

  int index = r + g * colorBins + b * colorBins * colorBins;

  if (index >= 0 && index < colorCounts.length) {
    colorCounts[index]++;
    if (colorCounts[index] > highestCount) {
      highestCount = colorCounts[index];
      dominantColor = color(
        r * colorResolution + colorResolution/2,
        g * colorResolution + colorResolution/2,
        b * colorResolution + colorResolution/2
        );
    }
  }
}

void updateDominantColorImage(color c) {
  dominantColorImage.loadPixels();
  for (int i = 0; i < dominantColorImage.pixels.length; i++) {
    dominantColorImage.pixels[i] = c;
  }
  dominantColorImage.updatePixels();
}

void resetColorCounts() {
  for (int i = 0; i < colorCounts.length; i++) {
    colorCounts[i] = 0;
  }
}
void wateringSystem() {
  if (myPort != null) {
    if (regaativa) {
      myPort.write('d'); 
      println("rega desligada: 'd'");
    } else {
      myPort.write('r'); 
      println("rega ativada: 'r'");
    }
    regaativa = !regaativa; 
  } else {
    println("n há porta serial");
  }
}
void verificaValores() {
  boolean valorAdequado = true;

  if (luz < luzMin || luz > luzMax) valorAdequado = false;
  if (humAr < humArMin || humAr > humArMax) valorAdequado = false;
  if (temp < tempMin || temp > tempMax) valorAdequado = false;
  if (humSolo < humSoloMin || humSolo > humSoloMax) valorAdequado = false;

  if (valorAdequado) {
    myPort.write("verde\n");
  } else {
    myPort.write("vermelho\n");
  }
}

void serialEvent(Serial myPort) {
  String val = myPort.readString().trim();
  if (val != null && val.length() > 0) {

    data = val;
  }
}
