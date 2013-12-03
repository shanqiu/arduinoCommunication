import processing.video.*;

// Step 1. Declare Movie object
Movie movie; 

void setup() {
  size(320,240);
  
  // Step 2. Initialize Movie object
  // Movie file should be in data folder
  movie = new Movie(this, "angry.mov"); 
  
  // Step 3. Start movie playing
  movie.loop();
}

// Step 4. Read new frames from movie
void movieEvent(Movie movie) {
  movie.read();
}

void draw() {
  // Step 5. Display movie.
  image(movie,0,0);
}
