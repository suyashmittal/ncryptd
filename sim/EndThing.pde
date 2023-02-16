class EndThing {
  int[] wiring;
  int cipher;

  EndThing() {
     wiring = new int[]{21,10,22,17,8,19,25,20,15,13,3,7,0,24,9,6,4,5,1,18,16,14,12,11,2,23};
  }

  int runThroughEncode(int input, boolean forward) {
      int rem = ((input+cipher) % 26);
       println("encode ",input, rem, wiring[rem]);
      return wiring[rem];
    }

  int runThroughDecode(int input, boolean forward) {
    int numInd = 0;
    for(int i=0; i<26; i++){
      if (wiring[i] == input){
        numInd=i;
        break;
      }
    }
    numInd = (((numInd-cipher)+26) % 26);
    
    println("Decode ",input, numInd);
    return numInd;
  }
  
   void show() {
     int x = width/2 + 455;
      rectMode(CENTER);
      fill(255);
       rect(x, 200, 50, 50);
       textSize(20);
     fill(0);
      text( cipher, x, 200);
     fill(255);
      textSize(35);
      text("Cipher:", x-90, 195);
   }
}
