#include <Servo.h>
//#include "pitches.h"

int UP_POSITION = 90;
int MIDDLE_POSITION = 15;
int DOWN_POSITION = 0;
int MIN_DELAY = 80;

Servo snareServo[2];

int tempo = 150;
int timeSignature[] = {4,4};
float wholeNoteDuration = (60/(tempo/timeSignature[1])) * 1000;
//char receivedCharacter;
char pieceType;
char instructionDuration[2];
float duration;
float dotDuration;
int noteSymbol;
int instructionIndex = 0;
const int leftHand = 0;
const int rightHand = 1;
int state;
const int WAIT_FOR_MOTIF = 0;
const int READ_HEADER_SIZE = 1;
const int READ_HEADER = 2;
const int READ_MOTIF = 3;
const int PLAY = 4;
char motif[300];
int headerSize;
int motifSize;
int motifPosition;
int headerPosition;

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

  state = WAIT_FOR_MOTIF;

  Serial.println("I am alive");
//
//  int notes[] = { NOTE_C2,NOTE_E3,NOTE_B3, NOTE_C3,NOTE_G3,NOTE_D4, NOTE_AS2,NOTE_F3,
//                    NOTE_C4, NOTE_CS3,NOTE_GS3,NOTE_DS4, NOTE_C4,NOTE_G4,NOTE_C4,NOTE_F3,
//                    NOTE_CS4,NOTE_FS3, NOTE_FS4,NOTE_D4,NOTE_G3, NOTE_D4,NOTE_A3,NOTE_CS3,
//                    NOTE_A3,NOTE_CS3,NOTE_AS3,NOTE_CS3, NOTE_D4,NOTE_CS4,NOTE_D3,NOTE_DS3,
//                    NOTE_D3,NOTE_GS2,NOTE_F3,NOTE_E3, NOTE_GS2,NOTE_B2,NOTE_A2,NOTE_GS2,
//                    NOTE_B3,NOTE_AS3, NOTE_DS3,NOTE_E3,NOTE_FS3,NOTE_F3,NOTE_G3,NOTE_AS2};
//
//
//  for (int i=0; i<sizeof(notes); ++i) {
//    tone(8, notes[i], 80);
//    delay(150);
//  }

//for (int i=0; i<4; i++) {
//  tone(8,440,50);
//    delay(500);
//
//    tone(8,330,50);
//    delay(500);
//
//    tone(8,330,50);
//    delay(500);
//
//    tone(8,330,50);
//    delay(500);
//  }
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
  switch (note)
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
  delay(dur);// - MIN_DELAY);
}

int ipow(int base, int exponent)
{
    int result = 1;
    while (exponent)
    {
        if (exponent & 1)
            result *= base;
        exponent >>= 1;
        base *= base;
    }

    return result;
}

void loop()
{
  if (state == WAIT_FOR_MOTIF) {
    if (Serial.available() > 0) {
      if (Serial.read() == '$') {
        state = READ_HEADER_SIZE;
        motifSize = 0;
      }
    }
  }

  else if (state == READ_HEADER_SIZE) {
    if (Serial.available() > 0) {
      headerSize = Serial.read() - '0';

      state = READ_HEADER;
      headerPosition = headerSize-1;
    }
  }

  else if (state == READ_HEADER) {
    if (headerPosition >= 0) {
      if (Serial.available() > 0) {
        motifSize += ipow(10,headerPosition) * (Serial.read() - '0');
        headerPosition--;
      }
    }
    else {
      state = READ_MOTIF;
      motifPosition = 0;
      Serial.print("Motif size: ");
      Serial.println(motifSize);
    }
  }

  else if (state == READ_MOTIF) {
    if (motifPosition < motifSize) {
      if (Serial.available() > 0) {
        motif[motifPosition] = Serial.read();
        motifPosition++;
      }
    }
    else {
      state = PLAY;
    }
  }
  else if (state == PLAY) {
    for (int i = 0; i < motifSize; i+=4) {
      pieceType = motif[i];

      playNote(pieceType);

      instructionDuration[0] = motif[i+1];

      instructionDuration[1] = motif[i+2];

      noteSymbol = (instructionDuration[0] - '0')*10 + (instructionDuration[1] - '0');
      dotDuration = 0;
      if (motif[i+3] == '.') {
        dotDuration = (wholeNoteDuration/(noteSymbol*2));
      }
      duration = (wholeNoteDuration/noteSymbol) + dotDuration;

      wait(duration);
    }
    state = WAIT_FOR_MOTIF;
  }
}
