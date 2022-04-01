/**
 * Definición de un tablero para el juego de Othello
 * @author Rodrigo Colín
 */
class Tablero {
  /**
   * Cantidad de casillas en horizontal y vertical del tablero
   */
  int dimension;

  /**
   * El tamaño en pixeles de cada casilla cuadrada del tablero
   */
  int tamCasilla;

  /**
   * Representación lógica del tablero. El valor númerico representa:
   * 0 = casilla vacia
   * 1 = casilla con ficha del primer jugador
   * 2 = casilla con ficha del segundo jugador
   */
  int[][] mundo;

  /**
   * Representa de quién es el turno bajo la siguiente convención:
   * true = turno del jugador 1
   * false = turno del jugador 2
   */
  boolean turno;
  
  /**
   * Contador de la cantidad de turnos en el tablero
   */
  int numeroDeTurno;

  /**
   * Constructor base de un tablero. 
   * @param dimension Cantidad de casillas del tablero, comúnmente ocho.
   * @param tamCasilla Tamaño en pixeles de cada casilla
   */
  Tablero(int dimension, int tamCasilla) {
    this.dimension = dimension;
    this.tamCasilla = tamCasilla;
    turno = true;
    numeroDeTurno = 0;
    mundo = new int[dimension][dimension];
    // Configuración inicial (colocar 4 fichas al centro del tablero):
    mundo[(dimension/2)-1][dimension/2] = 1;
    mundo[dimension/2][(dimension/2)-1] = 1;
    mundo[(dimension/2)-1][(dimension/2)-1] = 2;
    mundo[dimension/2][dimension/2] = 2;
    movimientos(1);
  }

  /**
   * Constructor por default de un tablero con las siguientes propiedades:
   * Tablero de 8x8 casillas, cada casilla de un tamaño de 60 pixeles,
   */
  Tablero() {
    this(8, 60);
  }

  /**
   * Dibuja en pantalla el tablero, es decir, dibuja las casillas y las fichas de los jugadores
   */
  void display() {
    color fondo = color(109, 227, 213); // El color de fondo del tablero
    color linea = color(0); // El color de línea del tablero
    int grosor = 2; // Ancho de línea (en pixeles)
    color jugador1 = color(0); // Color de ficha para el primer jugador
    color jugador2 = color(255); // Color de ficha para el segundo jugador
    color jugada = color(93, 0, 255);
    
    // Doble iteración para recorrer cada casilla del tablero
    for (int i = 0; i < dimension; i++)
      for (int j = 0; j < dimension; j++) {
        // Dibujar cada casilla del tablero:
        fill(fondo); // establecer color de fondo
        stroke(linea); // establecer color de línea
        strokeWeight(grosor); // establecer ancho de línea
        rect(i*tamCasilla, j*tamCasilla, tamCasilla, tamCasilla);

        // Dibujar las fichas de los jugadores:
        if(mundo[i][j] == 3){
          stroke(jugada);
          noFill();
          ellipse(i*tamCasilla+(tamCasilla/2), j*tamCasilla+(tamCasilla/2), tamCasilla*3/5, tamCasilla*3/5);
        }
        if (mundo[i][j] != 0 && (mundo[i][j] == 1 || mundo[i][j] == 2)) { // en caso de que la casilla no esté vacia
          fill(mundo[i][j] == 1 ? jugador1 : jugador2); // establecer el color de la ficha
          noStroke(); // quitar contorno de línea
          ellipse(i*tamCasilla+(tamCasilla/2), j*tamCasilla+(tamCasilla/2), tamCasilla*3/5, tamCasilla*3/5);
        }
      }
  }

