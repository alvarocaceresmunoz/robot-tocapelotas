# What is it?

Imagine telling a robot to play music (*Today I'm into latin music... hey could you play a guaguancó pattern for me*)? What about making a robot jam session with your friends? Yet better... what if you could do that anywhere, anytime, just sending Telegrams with your smartphone? Well, you can do that (and much more) with robot-tocapelotas!

robot-tocapelotas is a robot (created by Sergio Pérez and Álvaro Cáceres) that can be controlled remotely with Telegram (smarphone / computer / tablet). The robot can also be controlled inside a Telegram group, which allows for collaborative music. The instructions of the robot follow the syntax of a programming language, called tocapelotas-lang, that is very simple and fast to type from the keyboard of your smartphone.

# Our story

## UC3Music hackathon

robot-tocapelotas is the result of a crazy experiment carried out at the [2016 UC3Music Hackathon](https://www.youtube.com/watch?v=Jok2oPczdf8) (we are the third team in the video). [UC3Music](http://uc3music.github.io/) is the society for DIY electronics, robotics and music from Universidad Carlos III de Madrid; once a year they organice a hackathon where the goal is to come up with a musical instrument that uses either robots or electronics, given a limited amount of hours, electronics, any kind of trash, and *a surprise component* we had to integrate into the instrument. Our surprise component was a penguin hand puppet, (although all of us know that it is actually [Tux](https://en.wikipedia.org/wiki/Tux)). We used it as mere decoration, but anyway...

<img src="https://raw.githubusercontent.com/100303602/robot-tocapelotas/master/yeah-put-that.jpg?token=APSbfcn7TLKKjRPL_QaYNNItupd8RhLuks5YwObrwA%3D%3D" width="400">

## The initial solution

We started with two servos connected to an Arduino UNO. Servos had a cable tie attached to their arms; that was the robot's *drum sticks*, which it used to hit cans filled with different amounts of water (yeah, it was not exactly high tech, but we had little time and resources... and you have to admit that it is very cool, very maker-ish).

The idea was to send instructions from Telegram to the server by means of a Telegram bot. The server executed a script written on Ruby and using the Telegram Bot Ruby API; once the server received the message, it sent that message to the Arduino (connected to one of the USB ports of the server) via serial communication. The Arduino received the instruction and depending on its contents, it switched one of the servos and returned the arm to its initial position, ready to hit the cans again. In order to optimize our materials, we used two cans for each servo and told the servo to move on one direction or the oppossite depending on the can specified in the instruction: that gave us four cans (two cans for each servo), as you can see in the video.

By that time we could hardly say that we were using a *programming language*... the only thing you could send to the bot was a group of letters (a,b,c or d, one letter for each can) separated by spaces. The server took those letters and sent them to the Arduino directly. It was the Arduino the one that translated letters to servo movements, followed by a fixed wait time (this guaranteed some sense of rhythm). If there was any letter on the instruction, the robot simply treated it as a rest.

Lastly, we found some problems with the Arduino serial port and with power. Luckily for us, the guys from UC3Music had a power supply we could use to give power to the servos, which were draining too much energy from the Arduino.

With all its limitations, the robot was seen with enthusiasm at the hackathon. *Installing* it was simple: adding the bot name to their Telegram contacts was enough for having the robot ready. Using it was also simple: you only had to type some letters and send the message, like when you chat with your friends. Everyone at the hackathon started adding the robot to their contacts and sent messages to it. People were making music in group! Just sending messages! With a seedy robot and seedy soda cans! (you have to admit it, the robot is really cute actually). After this we thought that the project could become something else... probably seedy, but way more funny.

## Improved solution

First thing we did after the hackathon was to incorporate rhythm to notes, as well as defining both notes and rests explicitly. Sending notes to the Arduino in the form of a *grid* was easy to implement, but it obliged users to write much more than what they would have written on a score (compare these two notations; with score noation you only need to write 7 notes, whereas with grid notation you have to write 16):

<img src="https://raw.githubusercontent.com/100303602/robot-tocapelotas/master/grid-vs-score-notation.jpg?token=APSbfXEcr0VR9STbBcyZ0Kq75OF7CClzks5YwOaJwA%3D%3D" width="300">

Writing so many characters even for simple rhythms would be fatal in terms of user experience, since most of the users will likely use the smartphone for sending messages to the robot... imagine sending a really complex rhythm, realizing you have one extra character, rewrite it again... Also, another problem of that notation would be that it would assume a constant division of the bar: this means, if we assume the bar is divied in a 4-pieces grid, how can I fit a triplet into the bar?

Our solution was to use a syntax similar to that of [LilyPond](http://lilypond.org/), a programming language for typesetting music scores. That is, we first put the name of the note, and then we put a number that represented the rhythm in classical notation (where 1 means a whole note, 4 means a quarter note, and so on). Translating the rhythmic number of a note to its duration knowing the tempo can be easily calculated with a rule of three. With the possibility of having different rhythms, the music produced with the bot was becoming more and more intersting.

## Adding a parser

As the language became more complex, we realized that it was not viable to use the server script or the low-level programming (and resources) of the Arduino to parse the strings received from the messages. We also realized that everything was way simpler to program in Ruby than in Arduino, and we had much more resources (RAM, CPU) on the server; this means that it was easier to process the messages from users and transform them into something easier to read for the Arduino (like a set of fixed-lenght operations: *servo1 up, servo1 down, servo2 up...*).

Therefore we decided that user messages received by the server would first be processed by a parser that would only accept programs with valid syntax; else, the parser would generate a syntax error and the user would receive a message with his/her name explaining the error. We selected RACC as it is similar to YACC (which we were familiar due to a subject on compilers from university), only that it is implemented in Ruby; RACC/YACC allow you to write the grammar and forget about more technical details, which is great because we no longer lose time processing characters, recognizing tokens and all the like.

The documentation and the number of well-written examples you could find out there is really scarce, but after some days we were able of having a working example where we understood every line of the code. This has been really worth it, since we have almost instantaneously added lots of syntactic sugar to the language that makes it much easier to type.

For instance, if several consecutive notes had the same rhythm, it was only necessary to write it on the first one, as it is done in LilyPond. If part of the motif was a repetition of some notes, that group of notes could be enclosed with parenthesis and a repetition (x3, for instance, to repeat three times); nested repetitions worked flawlessly.

After this we knew that we could give users a (simple but) powerful live coding language to be used with the robot: tocapelotas-lang.

## Powering the robot

We did not have any power supply, so we had to power the servos with batteries. 4 batteries of 1.5V seem to do the job quite well. Here are some pictures of the robot powered with batteries:

General view of the robot
<img src="" width="300">
<img src="" width="300">
<img src="" width="300">
<img src="" width="300">

# Manual

## Install

Actually there is nothing to install if you already have Telegram (you can use it on Windows, Mac, Linux, Android, iOS...). Open Telegram and search for the user *Tocapelotas_robot*. That's it.

## Communicating with the bot

In order to speak to the robot, you must send one of the following instructions:
- ```/help```: It shows code examples
- ```/robot ...```: It sends to the robot any code you write after the word ```/robot```

## Motives

The basic unit of this language is the motif. A motif is a list of notes. When you play music with robot-tocapelotas, you will normally follow this workflow: you first create a motif (a set of notes), then you tell the robot to play that motive. To create a motif, you have to type the name you want to give to it, and making it equal to the list of notes you want (we'll get to the list of notes later):
```
/robot :mySuperCoolRhythm = s1 s8 r8 s8 s8 s4 s16 s16 s16 r2
```
The motif name should start with a colon (```:```), then contain a letter and then either letters or numbers, as many as you want. You can change a motif by defining it again; you could change the motif other users have created as well. That's exactly the funny part of all of this: you can improvise by modifying existing music, which gives a lot more of cohesion to the music, and which makes the jam session much more collaborative.

To play the motif, type ```/robot play``` followed by the name of your motif (remember that motifs start with colons)
```
/robot play :mySuperCoolRhythm
```
You can play your motives as well as motives from your friends, if you are talking to the bot in the same group.

## Notes INCOMPLETE

A note has two parts: the piece you want the robot to hit, and a number that describes the duration of the note in traditional notation (4 is a quarter note, 8. is a dotted eighth note, etc). Make sure you write the piece and the rhythm without spaces in between. Also, notice that you can only add one dot to your notes (you cannot write things like ```s9...```).

Right now you have the following pieces to hit:
- Snare drum: denoted by the letter *s*
- Rest: this is equivalent to not playing anything. It is denoted by the letter *r*

Now if we look at the example above:
```
/robot :mySuperCoolRhythm = s1 s8 r8 s8 s8 s4 s16 s16 s16 r2
```
We now we are telling to the robot something like *play the snare with a rhythm of a whole note, then a snare with a rhythm of an eigth note...*. If we translated the code into a score, it would look something like this:

<img src="https://raw.githubusercontent.com/100303602/robot-tocapelotas/master/notes-example.jpg?token=APSbfWuQ_gQn5z2-xSGtm8e4V4Bx-9n8ks5YwQgTwA%3D%3D" width="300">

## List of notes

Normally you want to send more than one note to the robot. A list of notes is just... well, a list of notes, separated by spaces (you can put as many of them as you want).

There is some syntactic sugar that will make your life much easier when writing lists of notes. If several consecutive notes have the same rhythmic duration, you only have to specify the rhythm for the first note. Taking the example we used before, you could rewrite like this and save some typing:
```
/robot :mySuperCoolRhythm = s1 s8 r s s s4 s16 s s r2
```
Also, if part of your list contains notes that are repeated consecutively, you can group them into a repetition. For instance, with the example above we have an eighth note repeated twice, and a sixteenth note repeated twice. We could just rewrite the motive like this:
```
/robot :mySuperCoolRhythm = s1 s8 r sx2 s4 s16x2 r2
```
You can do the same with repetitions of several notes:
```
/robot :mySuperCoolRhythm = s1 s8 r sx2 (s4 s16)x2 r2
```
Or even put repetitions of repetitions!
```
/robot :mySuperCoolRhythm = (s8 s16x2 s8)x2 s8x3 (s16 s)x2
/robot :anotherCoolRhythm = (s8 (s8 s16x2)x2)x3
```
## Known issues
By now you should not send motives with more than 16 notes in total. Also, you should not send figures faster than sixteenth notes (like 32th notes, 64th notes and so on), as the servo motors cannot handle the speed required to play these rhythms.

# Demo

[Here](https://www.youtube.com/watch?v=vuBKAEIBxeM) you can watch a demo of the robot in action!

# Future improvements:
- Allowing motives with more than 16 notes: right now you can only send small chunks of notes; more specifically, you can only send 16 notes in total (that is, after applying repetitions). This happens because the server translates all code into a set of fixed-length strinhs that the Arduino can read pretty fast. Arduino communicates with the server via serial port, which by default accepts chunks of 64 Bytes; each note is represented by 4 Bytes, so you can only send 64/4 = 16 notes at once to the robot. The Telegram bot will notify you with an error message if your motif exceeds the number of notes, though.
- Integrating a metronome: so that users could keep track of the time signature
- Allowing users to switch the metronome on / off
- Adding functions to the grammar: this would be extremely powerful
- Defining motifs as the modification of another motif: that would give way to ask-answer constructions, so widely used in music (think of a canon for instance)
- Storing predefined motifs in the server: this way a beginner user could base his/her new motif on predefined rhythms, or simply add an accompaniment motif to one robot while playing his/her main motif on other robot
- Adding concurrency to the robot: so that it could play several notes at the same time, or that several robots could play as an ensemble
- Designing string instrument robots and integrating them into the project
- Providing more descriptive error messages
- Providing a close-to-real-time streaming service (working on that)
- Telling the robot to play a motif on a concrete time (i.e., after two bars, or exactly on bar number 130). It would be crucial to take note of latency from each user to the server, so that the user gets an error if s/he wants to play motif too soon.
- Allowing for an arbitrarily long number of dots on the rhythm of each note
- Using faster and more precise servo motors
- Adding nuances (levels of intensity) and accents to the robots
- Allowing to do ritardandos and accelerandos
- Adding triplets, quintuplets, or simply n-tuplets
- Adding tempo and time signature change
