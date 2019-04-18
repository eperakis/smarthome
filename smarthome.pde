import beads.*;
import controlP5.*;
import org.jaudiolibs.beads.*;
import java.util.PriorityQueue;



//to use text to speech functionality, copy text_to_speech.pde from this sketch to yours
//example usage below

//IMPORTANT (notice from text_to_speech.pde):
//to use this you must import 'ttslib' into Processing, as this code uses the included FreeTTS library
//e.g. from the Menu Bar select Sketch -> Import Library... -> ttslib

TextToSpeechMaker ttsMaker; 

//<import statements here>

//to use this, copy notification.pde, notification_listener.pde and notification_server.pde from this sketch to yours.
//Example usage below.

//name of a file to load from the data directory
String eventDataJSON2 = "smarthome_party.json";
String eventDataJSON1 = "smarthome_parent_night_out.json";
String eventDataJSON3 = "smarthome_work_at_home.json"; //use same for family dinner

SamplePlayer sp;
SamplePlayer sptext;
SamplePlayer sp1;
SamplePlayer sp2;
SamplePlayer sp3;
SamplePlayer sp4;
SamplePlayer sp5;
SamplePlayer sp6;
SamplePlayer sp7;
SamplePlayer sp8;
SamplePlayer sp9;
SamplePlayer sp10;
SamplePlayer sp11;
SamplePlayer sp12;
SamplePlayer sp13;





Gain g;
Glide val;

PriorityQueue pq;


NotificationServer server;
ArrayList<Notification> notifications;
ControlP5 button;
ControlP5 toggle;
DropdownList p1, p2, p3; 



Example example;

void setup() {
  size(740, 640); //size(width, height) must be the first line in setup()

  button = new ControlP5(this);
  toggle = new ControlP5(this);
  ac = new AudioContext(); //ac is defined in helper_functions.pde
  ac.start();


  sp = getSamplePlayer("family dinner.wav"); 
  sp1 = getSamplePlayer("parents night out.wav");
  sp2 = getSamplePlayer("party.wav");
  sp3 = getSamplePlayer("work from home.mp3");
  sp4 = getSamplePlayer("error.mp3");
  sp5 = getSamplePlayer("fire.wav");
  sp6 = getSamplePlayer("front porch.wav");
  sp7 = getSamplePlayer("garage.wav");
  sp8 = getSamplePlayer("cry.wav");
  sp9 = getSamplePlayer("doorbell.wav");  
  sp10 = getSamplePlayer("phone.wav");
  sp11 = getSamplePlayer("delivery.wav");
  sp12 = getSamplePlayer("dog.wav");
  sp13 = getSamplePlayer("cat.wav");






  g = new Gain(ac, 1, 0.5);
  val = new Glide(ac, 0.0, 30);   
  ac.out.addInput(g);


  //this will create WAV files in your data directory from input speech 
  //which you will then need to hook up to SamplePlayer Beads
  ttsMaker = new TextToSpeechMaker();

  String exampleSpeech = "Text to speech is okay, I guess.";

  //ttsExamplePlayback(exampleSpeech); //see ttsExamplePlayback below for usage

  //START NotificationServer setup
  server = new NotificationServer();

  //instantiating a custom class (seen below) and registering it as a listener to the server
  example = new Example();
  server.addListener(example);

  //loading the event stream, which also starts the timer serving events
  //server.loadEventStream(eventDataJSON1);

  //END NotificationServer setup

  button.addButton("Party")
    .setPosition(10, 150)
    .setSize(100, 40)
    ; 

  button.addButton("Family_Dinner")
    .setPosition(120, 150)
    .setSize(100, 40)
    ; 

  button.addButton("Parents_Night_Out")
    .setPosition(10, 90)
    .setSize(100, 40)
    ; 

  button.addButton("Work_At_Home")
    .setPosition(120, 90)
    .setSize(100, 40)
    ; 

  button.addButton("Locator")
    .setPosition(425, 210)
    .setSize(50, 40)
    ; 


  p1 = toggle.addDropdownList("Object", 400, 80, 100, 120); 
  customize3(p1); 
  p2 = toggle.addDropdownList("People", 280, 80, 100, 120); 
  customize2(p2); 
  p3 = toggle.addDropdownList("Location", 520, 80, 100, 120); 
  customize1(p3); 

  pq = new PriorityQueue(eventDataJSON2.length() + eventDataJSON1.length() + eventDataJSON3.length());
}

