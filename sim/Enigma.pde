class Enigma {
  Rotor rotor1;
  Rotor rotor2;
  Rotor rotor3;
  EndThing end;
  PlugBoard plugBoard;
  int runType;
  boolean showPlugs = false;
  String inputString, outputString;

  //---------------------------------------------------------------------------------------------------------------------------------------------------------------
  Enigma() {
    runType=0; //encode;
    end = new EndThing();
    end.cipher = floor(random(1,26));
    plugBoard = new PlugBoard();
    inputString="";
    outputString="";
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------------
  void setRotors(int first, int second, int third) {

    if (first != second && first != third && second != third) {
      rotor1 = new Rotor(first, 1);
      rotor2 = new Rotor(second, 2);
      rotor3 = new Rotor(third, 3);
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------------


  void setRotorPositions(int first, int second, int third) {
    rotor1.position = first;
    rotor2.position = second;
    rotor3.position = third;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------------

  char runMachine(char inputChar) {
    if (rotor1.rotorNo == rotor2.rotorNo || rotor3.rotorNo == rotor2.rotorNo  || rotor1.rotorNo == rotor3.rotorNo ) {
      println("Error rotors cannot have the same number"); 
      return '1';
    }
    inputString += inputChar;
    println(inputString);

    int inputNo = letterOrderLowerCase.indexOf(inputChar); 

    int currentNo = inputNo;
    currentNo = plugBoard.runThrough(currentNo);
    currentNo = rotor1.runThrough(currentNo, true);
    currentNo = rotor2.runThrough(currentNo, true);
    currentNo = rotor3.runThrough(currentNo, true);
    if ( runType==0 ) {
      currentNo = end.runThroughEncode(currentNo, true);
    } else {
      currentNo = end.runThroughDecode(currentNo, true);
    }
    currentNo = rotor3.runThrough(currentNo, false);
    currentNo = rotor2.runThrough(currentNo, false);
    currentNo = rotor1.runThrough(currentNo, false);
    currentNo = plugBoard.runThrough(currentNo);
    if (currentNo == -1) {
      println(rotor1.position, rotor2.position, rotor3.position);
    }

    if (currentNo == inputNo) {
      println(inputNo, rotor1.position, rotor2.position, rotor3.position);
    }
    moveRotors();
    outputString += letterOrderLowerCase.charAt(currentNo);
    print(outputString);
    return letterOrderLowerCase.charAt(currentNo);
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------------


  void moveRotors() {
    rotor1.position +=1;
    if (rotor1.position == 26) {
      rotor1.position = 0;
      rotor2.position+=1;
      if (rotor2.position == 26) {
        rotor2.position = 0;
        rotor3.position+=1;
        if (rotor3.position == 26) {
          rotor3.position = 0;
        }
      }
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------------
  void show() {
    if (!showPlugs) {
      stroke(0);
      for (int i = 0; i< letters.length; i++) {
        letters[i].show();
      }
      rotor1.show();
      rotor2.show();
      rotor3.show();
      end.show();
      

      int x = width/2 - 400;
      fill(200, 190, 260);
       rect(x+100, 50, 250, 40);
       rect(x+650, 50, 250, 40);
      textSize(20);
      fill(30);
      textSize(20);
      text(inputString, x+100, 48, 240, 38);      
      text(outputString, x+650, 48, 240, 38);
      textSize(30);
      fill(200);     
      text("Input:", x-65, 48);
      textSize(30);
      fill(200);     
      text("Output:", x+470, 48);


       rectMode(CENTER);
       colorMode(RGB);
       fill(100, 100, 255);
       rect(x-110, 270, 100, 50);
      fill(10);
      textSize(23);
       text("CLEAR", x-110, 270);
      
      if ( runType == 0){
         rectMode(CENTER);
         colorMode(RGB);
          fill(30, 144, 255);
           rect(x-110, 180, 150, 60);
        fill(10);
         textSize(25);
         text("Encode", x-110, 180);
      } else {
         rectMode(CENTER);
         colorMode(RGB);
          fill(70, 225, 10);
           rect(x-110, 180, 150, 60);
        fill(10);
         textSize(25);
        text("Decode", x-110, 180);
      }
      
      if (rotor1.rotorNo == rotor2.rotorNo || rotor3.rotorNo == rotor2.rotorNo  || rotor1.rotorNo == rotor3.rotorNo ) {
        fill(255,0,0);
        text("Cannot use the same rotor twice", width/2,50);
      }
    } else {
      plugBoard.show();
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  void randomRotors() {
    int rand1 = floor(random(5));
    int rand2 = floor(random(5));
    while (rand1 == rand2) {
      rand2 = floor(random(5));
    }

    int rand3 = floor(random(5));
    while (rand1 == rand3 || rand2 == rand3) {
      rand3 = floor(random(5));
    }
    setRotors(rand1, rand2, rand3);
  }


  void randomPositions() {
    setRotorPositions(floor(random(26)), floor(random(26)), floor(random(26)));
  }

  //--------------------------------------------------------------------------------------------------------------------------------------------------
 //<>//
  void click(int x, int y) {
    if (y > height*(9.0/10.0) && !enigma.plugBoard.movingPlug) {//if clicking the bottom of the screen then switch between plugs anad lamps //<>//
      enigma.showPlugs = !enigma.showPlugs;
    } else {
       int x1 = width/2 - 400;
      if (x>=(x1-140) && x<=(x1-80) && y>=250 && y<=300) {
        inputString="";
        outputString="";
        show();
      } else if (x>=(x1-140) && x<=(x1-80) && y>=180 && y<=230) {
        if ( runType==0 ) //<>//
          runType=1;
        else
          runType=0;
        show();
      } else {
        enigma.rotor1.click(x, y);
        enigma.rotor2.click(x, y);
        enigma.rotor3.click(x, y);
        enigma.plugBoard.click(x, y);
      }
    }
  }
  
  
  
  //------------------------------------------------------------------------------------------------------------
  
  char[] processWord(char[] input){
    char[] output = new char[input.length];
    for(int i = 0 ; i< input.length; i++){
      output[i] = runMachine(input[i]);
    }
    return output;
  }
}
