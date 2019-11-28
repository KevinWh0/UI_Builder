import java.util.List;
boolean mouseP = false;



int DownX = 0;
int DownY = 0;
int UpX = 0;
int UpY = 0;

color strokeColor = color(0);
color fillColor = color(255);
color selectedCol = 0;
boolean canDraw = true;
ColorPicker cp;

boolean showingSel = false;


boolean ShowColSelect = false;


String mode = "rect";
boolean newOBJ = false;

List<object> objects = new ArrayList<object>(); 


int OrigninalWidth = 800;
int OrigninalHeight = 800; //Must be the same as size


void setup() {
  size(800, 800);
  cp = new ColorPicker( 10, 50, 400, 400, 255 );
}




class object {

  int objX;
  int objY;
  int objWidth;
  int objHeight;
  String type;
  color fillCol;
  color strokeCol;

  object(int X, int Y, int Width, int Height, String type, color fillCol, color strokeCol) {
    objX = X;
    objY = Y;
    /*if (type.equals("ellipse")) {
     objX = objX-(objWidth/2);
     objY = objY-(objHeight/2);
     }*/

    //      ellipse(DownX+(-DownX+mouseX)/2, DownY+(-DownY+mouseY)/2, -DownX+mouseX, -DownY+mouseY);

    objWidth = Width;
    objHeight = Height;
    this.fillCol = fillCol;
    this.strokeCol = strokeCol;

    this.type = type;
  }

  void drawOBJ() {
    fill(fillCol);
    if (type.equals("rect")) {
      rect(objX, objY, objWidth, objHeight);
    } else {
      ellipse(objX, objY, objWidth, objHeight);
    }
  }



  void drawOBJRED() {
    fill(255, 0, 0);
    rect(objX, objY, objWidth, objHeight);
  }
  String getFill() {

    return "fill("+red(fillCol)+","+green(fillCol)+","+blue(fillCol)+","+alpha(fillCol)+");";
  }
  String getModifiers(String type) {
    if (type.equals("stroke")) {
      return "stroke("+red(strokeCol)+","+green(strokeCol)+","+blue(strokeCol)+","+alpha(strokeCol)+");";
    } else {
      return "";
    }
  }

  String getObjCode() {


    //    return type+"(width/"+float(OrigninalWidth*objX)+  ", height/" +float(OrigninalHeight*objY)+  ", " + objWidth + ", "+objHeight+");";

    return type+"(width*"+float(objX)/float(width)+  ", height*" +float(objY)/float(height)+  ", width*"+float(objWidth)/float(width) + ", height*" +float(objHeight)/float(height)+");";
  }

  boolean inObjBounds(int MouseX, int MouseY) {


    if (MouseX > objX && MouseX < objX+objWidth && MouseY > objY && MouseY < objY+objHeight) {
      return true;
    }
    return false;
  }
}

void getcode() {
  String lastFillCode = "";
  String lastStrokeCode = "";

  for (int i = 0; i < objects.size(); i++) {
    //get the fill
    if (!objects.get(i).getFill().equals(lastFillCode)) {
      println(objects.get(i).getFill());
    }
    lastFillCode = objects.get(i).getFill();
    //get the stroke color
    if (!objects.get(i).getModifiers("stroke").equals(lastStrokeCode)) {
      println(objects.get(i).getModifiers("stroke"));
    }
    lastStrokeCode = objects.get(i).getModifiers("stroke");


    //getModifiers("stroke")

    //Get the objects
    println(objects.get(i).getObjCode());
  }
}