  /**
   * Coloca o establece una ficha en una casilla específica del tablero.
   * Nota: El eje vertical está invertido y el conteo empieza en cero.
   * @param posX Coordenada horizontal de la casilla para establecer la ficha
   * @param posX Coordenada vertical de la casilla para establecer la ficha
   * @param turno Representa el turno o color de ficha a establecer
   */
  void setFicha(int posX, int posY, boolean turno) {
    mundo[posX][posY] = turno ? 1 : 2;
  }
  void limpiaMovimientos(){
    for(int i=0;i<8;i++){
          for(int j=0;j<8;j++){
            if(mundo[i][j]==3)
              mundo[i][j]=0;
          }
    }
  }
  void llenaMovimientos(int x, int y,int incrX,int incrY,int fichaC){
    int ultimaFicha=0;
    try{
      while(estaOcupado(x,y)){
        ultimaFicha = mundo[x][y];
        x+=incrX;
        y+=incrY;
       }
       if(ultimaFicha==fichaC){
         mundo[x][y] = 3;
       }
     }catch(Exception e){} 
  }
  void movimientos(int t){
    //if(turno){
        int fichaC = t==1 ?2:1;
        for(int i=0;i<8;i++){
          for(int j=0;j<8;j++){
            if(mundo[i][j]==t){
                //Hacia abajo
                llenaMovimientos(i,j+1,0,1,fichaC);
                
                //Hacia arriba
                llenaMovimientos(i,j-1,0,-1,fichaC);
                
                //Hacia la derecha
                llenaMovimientos(i+1,j,1,0,fichaC);
                
                //Hacia la izquierda
                llenaMovimientos(i-1,j,-1,0,fichaC);
                
                //Diagonal derecha arriba
                llenaMovimientos(i+1,j-1,1,-1,fichaC);
                
                //Diagonal derecha abajo
                llenaMovimientos(i+1,j+1,1,1,fichaC);
                
                //Diagonal izquierda arriba
                llenaMovimientos(i-1,j-1,-1,-1,fichaC);
                
                //Diagonal izquierda abajo
                llenaMovimientos(i-1,j+1,-1,1,fichaC);
            }
          }
        }
        if(cantidadFichas().x+cantidadFichas().y == 64){
          if(cantidadFichas().x == cantidadFichas().y){
            javax.swing.JOptionPane.showMessageDialog(null, "Empate con: "+cantidadFichas().y+" fichas vs " + cantidadFichas().x+ " fichas negras");
          }else if(cantidadFichas().x < cantidadFichas().y){
            javax.swing.JOptionPane.showMessageDialog(null, "Ganan las fichas blancas con: "+cantidadFichas().y+" fichas vs " + cantidadFichas().x+ " fichas negras");
          }else{
            javax.swing.JOptionPane.showMessageDialog(null, "Ganan las fichas negras con: "+cantidadFichas().x+" fichas vs " + cantidadFichas().y+ " fichas blancas");
          }
        }
        if(!hayJugada() && cantidadFichas().x+cantidadFichas().y != 64){
          String s = fichaC == 1? "fichas balncas":"fichas negras";
          javax.swing.JOptionPane.showMessageDialog(null, "No hay movimientos por hacer para las "+s+", cambio de turno");
          cambiarTurno();
          movimientos(fichaC);
        }
    //}
  }
  boolean hayJugada(){
     for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
          if(mundo[i][j]==3){
            return true;
          }
        }
     }
     return false;
  }
 
  private void setGanadas(int x,int y,int t,int posX,int posY,int camX,int camY){
    try{
      while(estaOcupado(x,y) && mundo[x][y] != t){
        y +=camY;
        x +=camX;
      }
      while((y != posY || x != posX)  && estaOcupado(x,y)){
        mundo[x][y] = t;
        setFicha(x,y,this.turno);
        y+=(camY*-1);
        x+=(camX*-1);
      }
    }catch(Exception e){}
  }
  /**
   * Coloca o establece una ficha en una casilla específica del tablero segun el turno del tablero.
   * @param posX Coordenada horizontal de la casilla para establecer la ficha
   * @param posX Coordenada vertical de la casilla para establecer la ficha
   */
  void setFicha(int posX, int posY){
    /*Si se clickea una casilla que no sea valida para cambiar, se sale, para que no 
    cambie el turno y no cambie fichas*/
    if(mundo[posX][posY]!=3)
      return;
    if(mundo[posX][posY]==3)
      this.setFicha(posX, posY, this.turno);     
      
    int t = this.turno ?1:2;
    
    //Revisa arriba
    setGanadas(posX,posY-1,t,posX,posY,0,-1);
    
    //Revisa abajo
    setGanadas(posX,posY+1,t,posX,posY,0,1);
    
    //Revisa derecha
    setGanadas(posX+1,posY,t,posX,posY,1,0);
    
    //Revisa izquierda
    setGanadas(posX-1,posY,t,posX,posY,-1,0);
   
    //Revisa diagonal izquierda arriba
    setGanadas(posX-1,posY-1,t,posX,posY,-1,-1);
    
    //Revisa diagonal izquierda abajo
    setGanadas(posX-1,posY+1,t,posX,posY,-1,1);
    
    //Revisa diagonal derecha arriba
    setGanadas(posX+1,posY-1,t,posX,posY,1,-1);
   
    //Revisa diagonal derecha abajo
    setGanadas(posX+1,posY+1,t,posX,posY,1,1);
    
    cambiarTurno();
  }

  /**
   * Representa el cambio de turno. Normalmente representa la última acción del turno
   */
  void cambiarTurno() {
    turno = !turno;
    numeroDeTurno += 1;
  }
  boolean getTurno(){
     return  this.turno;
  }
  /**
   * Verifica si en la posición de una casilla dada existe una ficha (sin importar su color)
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   * @return True si hay una ficha de cualquier color en la casilla, false en otro caso
   */
  boolean estaOcupado(int posX, int posY) {
    if(posX < 0 || posX > 7 || posY < 0 || posY >7 ){
      return true;
    }
    return mundo[posX][posY] == 1 || mundo[posX][posY] == 2;
  }

  /**
   * Cuenta la cantidad de fichas de un jugador
   * @return La cantidad de fichas de ambos jugadores en el tablero como vector, 
   * donde x = jugador1, y = jugador2
   */
  PVector cantidadFichas() {
    PVector contador = new PVector();
    for (int i = 0; i < dimension; i++)
      for (int j = 0; j < dimension; j++){
        if(mundo[i][j] == 1)
          contador.x += 1;
        if(mundo[i][j] == 2)
          contador.y += 1;
      }
    return contador;
  }
}
