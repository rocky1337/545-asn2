int[] rCounts = new int[256];  //bins for red histogram
int[] gCounts = new int[256];  //bins for green histogram
int[] bCounts = new int[256];  //bins for blue histogram
int posR = 10, posG = 275, posB = 541, a, b, c, d, hCountTotal;
String fname = "test2.jpg";
PImage img, sImg, eImg, currentImg; //Original, brightened, darkened, current
boolean showHists = false;


void setup() {
  size(400, 400);
  surface.setResizable(true);
  img = loadImage(fname);
  //sImg = stretchedHist(img);
  //eImg = equalize(img);
  surface.setSize(img.width, img.height);
  currentImg = img;
}

void draw() {
  if (showHists) displayHists();
  else image(currentImg, 0, 0);
  stroke(255);
  strokeWeight(2);
  noFill();
  rect(a, b, c, d);
}


//calculates the hist values
void calcHists(PImage img) {
  //sets all values of Counts to zero
  for (int i = 0; i < rCounts.length; i++) {
    rCounts[i] = 0; 
    gCounts[i] = 0; 
    bCounts[i] = 0;
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
  PImage copyImg = img.get(); 
  //will alter copy image according to the stretched histogram equation
  for (int y = 0; y < copyImg.height; y++) {
    for (int x = 0; x < copyImg.width; x++) {
    }
  }
}

void equalize(PImage img) {
  PImage copyImg = img.get();
  //will alter and return copy that has been equalized
  for (int y = 0; y < copyImg.height; y++) {
    for (int x = 0; x < copyImg.width; x++) {
    }
  }
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
    printHists();
  } else if (key == '2') {
    //display stretched Hist
  } else if (key == '3') {
    //display equalized hist
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