boolean inArea(int X, int Y, int x, int y, int w, int h) {
  if (X > x && Y > y && X < x+w && Y < y+h) {
    return true;
  } else {
    return false;
  }
}
boolean mouseLifted() {
  if (mouseP == true && mousePressed == false) {
    return true;
  } else {
    return false;
  }
}
void UI() {
  fill(255, 255, 255, 200);
  rect(-10, 0, width+20, 50); 

  for (int i = 0; i < 10; i++) {
    fill(255, 255, 255, 200);

    rect(10+(50*i), 5, 40, 40);
    if (i == 0) {
      fill(fillColor);
      rect(10+(50*i), 5, 40, 40);
      if (mouseLifted() && inArea(mouseX, mouseY, 10+(50*i), 5, 40, 40)) {
        if (ShowColSelect) {
          ShowColSelect = false;
        } else {
          ShowColSelect = true;
        }
      }
    } else if (i == 1) {
      fill(fillColor);
      rect(10+(60*i), 15, 20, 20);
      if (mouseLifted() && inArea(mouseX, mouseY, 10+(50*i), 5, 40, 40)) {
        mode = "rect";
      }
    } else if (i == 2) {
      fill(fillColor);
      ellipse(10+(60*i), 25, 20, 20);
      if (mouseLifted() && inArea(mouseX, mouseY, 10+(50*i), 5, 40, 40)) {
        mode = "ellipse";
      }
    } else if (i == 9) {
      fill(0);
      text("Delete", 10+(51*i), 15, 20, 20);
      if (mouseLifted() && inArea(mouseX, mouseY, 10+(50*i), 5, 40, 40)) {
        mode = "Del";
      }
    }
  }
  if (ShowColSelect) {
    fillColor = cp.render();
    canDraw = false;
  } else {
    canDraw = true;
  }
  
  if (mouseY < 50 || ShowColSelect) {
    canDraw = false;
  } else {
    canDraw = true;
  }



  //rect(10,5,40,40);
  //inArea(mouseX,mouseY,
}





void draw() {
  background(255, 0, 255);
  fill(fillColor);
  for (int i = 0; i < objects.size(); i++) {
    objects.get(i).drawOBJ();
    if (mode.equals("Del") && objects.get(i).inObjBounds(mouseX, mouseY)) {
      objects.get(i).drawOBJRED();
      if (mousePressed && canDraw) {

        objects.remove(i);
      }
    }
  }
  if (mode.equals("rect")) {
    if (mousePressed && canDraw) {
      fill(fillColor);
      rect(DownX, DownY, -DownX+mouseX, -DownY+mouseY);
    } else if (newOBJ && canDraw) {

      //rect(DownX,DownY,DownX+UpX,DownY+UpY);
      objects.add(new object(DownX, DownY, -DownX+UpX, -DownY+UpY, mode, fillColor, strokeColor));
      newOBJ = false;
    } else {
      newOBJ = false;
    }
  } else if (mode.equals("ellipse")) {
    if (mousePressed && canDraw) {
      fill(fillColor);
      ellipse(DownX+(-DownX+mouseX)/2, DownY+(-DownY+mouseY)/2, -DownX+mouseX, -DownY+mouseY);
    } else if (newOBJ && canDraw) {

      //rect(DownX,DownY,DownX+UpX,DownY+UpY);
      objects.add(new object(DownX+(-DownX+mouseX)/2, DownY+(-DownY+mouseY)/2, -DownX+UpX, -DownY+UpY, mode, fillColor, strokeColor));
      newOBJ = false;
    } else {
      newOBJ = false;
    }
  }

  UI();

  //Changing Modes
  if (keyPressed) {

    if (key == 'd') {
      mode = "Del";
    } else if (key == 'r') {

      mode = "rect";
    } else if (key == 'e') {
      mode = "ellipse";
    } else if (key == 'f') {

      //background(col);
      //selectedCol = cp.render();
    }
  } else {
  }


  if (mousePressed) {
    mouseP = true;
  } else {
    mouseP = false;
  }

  //println(DownX+"  "+DownY);
}
void mousePressed() {
  DownX = mouseX;
  DownY = mouseY;
}

void mouseReleased() {
  UpX = mouseX;
  UpY = mouseY;
  newOBJ = true;
}
void keyReleased() {
  if (key == 'g') {
    getcode();
  }
}