Notification first;

Boolean checkappliance = false;
Boolean housekeeper = false;
String note;
String noteError;
String message;
String delivery;
String dog;





void draw() {
  //this method must be present (even if empty) to process events such as keyPressed()  
  background(0);  //fills the canvas with black (0) each frame
  //sp.start();
  sp.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  sp1.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  sp2.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  sp3.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);


  if (!pq.isEmpty()) {
    first = (Notification) pq.poll();
    if (first.getTag().equals("spouse_1") && party) {
      //ttsMaker = new TextToSpeechMaker();
      String exampleSpeech = "Spouse 1 is in the " + first.getLocation();
      //ttsExamplePlayback(exampleSpeech);
    } 
    if (first.getFlag().equals("error") && first.getType().toString().equals("ApplianceStateChange") && first.getPriorityLevel() == 1) {

      val.setValue(2);
      g.addInput(sp4);
      g.setGain(1);
      ac.out.addInput(g);
      //ac.start();
      sp4.start();
      if (first.getTag().toString().equals("wifi")) {
        noteError = "Wifi DNS error";
      } else {
        noteError = first.getTag() + " " + first.getNote();
      }
      sp4.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
          sp4.pause(true);
          String exampleSpeech = noteError;
          //ttsMaker = new TextToSpeechMaker();
          ttsExamplePlayback(exampleSpeech);
          sp4.setToLoopStart();
          sp4.pause(true);
          val.setValue(1);
        }
      }
      );
      sp.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {      
          sp.pause(true);
          //first = (Notification) pq.poll();
          sp.setToLoopStart();
          sp.pause(true);
          println("end listener works");
          val.setValue(1);
        }
      }
      );
    } 
    if (first.getFlag().equals("on") && first.getType().toString().equals("ApplianceStateChange") && first.getTag().toString().equals("stove") && !first.getNote().toString().equals("") && first.getPriorityLevel() == 1) {
      val.setValue(2);
      g.addInput(sp5);
      g.setGain(1);
      ac.out.addInput(g);
      //ac.start();
      sp5.start();
      note = first.getNote();
      sp5.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
          sp5.pause(true);
          String exampleSpeech = note;
          //String exampleSpeech = "test";
          ttsExamplePlayback(exampleSpeech);
          sp5.setToLoopStart();
          val.setValue(1);
          //checkappliance = true;
        }
      }
      );
      sp.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {      
          sp.pause(true);
          //first = (Notification) pq.poll();
          sp.setToLoopStart();
          sp.pause(true);
          val.setValue(1);
        }
      }
      );
    }
    if (first.getTag().toString().equals("tv_remote") && first.getPriorityLevel() == 1 && first.getFlag().toString().equals("on")) {
      val.setValue(2);
      g.setGain(1);
      ac.out.addInput(g);
      //ac.start();
      String exampleSpeech = "The tv is " + first.getFlag();
      ttsExamplePlayback(exampleSpeech);
    }
    if (parents && first.getFlag().equals("on") && first.getType().toString().equals("ApplianceStateChange") && first.getTag().toString().equals("lights") && first.getLocation().toString().equals("kids bedroom")) {
      val.setValue(2);
      g.addInput(sp4);
      g.setGain(1);
      ac.out.addInput(g);
      //ac.start();
      sp4.start();
      sp4.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
          sp5.pause(true);
          String exampleSpeech = "kids bedroom lights on";
          ttsExamplePlayback(exampleSpeech);
          sp4.setToLoopStart();
          val.setValue(1);
          checkappliance = true;
        }
      }
      );
      sp.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {      
          sp.pause(true);
          //first = (Notification) pq.poll();
          sp.setToLoopStart();
          sp.pause(true);
          val.setValue(1);
        }
      }
      );
    }
    if ((parents || work) && first.getFlag().equals("on") && first.getTag().toString().equals("housekeeper") && first.getLocation().toString().equals("garage") && !housekeeper) {
      val.setValue(2);
      g.addInput(sp7);
      g.setGain(1);
      ac.out.addInput(g);
      //ac.start();
      sp7.start();
      housekeeper = true;
      sp7.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
          sp7.pause(true);
          String exampleSpeech = "housekeeper";
          ttsExamplePlayback(exampleSpeech);
          sp7.setToLoopStart();
          val.setValue(1);
        }
      }
      );
      sp.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {      
          sp.pause(true);
          //first = (Notification) pq.poll();
          sp.setToLoopStart();
          sp.pause(true);
          val.setValue(1);
        }
      }
      );
    }
    if (first.getFlag().equals("on") && (first.getTag().toString().equals("spouse_1") || first.getTag().toString().equals("spouse_2") || first.getTag().toString().equals("kid_2") || first.getTag().toString().equals("kid_1")) && (first.getLocation().toString().equals("front porch") || first.getLocation().toString().equals("back porch"))) {
      val.setValue(2);
      g.addInput(sp6);
      g.setGain(1);
      ac.out.addInput(g);
      //ac.start();
      sp6.start();
      housekeeper = true;
      sp6.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
          if (first.getTag().toString().equals("kid_1") || first.getTag().toString().equals("kid_2")) {
            sp6.pause(true);
            g.addInput(sp8);
            g.setGain(1);
            ac.out.addInput(g);
            sp8.start(); 
            sp6.setToLoopStart();
            val.setValue(1);
          } else {
            sp6.pause(true);
            sp6.setToLoopStart();
            val.setValue(1);
          }
        }
      }
      );
    }
    if (first.getType().toString().equals("Message") && first.getPriorityLevel() == 1 && !party) {
      val.setValue(2);
      g.addInput(sp10);
      g.setGain(1);
      ac.out.addInput(g);
      //ac.start();
      sp10.start();
      message = first.getNote();
      sp10.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
          sp10.pause(true);
          String exampleSpeech = message;
          ttsExamplePlayback(exampleSpeech);
          sp10.setToLoopStart();
          val.setValue(1);
        }
      }
      );
      sp.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {      
          sp.pause(true);
          //first = (Notification) pq.poll();
          sp.setToLoopStart();
          sp.pause(true);
          val.setValue(1);
        }
      }
      );
    }

    if (first.getType().toString().equals("Message") && !(first.getPriorityLevel() == 1) && !party) {
      val.setValue(2);
      g.addInput(sp10);
      g.setGain(1);
      ac.out.addInput(g);
      //ac.start();
      sp10.start();
      sp10.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
          sp10.pause(true);
          String exampleSpeech = "You have a message";
          ttsExamplePlayback(exampleSpeech);
          sp10.setToLoopStart();
          val.setValue(1);
        }
      }
      );
      sp.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {      
          sp.pause(true);
          //first = (Notification) pq.poll();
          sp.setToLoopStart();
          sp.pause(true);
          val.setValue(1);
        }
      }
      );
    }
    if (first.getType().toString().equals("PackageDelivery") && (first.getPriorityLevel() == 1) && !party) {
      val.setValue(2);
      g.addInput(sp11);
      g.setGain(1);
      ac.out.addInput(g);
      //ac.start();
      sp11.start();
      delivery = first.getNote();
      sp11.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
          sp11.pause(true);
          String exampleSpeech = "Delivery from " + delivery;
          ttsExamplePlayback(exampleSpeech);
          sp11.setToLoopStart();
          val.setValue(1);
        }
      }
      );
      sp.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {      
          sp.pause(true);
          //first = (Notification) pq.poll();
          sp.setToLoopStart();
          sp.pause(true);
          val.setValue(1);
        }
      }
      );
    }
    if (first.getTag().toString().equals("dog") && (first.getPriorityLevel() == 1)) {
      val.setValue(2);
      g.addInput(sp12);
      g.setGain(1);
      ac.out.addInput(g);
      //ac.start();
      sp12.start();
      dog = first.getLocation();
      sp12.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
          sp12.pause(true);
          String exampleSpeech = dog;
          ttsExamplePlayback(exampleSpeech);
          sp12.setToLoopStart();
          val.setValue(1);
        }
      }
      );
      sp.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {      
          sp.pause(true);
          //first = (Notification) pq.poll();
          sp.setToLoopStart();
          sp.pause(true);
          val.setValue(1);
        }
      }
      );
    }
    if (first.getTag().toString().equals("cat") && (first.getPriorityLevel() == 1)) {
      val.setValue(2);
      g.addInput(sp13);
      g.setGain(1);
      ac.out.addInput(g);
      //ac.start();
      sp13.start();
      dog = first.getLocation();
      sp13.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
          sp13.pause(true);
          String exampleSpeech = dog;
          ttsExamplePlayback(exampleSpeech);
          sp13.setToLoopStart();
          val.setValue(1);
        }
      }
      );
      sp.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {      
          sp.pause(true);
          //first = (Notification) pq.poll();
          sp.setToLoopStart();
          sp.pause(true);
          val.setValue(1);
        }
      }
      );
    }
    if (first.getTag().toString().equals("mobile phone") && (first.getPriorityLevel() == 1)) {
      val.setValue(2);
      g.addInput(sp10);
      g.setGain(1);
      ac.out.addInput(g);
      //ac.start();
      sp10.start();
      dog = first.getLocation();
      sp10.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
          sp10.pause(true);
          String exampleSpeech = "Phone left in " + dog;
          ttsExamplePlayback(exampleSpeech);
          sp10.setToLoopStart();
          val.setValue(1);
        }
      }
      );
      sp.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {      
          sp.pause(true);
          //first = (Notification) pq.poll();
          sp.setToLoopStart();
          sp.pause(true);
          val.setValue(1);
        }
      }
      );
    }
  }
}

