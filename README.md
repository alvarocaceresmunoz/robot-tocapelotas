# What is it?

Imagine telling a robot to play music (*Today I'm into latin music... hey could you play a guaguancó pattern for me*)? What about making a robot jam session with all of your friends? No no, yet better... what if you could do that anywhere, anytime, just sending messages with your smartphone? Well... you can do that (and much more) with **robot-tocapelotas**!

**robot-tocapelotas** is a robot that can be controlled remotely by the use of instructions, which are sent via Telegram app (you can use Telegram on your favourite computer program, webpage, or smartphone app). This means the robot can be controlled inside of a Telegram group, to create collaborative music. The instructions of the robot follow the syntax of a programming language, called *tocapelotas-lang*, that is very simple and fast to type from the keyboard of a smartphone.

# Our story

## UC3Music hackathon

**robot-tocapelotas** is the result of a crazy experiment carried out at the [2016 UC3Music Hackathon](https://www.youtube.com/watch?v=Jok2oPczdf8) (we are the third team in the video). [UCMusic](http://uc3music.github.io/) is the society for DIY electronics, robotics and music from the Universidad Carlos III de Madrid; once a year they organice a hackathon where the goal is to come up with a musical instrument that uses either robots or electronics, given a limited amount of hours, electronics, any kind of trash, and *a surprise component* we had to integrate into the instrument. Our surprise component was a penguin hand puppet, (although all of us know that it is actually [Tux](https://en.wikipedia.org/wiki/Tux)). We used it as mere decoration, but anyway...

<img src="https://media.makeameme.org/created/yeah-put-that.jpg" width="400">

## The initial solution

We started with two servos connected to an Arduino UNO. Servos had a cable tie attached to their arms; that was the robot's *drum sticks*, which it used to hit cans filled with different amounts of water (yeah, it was not exactly high tech, but we had little time and resources... and you have to admit that it is very cool, very maker-ish). The idea was to send instructions from Telegram to the server by means of a Telegram bot; once the server received the message, it sent that message to the Arduino (connected to one of the USB ports of the server) via serial communication. The Arduino received the instruction and depending on its contents, it switched one of the servos and returned the arm to its initial position, ready to hit the cans again. In order to optimize our materials, we used two cans for each servo and told the servo to move on one direction or the oppossite depending on the can specified in the instruction: that gave us four cans (two cans for each servo).

By that time we could hardly say that we were using a *programming language*... the only thing you could send to the bot was a group of letters (a,b,c or d, one letter for each can) separated by spaces. The server took those letters and sent them to the Arduino directly. It was the Arduino the one that 

# How to use it

## Motives

The basic unit of this language is the motif. A motif is a list of notes. When you play music with robot-tocapelotas, you will normally follow this workflow: you first create a motif (a set of notes), then you tell the robot to play that motive. For creating a motif, you have to type the name you want to give to your motif, and making it equal to the list of notes you want (we'll get to the list of notes later):
```
:mySuperCoolRhythm = s1 s8 s s s s4 s16 s s r2
```
The motif name should start with a colon (```:```), then with a letter and then with either letters or numbers, as many as you want. Once you have defined your motif you can always change it later by defining it again, or you could change the motif other users have created (that's exactly the funny part of all of this: you can improvise by modifying existing music, which gives a lot more of cohesion to the music, and which makes the jam session much more collaborative).

To play the motif, you just have to type ```play``` followed by the name of your motif (remember that motifs start with colons)
```
play :mySuperCoolRhythm
```

## Lists of notes

A note makes reference to the type of piece you want the robot to hit, immediately followed by a number that describes the duration of the note in traditional notation.
Right now you have the following typies of pieces to smash:
- Snare drum: denoted by the letter *s*
- Rest: this is equivalent to not playing anything. It is denoted by the letter *r*

## Changing tempo

Playing music with **robot-tocapelotas** can be really funny... but why should the tempo (i.e. the speed) be always the same? *robot-tocapelotas* allows you to change the tempo of the song.

But before showing you the syntax, it's important to know how is the tempo normally expressed in traditional notation (the notation you can find on scores or tabs). 

# Bugs and future improvements:

Here there are some things that still don't work as expected, or that we haven't had time to change yet:
- You can only send small chunks of notes; more specifically, you can only send 16 notes in total (that is, after applying repetitions). This happens because the server translates all code into a set of fixed-length strinhs that the Arduino can read pretty fast. Arduino communicates with the server via serial port, which by default accepts chunks of 64 Bytes; each note is represented by 4 Bytes, so you can only send 64/4 = 16 notes at once to the robot. The Telegram bot will notify you with an error message if your motif exceeds the number of notes, though.
- Integrating a metronome: in order to keep track of the time signature
- Incorporating syntax to the grammar that allowed users to switch the metronome on / off.
- Allowing operations between lists
- Defining motifs as the modification of another motif
- Including functions
- Storing predefined motifs in the server: this way a beginner user could
- Adding concurrency to the robot: so that it could play several notes at the same time, or that several robots could play as an ensemble.
- Designing string instrument robots and integrating them into the project
- Providing more descriptive error messages
- Providing a close-to-real-time streaming service (working on that)
