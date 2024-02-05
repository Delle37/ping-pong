// Server/client pakken importeres.
import processing.net.*;

// Variabler deklareres (og få initieres).
Client myClient;
String[] data = new String[4];
String dataIn;
float serverMouseY;
float ballX;
float ballY;
float r;

void setup() {
  // Størrelsen på canvas sættes. Da vi bruger sphere, som er i det rumlige koordinatsystem, tilføjes P3D som indikation på et z-koordinat.
  size(1000,600,P3D);
  
  // Rektangler sættes til at have koordinater angivet i centrum.
  rectMode(CENTER);
  
  // Klienten sættes til at forbinde til serveren. (Som standard forbinder den til sig selv, ændrer det)
  myClient = new Client(this,"127.0.0.1",5204);
  
  // Tekststørrelse sættes, og bruges mht. "YOU WIN" eller "YOU LOSE".
  textSize(150);
  
  // Tekst sættes til at have koordinater angivet i centrum.
  textAlign(CENTER);
}

void draw() {
  
  // Der undersøges, om klienten har modtaget noget fra serveren.
  // Det som den modtager, modtages i formattet vist nedenunder.
  // Det splittes op i et Stringarray, og lægges i variabler deklareret i toppen.
  if (myClient.available() > 0) {
    String dataIn = myClient.readString();
    data = split(dataIn,',');
    // data er opsat i denne orden
    // data[0] = server mouseY
    // data[1] = ballX
    // data[2] = ballY
    // data[3] = radius på sphere
    
    serverMouseY = float(data[0]);
    ballX = float(data[1]);
    ballY = float(data[2]);
    r = float(data[3]);
    
  }
  
  // Baggrundsfarven sættes til sort.
  background(0);
  
  // Spillerne tegnes.
  // Server tegnes.
  rect(20,serverMouseY,10,60);
  
  // Klient tegnes
  rect(980, mouseY, 10, 60);
  
  // Det nuværende koordinatsæt gemmes.
  pushMatrix();
  
  // Da sphere tegnes i centrum, skal vi sætte 0,0 til at være dens koordinater.
  translate(ballX,ballY);
  
  // Noget mht. detaljer på bolden.
  noStroke();
  
  // Sphere tegnes med radius r.
  sphere(r);
  
  // Det gamle koordinatsæt hentes.
  popMatrix();
  
  // Her er betingelserne for, om man har tabt eller vundet.
  // Hvis bolden er ude for skærmen til højre, har klienten tabt.
  if (ballX > width) {
    text("YOU LOSE",width/2,height/2);
  }
  
  //Hvis bolden er ude for skærmen til venstre, har klienten vundet.
  if (ballX < 0) {
    text("YOU WIN",width/2,height/2);
  }
  
  
  // Klienten sender sit mouseY, som bestemmer hvor dens rektangle er.
  // Det sendes som en string, da det ellers ville blive sendt som en værdi af %255.
  // Ved server delen konverteres det fra en string til en float, da det er koordinater.
  myClient.write(str(mouseY));
}