void keyPressed() {
  //example of stopping the current event stream and loading the second one
  if (key == RETURN || key == ENTER) {
    server.stopEventStream(); //always call this before loading a new stream
    server.loadEventStream(eventDataJSON2);
    //println("**** New event stream loaded: " + eventDataJSON2 + " ****");
  }
}

//in your own custom class, you will implement the NotificationListener interface 
//(with the notificationReceived() method) to receive Notification events as they come in
class Example implements NotificationListener {

  public Example() {
    //setup here
    //sp2.setEndListener(
    //new Bead() {
    //  public void messageReceived(Bead mess) {

    //  }
    //}
    //);
  }

  Boolean check = true;
  //this method must be implemented to receive notifications
  public void notificationReceived(Notification notification) { 
    println("<Example> " + notification.getType().toString() + " notification received at " 
      + Integer.toString(notification.getTimestamp()) + " ms");

    pq.add(notification);
    //println ("Priority q: " + pq + "ended ");


    String debugOutput = ">>> ";
    switch (notification.getType()) {
    case Door:
      debugOutput += "Door moved: ";
      break;
    case PersonMove:
      debugOutput += "Person moved: ";
      break;
    case ObjectMove:
      debugOutput += "Object moved: ";
      break;
    case ApplianceStateChange:
      debugOutput += "Appliance changed state: ";
      break;
    case PackageDelivery:
      debugOutput += "Package delivered: ";
      break;
    case Message:
      debugOutput += "New message: ";
      break;
    }
    debugOutput += notification.toString();
    //debugOutput += notification.getLocation() + ", " + notification.getTag();

    println(debugOutput);

    //You can experiment with the timing by altering the timestamp values (in ms) in the exampleData.json file
    //(located in the data directory)
  }
}

