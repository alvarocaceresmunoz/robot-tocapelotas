#include <Servo.h> 

int UP_POSITION = 90;
int MIDDLE_POSITION = 15;
int DOWN_POSITION = 0;
int MIN_DELAY = 80;

Servo snareServo[2];

int tempo = 120;
int timeSignature[] = {4,4};
float wholeNoteDuration = (60/(tempo/timeSignature[1])) * 1000;
char receivedCharacter;
char pieceType;
char instructionDuration[2];
float duration;
float dotDuration;
int noteSymbol;
int instructionIndex = 0;
int leftHand = 0;
int rightHand = 1;

void setup() 
{ 
  Serial.begin(9600);
  snareServo[leftHand].attach(9);  // attaches the servo on pin 9 to the servo object
  snareServo[rightHand].attach(10);  // attaches the servo on pin 9 to the servo object
  up(leftHand);
  up(rightHand);
  delay(1000);
  middle(leftHand);
  middle(rightHand);
} 

void up(int hand)
{
  snareServo[hand].write(UP_POSITION);
}

void down(int hand)
{
  snareServo[hand].write(DOWN_POSITION);
}

void middle(int hand)
{
  snareServo[hand].write(MIDDLE_POSITION);
}

int playNote(char note)
{
  switch(note)
  {
    case 's':
      down(leftHand);
      delay(MIN_DELAY);
      middle(leftHand);
      break;
    case 'S':
      down(rightHand);
      delay(MIN_DELAY);
      middle(rightHand);
      break;
    case 'r':
      break;
  }
}

void wait(float dur)
{
  delay(dur - MIN_DELAY);
}

void loop()
{
  if(Serial.available() > 0) {
    receivedCharacter = Serial.read();
    
    if(instructionIndex == 0) {
      pieceType = receivedCharacter;
      Serial.print("[ARDUINO] Playing note ");
      Serial.print(pieceType);
      playNote(pieceType);
    }
    else if (instructionIndex == 1) {
      instructionDuration[0] = receivedCharacter;
    }
    else if (instructionIndex == 2) {
      instructionDuration[1] = receivedCharacter;
    }
    else if (instructionIndex == 3) {
      noteSymbol = (instructionDuration[0] - '0')*10 + (instructionDuration[1] - '0');
      dotDuration = 0;
      if(receivedCharacter == '.') {
        dotDuration = (wholeNoteDuration/(noteSymbol*2));
      }
      duration = (wholeNoteDuration/noteSymbol) + dotDuration;
      
      Serial.print(" with duration ");
      Serial.print(duration);
      Serial.println();
      wait(duration);
    }
    
    instructionIndex = (instructionIndex+1)%4;
  }
}
