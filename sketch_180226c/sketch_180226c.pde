int[] rCounts = new int[256];  //bins for red histogram
int[] gCounts = new int[256];  //bins for green histogram
int[] bCounts = new int[256];  //bins for blue histogram
int[] rCCount = new int [256];
int[] gCCount = new int [256];
int[] bCCount = new int [256];
int posR = 10, posG = 275, posB = 541, a, b, c, d;
String fname = "test2.jpg";
PImage img, sImg, eImg, currentImg; //Original, brightened, darkened, current
boolean showHists = false;


void setup() {
  surface.setResizable(true);
  img = loadImage(fname);
  surface.setSize(img.width, img.height);
  //sImg = stretchedHist(img);
  calcHists(img);
  eImg = equalize(img);

  currentImg = img;

  strokeWeight(2);
  noFill();
}

void draw() {
  if (showHists) displayHists();
  else image(currentImg, 0, 0);
  rect(a, b, c, d);
}


//calculates the hist values
void calcHists(PImage img) {
  //sets all values of Counts to zero
  for (int i = 0; i < rCounts.length; i++) {
    rCounts[i] = 0; 
    gCounts[i] = 0; 
    bCounts[i] = 0;
    rCCount[i] = 0;
    gCCount[i] = 0;
    bCCount[i] = 0;
  }
  //gets r, g, b values as ints
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      color c = img.get(x, y);
      int r = int(red(c));
      int g = int(green(c));
      int b = int(blue(c));
      rCounts[r] += 1;
      gCounts[g] += 1;
      bCounts[b] += 1;
      rCCount[r] += 1;
      gCCount[g] += 1;
      bCCount[b] += 1;
    }
  }
}

void displayHists() {
  //Displays global histogram held in rCounts, etc
  background(0);
  int maxval = 0;
  //Find maxval in all hists
  for (int i = 0; i < rCounts.length; i++) {
    if (rCounts[i] > maxval) maxval = rCounts[i];
    if (gCounts[i] > maxval) maxval = gCounts[i];
    if (bCounts[i] > maxval) maxval = bCounts[i];
  }
  stroke(255, 0, 0);
  //Use map() to scale line values
  for (int i = 0; i < rCounts.length; i++) {
    //Scale line from 0 to height/2
    int val = int(map(rCounts[i], 0, maxval, 0, height/2));
    line(i + posR, height, i + posR, height - val);
  }
  stroke(0, 255, 0);  //Display green hist in green
  for (int i = 0; i < gCounts.length; i++) {
    //Scale line from 0 to height/2
    int val = int(map(gCounts[i], 0, maxval, 0, height/2));
    line(i + posG, height, i + posG, height - val);
  }
  stroke(0, 0, 255);
  for (int i = 0; i < bCounts.length; i++) {
    //Scale line from 0 to height/2
    int val = int(map(bCounts[i], 0, maxval, 0, height/2));
    line(i + posB, height, i + posB, height - val);
  }
}

void printHists() {
  //Use a for (int i...) loop to println i, rCounts[i], gCounts[i], and bCounts[i]
  for (int i = 0; i < rCounts.length; i++) {
    println(i, rCounts[i], gCounts[i], bCounts[i]);
  }
}

void stretchedHist(PImage img) {
  PImage copyImg = img;
  int rLowest = 0, gLowest = 0, bLowest = 0;
  int rMax = 0, gMax = 0, bMax = 0;
  //creates a stretched hist image to display
  for (int i = 0; i < rCounts.length; i++) {
    if (rCounts[i] != 0) {
      rLowest = i; 
      break;
    }
  }
  for (int i = 0; i < rCounts.length; i++) {
    if (gCounts[i] != 0) {
      gLowest = i; 
      break;
    }
  }
  for (int i = 0; i < rCounts.length; i++) {
    if (bCounts[i] != 0) {
      bLowest = i; 
      break;
    }
  }
  for (int x = 0; x < copyImg.width; x++) {
    for (int y = 0; y < copyImg.height; y++) {
      color c = copyImg.get(x, y);
      int r = int(red(c)) - rLowest;
      int g = int(green(c)) - gLowest;
      int b = int(blue(c)) - bLowest;
      copyImg.set(x, y, color(r, g, b));
    }
  }
  calcHists(copyImg);
  for (int q = 255; q >= 0; q--) {
    if (rCounts[q] != 0) {
      rMax = q; 
      break;
    }
  }
  for (int q = 255; q >= 0; q--) {
    if (gCounts[q] != 0) {
      gMax = q; 
      break;
    }
  }
  for (int q = 255; q >= 0; q--) {
    if (bCounts[q] != 0) {
      bMax = q; 
      break;
    }
  }   
  for (int x = 0; x < copyImg.width; x++) {
    for (int y = 0; y < copyImg.height; y++) {
      color c = copyImg.get(x,y);
      int R = int(red(c)) * 255 / rMax;
      int G = int(green(c)) * 255 / gMax;
      int B = int(blue(c)) * 255 / bMax;
      copyImg.set(x, y, color(R, G, B));
    }
  }
}


PImage equalize(PImage img) {
  PImage copyImg = img.get();
  calcHists(copyImg);
  int res = copyImg.width * copyImg.height;
  for (int i = 1; i < rCounts.length; i++) {
    rCCount[i] = rCCount[i - 1] + rCounts[i];
    gCCount[i] = gCCount[i - 1] + gCounts[i];
    bCCount[i] = bCCount[i - 1] + bCounts[i];
  }
  for (int i = 0; i < rCounts.length; i++) {
    bCCount[i] = round((bCCount[i] / res) * 255);
    gCCount[i] = round((gCCount[i] / res) * 255);
    rCCount[i] = round((rCCount[i] / res) * 255);
  }
  for (int x = 0; x < copyImg.width; x++) {
    for (int y = 0; y < copyImg.height; y++) {
      color c = copyImg.get(x, y);
      int r = int(red(c));
      int g = int(green(c));
      int b = int(blue(c));
      copyImg.set(x, y, color(rCCount[r], gCCount[g], bCCount[b]));
    }
  }
  return copyImg;
}

void mousePressed() {
  a=mouseX;
  b=mouseY;
}


void mouseDragged() {
  c=mouseX-a;
  d=mouseY-b;
  rect(a, b, c, d);
}

void mouseReleased() {
  //needs to call the hists to color inside of rectangle
}
void keyReleased() {
  background(0);
  if (key == '1') {
    currentImg = img;
    showHists = false;
    surface.setSize(currentImg.width, currentImg.height);
    calcHists(currentImg);
    //printHists();
  } else if (key == '2') {
    //display stretched Hist
  } else if (key == '3') {
    //display equalized hist
    currentImg = eImg;
    calcHists(currentImg);
    showHists = false;
    surface.setSize(currentImg.width, currentImg.height);
  } else if (key == 'h') {
    calcHists(currentImg);
    showHists = true;
    surface.setSize(posB + bCounts.length, currentImg.height);
  } else if (key == 's') {
    //currentImg = sImg;
    calcHists(currentImg);
    showHists = true;
    surface.setSize(posB + bCounts.length, currentImg.height);
  } else if (key == 'e') {
    //currentImg = eImg;
    calcHists(currentImg);
    showHists = true;
    surface.setSize(posB + bCounts.length, currentImg.height);
  }
}