void ttsExamplePlayback(String inputSpeech) {
  //create TTS file and play it back immediately
  //the SamplePlayer will remove itself when it is finished in this case

  String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
  println("File created at " + ttsFilePath);

  //createTTSWavFile makes a new WAV file of name ttsX.wav, where X is a unique integer
  //it returns the path relative to the sketch's data directory to the wav file

  //see helper_functions.pde for actual loading of the WAV file into a SamplePlayer

  SamplePlayer sp = getSamplePlayer(ttsFilePath, true); 
  //true means it will delete itself when it is finished playing
  //you may or may not want this behavior!

  ac.out.addInput(sp);
  sp.setToLoopStart();
  sp.start();
  println("TTS: " + inputSpeech);
}

Boolean party = false;
void Party() {
  party = true;
  pq = new PriorityQueue();
  sp.pause(true);
  sp3.pause(true);
  sp1.pause(true);
  val.setValue(2);
  g.addInput(sp2);
  g.setGain(1);
  ac.out.addInput(g);
  sp2.start();
  server.stopEventStream(); //always call this before loading a new stream
  server.loadEventStream(eventDataJSON2);
}

Boolean family = false;
void Family_Dinner() {
  family = true;
  pq = new PriorityQueue();
  sp2.pause(true);
  sp3.pause(true);
  sp1.pause(true);
  val.setValue(1);
  g.addInput(sp);
  g.setGain(1);
  ac.out.addInput(g);
  sp.start();
  server.stopEventStream(); //always call this before loading a new stream
  server.loadEventStream(eventDataJSON3);
  println("Priority queue: " + pq + "end ");
}

