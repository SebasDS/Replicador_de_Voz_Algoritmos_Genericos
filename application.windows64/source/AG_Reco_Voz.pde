
import processing.sound.*;


AudioSample voz;
AudioSample mejor;


int l = 16000;
float[][] mejores=new float[2][l];
float aptitud_ant=0;
float aptitud_ant2=0;
int cont=-1;
int pop=50;
float[][] cromosomas=new float[pop][l];
float[] x=new float[l];
float tiempo = 0;
float[] Aptitudes=new float[pop];
float[][] error= new float[2][l];
int gen = 0;
int max_gen = 40;


public void setup() {
  size(900, 360);
  background(0);
  String[] lines = loadStrings("voz.txt");
  int c=1;
  int s=0;
  while(c!=lines[0].length()){
    String numero = "";
    while(lines[0].charAt(c)!=',' && c!=lines[0].length()-1){
      numero=numero+lines[0].charAt(c);
      c+=1;
    }
    x[s]=Float.parseFloat(numero);
    s+=1;
    c+=1;
  }
  //println(lines[0].charAt(0));
  voz = new AudioSample(this, x, 8000);
  voz.amp(1);
  voz.play();



  for(int i=0; i<pop; i++){
    for(int j=0; j<l; j++){
      cromosomas[i][j]=random(-0.5,0.5);
    }
  }

  for(int j=90; j<95; j++){
    print(x[j]+ "  ");
  }
  println("fin");
}

public void draw() {

    if(millis()<2000){
      fill(255);
      textAlign(CENTER);
      textSize(50);
      text("Original", width/2, height/2);
    }
    if(millis()-tiempo>2500 && gen<=max_gen){
      background(0);
      
      
      /////////Aptitud y Seleccion////////
      for(int i=0; i<pop; i++){
        float aptitud=l;
        float[] errores=new float [l];
        for(int t=0; t<l; t++){
            errores[t]=x[t]-cromosomas[i][t];
            
            //float penalizacion=error;                             //Penalizacion Lineal
            float penalizacion=pow(abs(errores[t]),1/2.0);          //Penalizacion Fuerte
            //float penalizacion=pow(abs(errores[t]),2.0);          //Penalizacion Debil
            // float penalizacion=0.5*(pow(2*error-1,1/3.0)+1);     //Penalizacion Sesgada
            
            aptitud-=penalizacion;           
        }
        if(aptitud>aptitud_ant){
          //println(aptitud);
            mejores[1]=mejores[0];
            mejores[0]=cromosomas[i];
            aptitud_ant2=aptitud_ant;
            aptitud_ant=aptitud;
            error[1]=error[0];
            error[0]=errores;
            
        }else if(aptitud>aptitud_ant2){
            mejores[1]=cromosomas[i];
            aptitud_ant2=aptitud;
            error[1]=errores;
        }
        Aptitudes[i]=aptitud;
      }
      //println("Generation: "+gen+"   Aptitud: "+max(Aptitudes));
      //println("Genes:");
      //for(int k=0; k<2; k++){
      //  print(k+" -- ");
      //  for(int j=90; j<95; j++){
      //    print(j+": "+mejores[k][j]+ "  ");
      //  }
      //  println("fin");
      //}
      //println("Errores:");
      //for(int k=0; k<2; k++){
      //  print(k+" -- ");
      //  for(int j=90; j<95; j++){
      //    print(j+": "+error[k][j]+ "  ");
      //  }
      //  println("fin");
      //}
      
      
      
      
      
      
      
      ////Mutacion//////
      float[][] cromosomas_cruzados= new float[pop][l];
      int prop=500;
      float prop_mutaciones=0.05;
      int[] pru=new int[2];
      for(int i=0; i<pop; i++){
        int sel=floor(random(2));
      //  print(sel+" -- ");
        
        for(int t=0; t<l; t++){
            cromosomas_cruzados[i][t]=mejores[sel][t];
            //if(t%prop==4){
            //  int sel2=floor(random(2));
            //  cromosomas_cruzados[i][t]=mejores[sel2][t];
            //}
            float mutar=random(1);
            //print(error[sel+1][t]+" ");
            if(mutar<abs(error[sel][t])){
              float aleatorio = random(min(0,1.5*error[sel][t]),max(0,1.5*error[sel][t]));
              if(t>=90 && t<95){
               // print(t+"G: "+cromosomas_cruzados[i][t]+"+");
                pru[0]=i;
                pru[1]=t;
              }
              cromosomas_cruzados[i][t]=cromosomas_cruzados[i][t]+aleatorio;
              if(t>=90 && t<95){
               // print(aleatorio+"="+cromosomas_cruzados[i][t]+"  ");
              }
            }
        }
       // println("fin");
      }
      cromosomas=cromosomas_cruzados;


      mejor = new AudioSample(this, mejores[0], 8000);
      mejor.amp(0.2);
      mejor.play();
      tiempo = millis();
      //println(cont);
      
      //Texto
      if(max_gen==gen){
        fill(0,255,0);
      }else{
        fill(255);
      }
      textAlign(CENTER);
      textSize(50);
      text("Mejores Replicas", width/2, 100);
      textSize(25);
      text("Generacion: "+gen, width/2, 150);
      text("Mejor Aptitud: "+max(Aptitudes), width/2, 200);
      text("Aptitud Perfecta: 16000", width/2, 250);
      gen+=1;
    }
  cont+=1;
}
