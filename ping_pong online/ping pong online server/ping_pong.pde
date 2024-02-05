// Server/client pakken importeres.
import processing.net.*;

// Variabler deklareres.
float ballX;
float ballY;
float xSpeed;
float ySpeed;
float r;
boolean gameOnGoing;
float clientMouseY;

Server myServer;


void setup() {
  // Størrelse på canvas sættes. Da vi bruger sphere, som er i det rumlige koordinatsystem, tilføjes P3D som indikation på et z-koordinat.
  size(1000, 600, P3D);
  
  // Attributter sættes i start().
  start();
  
  // Rektangler sættes til at have koordinater angivet i centrum.
  rectMode(CENTER);
  
  // Tekststørrelse sættes mht. "YOU WIN" eller "YOU LOSE".
  textSize(150);
  
  // Tekst sættes til at have koordinater angivet i centrum.
  textAlign(CENTER);
  
  // Serveren deklareres.
  myServer = new Server(this, 5204);
}

// En funktion start() opsættes, så det nemt kan genstartes mht. at trykke r, når spiller er ovre.
void start() {
  // Bolden starter i centrum.
  ballX = width/2;
  ballY = height/2;
  
  // Bolden bevæger sig 2,5 gange så hurtigt horizontalt sammenlignet med vertikalt.
  xSpeed = random(-1000.1000);
  ySpeed = random(-400.400);
  
  // Spherens radius sættes.
  r = 15;
  
  // boolean værdien som indikere om spillet er i gang sættes til true.
  gameOnGoing = true;
}

void draw() {
  // Baggrunden sættes til sort.
  background(0);

  // Koordinatsættet gemmes, som det er nu.
  pushMatrix();

  // Midten af canvas sættes til boldens koordinater.
  // Da bolden er en sphere, tegnes den i centrum.
  translate(ballX, ballY, 0);

  // Noget mht. detaljer på bolden.
  noStroke();

  // Bolden tegnes med en radius på r
  sphere(r);

  // Det gamle koordinatsæt hentes igen.
  popMatrix();

  // Der søges efter klientens besked, som indeholder dens mouseY.
  Client thisClient = myServer.available();
  if (thisClient != null) {
    clientMouseY = float(thisClient.readString());
  }

  // Spillerne tegnes.
  // Server tegnes.
  rect(20, mouseY, 10, 60);

  // Klient tegnes.
  rect(980, clientMouseY, 10, 60);

  // Afhængig af boldens retning, skal xSpeed, som adderes til dens koordinater enten være negativ eller positiv.
  if (xSpeed > 0) {
    xSpeed++;
  } else if (xSpeed < 0) {
    xSpeed--;
  }

  // Her for ySpeed.
  if (ySpeed > 0) {
    ySpeed++;
  } else if (ySpeed < 0) {
    ySpeed--;
  }


  // Her øges boldens hastighed.
  ballX += xSpeed/500;
  ballY += ySpeed/500;


  // Her er betingelserne, som undersøger, om spillet stadig er kørende.
  // Der tjekker om bolden er ude for skærmen til venstre.
  // Hvis den er, så dør server spilleren.
  if (ballX < 0) {
    text("YOU LOSE", width/2, height/2);
    gameOnGoing = false;
  }

  // Der tjekkes om bolden er ude for skærmen til højre.
  // Hvis den er, så dør klient spilleren.
  if (ballX > width) {
    text("YOU WIN", width/2, height/2);
    gameOnGoing = false;
  }


  // Da ySpeed ikke skal ændrer sig ifm. at ramme en af spillerne, sættes den før ændringer mht. xSpeed.
  // xSpeed skal reagerer meget anderledes, afhængig af, om en spiller rammer dem eller ej.
  // Men ySpeed skal kun ændre sig, hvis den ramme "loftet" eller "gulvet".
  if (ballY + r > height || ballY - r < 0) {
    ySpeed = ySpeed * -1;
  }

  // Disse betingelser undersøger, om bolden er i spillernes "rækkevidde"
  // Den her tjekker for serveren
  if (ballX - r > 17 && ballX - r < 28 && ballY - 30 < mouseY && ballY + 30 > mouseY) {
    xSpeed = xSpeed * -1;
    println("DING");
  }

  // Den her tjekker for klienten
  if (ballX + r < 983 && ballX + r > 972 && ballY - 30 < clientMouseY && ballY + 30 > clientMouseY) {
    xSpeed = xSpeed * -1;
    println("DING");
  }

  // Her sendes informationen til klienten.
  // Informationen der sendes, er denne spillers y-position, boldens koordinater og radius.
  myServer.write(mouseY + "," + ballX + "," + ballY + "," + r);
}

// Hvis spillet ikke er kørende, kan serveren trykke på 'r' for at genstarte spillet.
void keyPressed() {
  if ((key == 'R' || key == 'r') && !gameOnGoing) {
    start();
    
    // Der printes nogle tomme linjer, da println siger "DING!", når spillerne rammer bolden.
    println(" ");
    println(" ");
    println(" ");
    println(" ");
    println(" ");
  }
}