Boolean work = false;
void Work_At_Home() {
  work = true;
  pq = new PriorityQueue();
  sp2.pause(true);
  sp.pause(true);
  sp1.pause(true);
  val.setValue(0.5);
  g.addInput(sp3);
  g.setGain(1);
  ac.out.addInput(g);
  sp3.start();
  server.stopEventStream(); //always call this before loading a new stream
  server.loadEventStream(eventDataJSON3);
}

Boolean parents = false;
void Parents_Night_Out() {
  parents = true;
  pq = new PriorityQueue();
  sp2.pause(true);
  sp3.pause(true);
  sp.pause(true);
  g.addInput(sp1);
  g.setGain(1);
  ac.out.addInput(g);
  sp1.start();
  server.stopEventStream(); //always call this before loading a new stream
  server.loadEventStream(eventDataJSON1);
}

Boolean locator = false;
void Locator() {
   float object = customize3(p1);
   float person = customize2(p2);
   float location = customize1(p3);     
   if (object == 4 && (location == 4 || location == 5 || location == 6)){
      val.setValue(1);
      g.addInput(sp12);
      g.setGain(0.5);
      sp12.start();
      sp12.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
            sp12.pause(true);
            g.addInput(sp6);
            sp6.start(); 
            sp6.setToLoopStart();
            val.setValue(1);
        }
      }
      );
   }
   if (object == 3 && (location == 4 || location == 5 || location == 6)){
      val.setValue(1);
      g.addInput(sp13);
      g.setGain(0.5);
      sp13.start();
      sp13.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
            sp13.pause(true);
            g.addInput(sp6);
            sp6.start(); 
            sp6.setToLoopStart();
            val.setValue(1);
        }
      }
      );
   }
   if (object == 3 && (location == 9 || location == 10 || location == 11)){
      val.setValue(1);
      g.addInput(sp13);
      g.setGain(0.5);
      sp13.start();
      sp13.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
            sp13.pause(true);
            String exampleSpeech = "bedroom";
            ttsExamplePlayback(exampleSpeech);
            sp13.setToLoopStart();
            val.setValue(1);
        }
      }
      );
   }
   if (object == 4 && (location == 7 || location == 8)){
      val.setValue(1);
      g.addInput(sp12);
      g.setGain(0.5);
      sp12.start();
      sp12.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
            sp12.pause(true);
            String exampleSpeech = "bathroom";
            ttsExamplePlayback(exampleSpeech);
            sp12.setToLoopStart();
            val.setValue(1);
        }
      }
      );
   }
   if (object == 3 && (location == 7 || location == 8)){
      val.setValue(1);
      g.addInput(sp13);
      g.setGain(0.5);
      sp13.start();
      sp13.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
            sp13.pause(true);
            String exampleSpeech = "bathroom";
            ttsExamplePlayback(exampleSpeech);
            sp13.setToLoopStart();
            val.setValue(1);
        }
      }
      );
   }
   if (object == 4 && (location == 9 || location == 10 || location == 11)){
      val.setValue(1);
      g.addInput(sp12);
      g.setGain(0.5);
      sp12.start();
      sp12.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
            sp12.pause(true);
            String exampleSpeech = "bedroom";
            ttsExamplePlayback(exampleSpeech);
            sp12.setToLoopStart();
            val.setValue(1);
        }
      }
      );
   }
      
   if (object == 4 && (location == 0 || location == 1 || location == 2)){
      val.setValue(1);
      g.addInput(sp12);
      g.setGain(0.5);
      sp12.start();
      sp12.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
            sp12.pause(true);
            String exampleSpeech = "common space";
            ttsExamplePlayback(exampleSpeech);
            sp12.setToLoopStart();
            val.setValue(1);
        }
      }
      );
   }
   if (object == 3 && (location == 0 || location == 1 || location == 2)){
      val.setValue(1);
      g.addInput(sp13);
      g.setGain(0.5);
      sp13.start();
      sp13.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
            sp13.pause(true);
            String exampleSpeech = "common space";
            ttsExamplePlayback(exampleSpeech);
            sp13.setToLoopStart();
            val.setValue(1);
        }
      }
      );
   }
   if ((person == 2 || person == 3) && (location == 0 || location == 1 || location == 2)){
      val.setValue(1);
      g.addInput(sp8);
      g.setGain(0.5);
      sp8.start();
      sp8.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
            sp13.pause(true);
            String exampleSpeech = "common space";
            ttsExamplePlayback(exampleSpeech);
            sp13.setToLoopStart();
            val.setValue(1);
        }
      }
      );
   }
   if ((person == 2 || person == 3) && (location == 9 || location == 10 || location == 11)){
      val.setValue(1);
      g.addInput(sp8);
      g.setGain(0.5);
      sp8.start();
      sp8.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
            sp13.pause(true);
            String exampleSpeech = "bedroom";
            ttsExamplePlayback(exampleSpeech);
            sp13.setToLoopStart();
            val.setValue(1);
        }
      }
      );
   }
   if ((person == 2 || person == 3) && (location == 7 || location == 8)){
      val.setValue(1);
      g.addInput(sp8);
      g.setGain(0.5);
      sp8.start();
      sp8.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
            sp13.pause(true);
            String exampleSpeech = "bathroom";
            ttsExamplePlayback(exampleSpeech);
            sp13.setToLoopStart();
            val.setValue(1);
        }
      }
      );
   }
   if ((person == 2 || person == 3) && (location == 4 || location == 5 || location == 6)){
      val.setValue(1);
      g.addInput(sp8);
      g.setGain(0.5);
      sp8.start();
      sp8.setEndListener(
        new Bead() {
        public void messageReceived(Bead mess) {
            sp8.pause(true);
            g.addInput(sp6);
            sp6.start(); 
            sp6.setToLoopStart();
            val.setValue(1);
        }
      }
      );
   }
}

float customize1(DropdownList ddl) { 
  ddl.setBackgroundColor(color(190)); 
  ddl.setItemHeight(20); 
  ddl.setBarHeight(15); 
  ddl.addItem("Kitchen", 1); 
  ddl.addItem("Living Room", 2);  
  ddl.addItem("Family Room", 3); 
  ddl.addItem("Utility Room", 4);
  ddl.addItem("Garage", 5); 
  ddl.addItem("Front Porch", 6); 
  ddl.addItem("Back Porch", 7); 
  ddl.addItem("Master Bath", 8);
  ddl.addItem("Guest Bath", 9); 
  ddl.addItem("Master Bedroom", 10); 
  ddl.addItem("Kids Bedroom", 11);
  ddl.addItem("Guest Bedroom", 12); 
  ddl.setColorBackground(color(60)); 
  ddl.setColorActive(color(255, 128));
  float value = ddl.getValue();
  return value;
} 

float customize2(DropdownList ddl) { 
  ddl.setBackgroundColor(color(190)); 
  ddl.setItemHeight(20); 
  ddl.setBarHeight(15); 
  ddl.addItem("Spouse 1", 1); 
  ddl.addItem("Spouse 2", 2); 
  ddl.addItem("Kid", 3); 
  ddl.addItem("Kid 2", 4); 
  ddl.addItem("Housekeeper", 5); 
  ddl.addItem("Babysitter", 6); 
  ddl.addItem("Guest", 7); 
  ddl.setColorBackground(color(60)); 
  ddl.setColorActive(color(255, 128));
  float value = ddl.getValue();
  return value;
} 

//String object = customize3(ddl);

float customize3(DropdownList ddl) { 
  ddl.setBackgroundColor(color(190)); 
  ddl.setItemHeight(20); 
  ddl.setBarHeight(15); 
  ddl.addItem("Car Keys", 1); 
  ddl.addItem("Mobile Phone", 2);
  ddl.addItem("TV Remote", 3); 
  ddl.addItem("Cat", 4); 
  ddl.addItem("Dog", 5); 
  ddl.setColorBackground(color(60)); 
  ddl.setColorActive(color(255, 128));
  float value = ddl.getValue();
  return value;
} 
