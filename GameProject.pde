/********************************************************************************** //<>// //<>// //<>// //<>//
*  Name: Elizabeth Loubenski, Tyler Yan, Mridul Mittal, Anthony Lee               *
*  Course: ICS 4U Pd. 7                                                           *
*  Final Project: Chess                                                           *
*  Purpose: 2 player Chess                                                        *
*  Due Date: June 4, 2021                                                         *
************************************************************************************/
PFont f; //<>//
PImage bishop;
PImage knight;
PImage queen;
PImage king;
PImage pawn;
PImage rook;
PImage bishopB;
PImage knightB;
PImage queenB;
PImage kingB;
PImage pawnB;
PImage rookB;
Board mainBoard = new Board();

void setup()
{
  size(1100, 760);
  f = createFont("Arial", 16, true);
  bishop = loadImage("pngguru.com-7.png");
  knight = loadImage("pngguru.com-9.png");
  queen = loadImage("pngguru.com-14.png");
  king = loadImage("pngguru.com-2.png");
  pawn = loadImage("pngguru.com-4.png");
  rook = loadImage("pngguru.com copy.png");
  bishopB = loadImage("pngguru.com-8.png");
  knightB = loadImage("pngguru.com-10.png");
  queenB = loadImage("pngguru.com-12.png");
  kingB = loadImage("pngguru.com-3.png");
  pawnB = loadImage("pngguru.com-6.png");
  rookB = loadImage("pngguru.com-13.png");
}

/*** draw*************************************
 * draws everything in the function          *
 ********************************************/
void draw()
{
  background(#AA3032);
  mainBoard.draw();
}

/*** mousePressed*******************************************
 * does everything in the function once mouse is pressed   *
 **********************************************************/
void mousePressed()
{   
  mainBoard.click();
}

enum Colour {
  BLACK, WHITE
};
enum eFigure {
  NONE, BISHOP, KNIGHT, PAWN, KING, QUEEN, ROOK
};

final int screenWidth = 1100;
final int screenHeight = 760;
final int cell = 80;
final int indentXBoard = 260;
final int indentYBoard = 60;
final int indentXFigure = 4;
final int indentYFigure = 6;
final int num = 8;

class Point 
{
  int x;
  int y;

  Point(int xx, int yy)
  {
    x=xx;
    y=yy;
  }

  Point (Point p, int xx, int yy)
  {
    x=p.x+xx;
    y=p.y+yy;
  }

  Point()
  {
    x=0;
    y=0;
  }

/*** equals  ************************************
* compares 2 points and returns true            *
* if they are equal                             *
************************************************/
  boolean equals(Point other)
  {
    return x==other.x && y==other.y;
  }
}

class Board
{
  private Cell [][] board = new Cell[num][num]; //only fills in first set of pointers which point to nulls
  private Colour thisTurn=Colour.WHITE; //white goes first  
  private Previous selectedCells=null; //null means no selected cells
  private boolean isBlackKingOrRookMove=false;
  private boolean isWhiteKingOrRookMove=false;
  private boolean pawnReachEnd=false;
  private PawnEnd pawnCell;

  class PawnEnd
  {
    Point point;
    Colour colour;

    PawnEnd(Point pp, Colour cc)
    {
      point=pp;
      colour=cc;
    }
  }

  Board()
  { 
    eFigure ef=null;//name of figures - enum 
    Colour cf=null; //color of figure

    for (int x=0; x<num; x++)
    {
      for (int y=0; y<num; y++)
      {
        if (y==0)//fills in first row of figures (white)
        {
          cf=Colour.WHITE;
          if (x==0||x==7)
            ef=eFigure.ROOK;
          else if (x==1||x==6)
            ef=eFigure.KNIGHT;
          else if (x==2||x==5)
            ef=eFigure.BISHOP;
          else if (x==3)
            ef=eFigure.QUEEN;
          else
            ef=eFigure.KING;
        } else if (y==1)//fills in second row of figures (all pawns)(white)
        {
          cf=Colour.WHITE;
          ef=eFigure.PAWN;
        } else if (y==6)//fills in second row of figures from black side( all pawns)(black)
        {
          cf=Colour.BLACK;
          ef=eFigure.PAWN;
        } else if (y==7)//fills in first row of figures from black side(black)
        {
          cf=Colour.BLACK;
          if (x==0||x==7)
            ef=eFigure.ROOK;
          else if (x==1||x==6)
            ef=eFigure.KNIGHT;
          else if (x==2||x==5)
            ef=eFigure.BISHOP;
          else if (x==3)
            ef=eFigure.QUEEN;
          else
            ef=eFigure.KING;
        } else  
        ef=eFigure.NONE;

        board[x][y] = new Cell((x+y)%2==1?Colour.WHITE:Colour.BLACK, x, y, ef, cf);//makes a new cell where the null used to be and stores in in board[x][y]
        //new cell draws itself and draws figure if theres supposed to be one
        //if (x+y)% 2==1, draws white(light brown) cell, else draws black(dark brown) cell
      }
    }
  }

/***getFigureColour  *****************************
  * calls getFigureColour function, which        *
  * exists in the cell class                     *
  ************************************************/
  Colour getFigureColour(Point p)
  {
    return board[p.x][p.y].getFigureColour();
  }

/***getEFigure  ****************************
 * calls getEFigure function that exists   *
 * in the cell class                       *
 ******************************************/
  eFigure getEFigure(Point p)
  {
    return board[p.x][p.y].getEFigure();
  }

/***isFigure  ************************************
  * returns true if there is a figure in the     *
  * point given (any colour)                     *
  ************************************************/
//isFigure - returns true if there is a figure in the point given (any colour)

  boolean isFigure(Point p)//true if figure 
  {
    return board[p.x][p.y].figure!=null;
  }

/***isFigureOppositeColour  ************************************
  * returns true if there is a figure in the point given that  *
  * is the opposite of the colour that is given                *
  **************************************************************/
 boolean isFigureOppositeColour(Point p, Colour c)//if figure of opposite colour
  {
    return board[p.x][p.y].figure!=null && board[p.x][p.y].getFigureColour()!=c;
  } 

/***isFigureColour  **********************************************
  * returns true if there is a figure in the point given that    *
  * is the same colour that is given                             *
  ***************************************************************/
  boolean isFigureColour(Point p, Colour c)//if figure of same colour
  {
    return board[p.x][p.y].figure!=null && board[p.x][p.y].getFigureColour()==c;
  } 

/***isValid************************************
  * returns true if the point given           *
  * exists on the board                       *
  ********************************************/
 boolean isValid(Point p)
  {
    return p.x>=0 && p.x<=7 && p.y>=0 && p.y<=7;
  } 

/***getPossibleMoves***************************
  * returns the possible moves of where       *
  * the given figure can go                   *
  ********************************************/
  ArrayList<Point> getPossibleMoves (Point p, eFigure f, Colour c)
  {
    switch(f)
    {
    case BISHOP: 
      return getPossibleBishopMoves(p, c);    
    case ROOK: 
      return getPossibleRookMoves( p, c);   
    case PAWN: 
      return getPossiblePawnMoves(p, c);
    case KING: 
      return getPossibleKingMoves(p, c);
    case QUEEN: 
      return getPossibleQueenMoves(p, c);
    default :  
      return getPossibleKnightMoves( p, c);
    }
  }  

 /***getPossibleKingMoves****************
  * returns the possible moves of       *
  * the king                            *
  **************************************/
  ArrayList<Point> getPossibleKingMoves (Point p, Colour c)
  {
    ArrayList<Point> possibleMoves =new ArrayList<Point>();

    Point tmp = new Point(p, 0, 0);   
    //case 1- right
    tmp = new Point(p, 1, 0);
    if (isValid(tmp) && (isFigureOppositeColour(tmp, c)||!isFigureColour(tmp, c)))
      possibleMoves.add(tmp);
    //case 2 -rook switch to the right
    Point tmp2 = new Point (p, 2, 0);
    if (thisTurn==Colour.WHITE)
    {
      if (isValid(tmp2) && !isFigure(tmp) && !isFigure(tmp2) && isWhiteKingOrRookMove==false)
        possibleMoves.add(tmp2);
    } else
    {
      if (isValid(tmp2) && !isFigure(tmp) && !isFigure(tmp2) && isBlackKingOrRookMove==false)
        possibleMoves.add(tmp2);
    }
    //case 3 - right down
    tmp = new Point(p, 1, 1);
    if (isValid(tmp) && (isFigureOppositeColour(tmp, c)||!isFigureColour(tmp, c)))
      possibleMoves.add(tmp);
    //case 4 - down
    tmp = new Point(p, 0, 1);
    if (isValid(tmp) && (isFigureOppositeColour(tmp, c)||!isFigureColour(tmp, c)))
      possibleMoves.add(tmp);
    //case 5 - left down
    tmp = new Point(p, -1, 1);
    if (isValid(tmp) && (isFigureOppositeColour(tmp, c)||!isFigureColour(tmp, c)))
      possibleMoves.add(tmp);
    //case 6 - left
    tmp = new Point(p, -1, 0);
    if (isValid(tmp) && (isFigureOppositeColour(tmp, c)||!isFigureColour(tmp, c)))
      possibleMoves.add(tmp);
    //case 7 - rook switch to the left
    tmp2=new Point(p, -2, 0);
    Point tmp3=new Point (p,-3,0);
    if (thisTurn==Colour.WHITE)
    {
      if (isValid(tmp2) && isValid(tmp3) && !isFigure(tmp) && !isFigure(tmp2) && !isFigure(tmp3) && isWhiteKingOrRookMove==false)
        possibleMoves.add(tmp2);
    } else
    {
      if (isValid(tmp2) && !isFigure(tmp) && !isFigure(tmp2) && isBlackKingOrRookMove==false)
        possibleMoves.add(tmp2);
    }
    //case 8 - left up 
    tmp = new Point(p, -1, -1);
    if (isValid(tmp) && (isFigureOppositeColour(tmp, c)||!isFigureColour(tmp, c)))
      possibleMoves.add(tmp);
    //case 9 - up
    tmp = new Point(p, 0, -1);
    if (isValid(tmp) && (isFigureOppositeColour(tmp, c)||!isFigureColour(tmp, c)))
      possibleMoves.add(tmp);
    //case 10 - right up
    tmp = new Point(p, 1, -1);
    if (isValid(tmp) && (isFigureOppositeColour(tmp, c)||!isFigureColour(tmp, c)))
      possibleMoves.add(tmp);

    return possibleMoves;
  }

 /***getPossiblePawnMoves*****************
  * returns the possible moves of       *
  * the pawns                           *
  **************************************/
  ArrayList<Point> getPossiblePawnMoves (Point p, Colour c)
  {
    ArrayList<Point> possibleMoves =new ArrayList<Point>();
    if (c==Colour.WHITE)
    {
      //case 1- figure in front
      Point tmp= new Point(p, 0, 1);     
      if (!isFigure(tmp))
      {
        possibleMoves.add(tmp);
        //case 2-starting in first position, make sure that pawn can't move 2 up if there's a figure blocking it 1 up
        tmp = new Point (p, 0, 2);
        if (p.y==1 && !isFigure(tmp))
          possibleMoves.add(tmp);
      }
      //case 3-can eat figure on right
      tmp= new Point (p, 1, 1);
      if (isValid(tmp) && isFigureOppositeColour(tmp, c))
        possibleMoves.add(tmp);
      //case 4- can eat figure on left
      tmp= new Point (p, -1, 1);
      if (isValid(tmp) && isFigureOppositeColour(tmp, c))
        possibleMoves.add(tmp);
    } else
    {
      //case 1- figure in front
      Point tmp= new Point(p, 0, -1);
      if (!isFigure(tmp))
      {
        possibleMoves.add(tmp);     
        //case 2-starting in first position
        tmp = new Point (p, 0, -2);
        if (p.y==6 && !isFigure(tmp))
          possibleMoves.add(tmp);
      }
      //case 3-can eat figure on right
      tmp= new Point (p, 1, -1);
      if (isValid(tmp) && isFigureOppositeColour(tmp, c))
        possibleMoves.add(tmp);
      //case 4- can eat figure on left
      tmp= new Point (p, -1, -1);
      if (isValid(tmp)&& isFigureOppositeColour(tmp, c))
        possibleMoves.add(tmp);
    }      
    return possibleMoves;
  }

 /***getPossibleBishopMoves**************
  * returns the possible moves of       *
  * the bishops                         *
  **************************************/
  ArrayList<Point> getPossibleBishopMoves (Point p, Colour c)
  {   
    ArrayList<Point> possibleMoves =new ArrayList<Point>();
    //case 1 - to the down,right
    Point tmp = new Point(p, 0, 0);
    while (true)
    {        
      tmp = new Point(tmp, 1, 1);
      if (!isValid(tmp))
        break;
      if (isFigureOppositeColour(tmp, c))
      {
        possibleMoves.add(tmp);
        break;
      } else if (isFigureColour(tmp, c))
        break;

      possibleMoves.add(tmp);
    }

    //case 2 -down,left
    tmp = new Point(p, 0, 0);
    while (true)
    {        
      tmp = new Point(tmp, -1, 1);
      if (!isValid(tmp))
        break;
      if (isFigureOppositeColour(tmp, c))
      {
        possibleMoves.add(tmp);
        break;
      } else if (isFigureColour(tmp, c))
        break;

      possibleMoves.add(tmp);
    }
    //case 3-left,up
    tmp = new Point(p, 0, 0);
    while (true)
    {        
      tmp = new Point(tmp, -1, -1);
      if (!isValid(tmp))
        break;
      if (isFigureOppositeColour(tmp, c))
      {
        possibleMoves.add(tmp);
        break;
      } else if (isFigureColour(tmp, c))
        break;

      possibleMoves.add(tmp);
    }
    //case 4-up,right
    tmp = new Point(p, 0, 0);
    while (true)
    {        
      tmp = new Point(tmp, 1, -1);
      if (!isValid(tmp))
        break;
      if (isFigureOppositeColour(tmp, c))
      {
        possibleMoves.add(tmp);
        break;
      } else if (isFigureColour(tmp, c))
        break;

      possibleMoves.add(tmp);
    }   
    return possibleMoves;
  }
 /***getPossibleRookMoves*****************
  * returns the possible moves of        *
  * the rooks                            *
  ***************************************/
  ArrayList<Point> getPossibleRookMoves (Point p, Colour c)
  {
    ArrayList<Point> possibleMoves =new ArrayList<Point>();
    //case 1 - to the right
    Point tmp = new Point(p, 0, 0);
    while (true)
    {        
      tmp = new Point(tmp, 1, 0);
      if (!isValid(tmp))
        break;
      if (isFigureOppositeColour(tmp, c))
      {
        possibleMoves.add(tmp);
        break;
      } else if (isFigureColour(tmp, c))
        break;

      possibleMoves.add(tmp);
    }

    //case 2 -down
    tmp = new Point(p, 0, 0);
    while (true)
    {        
      tmp = new Point(tmp, 0, 1);
      if (!isValid(tmp))
        break;
      if (isFigureOppositeColour(tmp, c))
      {
        possibleMoves.add(tmp);
        break;
      } else if (isFigureColour(tmp, c))
        break;

      possibleMoves.add(tmp);
    }
    //case 3-left
    tmp = new Point(p, 0, 0);
    while (true)
    {        
      tmp = new Point(tmp, -1, 0);
      if (!isValid(tmp))
        break;
      if (isFigureOppositeColour(tmp, c))
      {
        possibleMoves.add(tmp);
        break;
      } else if (isFigureColour(tmp, c))
        break;

      possibleMoves.add(tmp);
    }
    //case 4-up
    tmp = new Point(p, 0, 0);
    while (true)
    {        
      tmp = new Point(tmp, 0, -1);
      if (!isValid(tmp))
        break;
      if (isFigureOppositeColour(tmp, c))
      {
        possibleMoves.add(tmp);
        break;
      } else if (isFigureColour(tmp, c))
        break;

      possibleMoves.add(tmp);
    }   
    return possibleMoves;
  }

 /***getPossibleQueenMoves***************
  * returns the possible moves of       *
  * the queens                          *
  **************************************/
  ArrayList<Point> getPossibleQueenMoves (Point p, Colour c)
  {
    ArrayList<Point> possibleMoves =getPossibleRookMoves(p, c);
    possibleMoves.addAll(getPossibleBishopMoves(p, c)); 
    return possibleMoves;
  }   

 /***getPossibleKnightMoves**************
  * returns the possible moves of       *
  * the knights                         *
  **************************************/
  ArrayList<Point> getPossibleKnightMoves (Point p, Colour c)
  {
    ArrayList<Point> possibleMoves =new ArrayList<Point>();
    Point tmp = new Point(p, 1, 2);
    if (isValid(tmp) && !isFigureColour(tmp, c))
      possibleMoves.add(tmp);
    tmp = new Point(p, -1, 2);
    if (isValid(tmp) && !isFigureColour(tmp, c))
      possibleMoves.add(tmp);
    tmp = new Point(p, 1, -2);
    if (isValid(tmp) && !isFigureColour(tmp, c))
      possibleMoves.add(tmp);
    tmp = new Point(p, -1, -2);
    if (isValid(tmp) && !isFigureColour(tmp, c))
      possibleMoves.add(tmp);
    tmp = new Point(p, 2, 1);
    if (isValid(tmp) && !isFigureColour(tmp, c))
      possibleMoves.add(tmp);
    tmp = new Point(p, -2, 1);
    if (isValid(tmp) && !isFigureColour(tmp, c))
      possibleMoves.add(tmp);
    tmp = new Point(p, 2, -1);
    if (isValid(tmp) && !isFigureColour(tmp, c))
      possibleMoves.add(tmp);
    tmp = new Point(p, -2, -1);
    if (isValid(tmp) && !isFigureColour(tmp, c))
      possibleMoves.add(tmp);
    return possibleMoves;
  }

/***getcell  ******************************************************
  * returns the point(the column and row on the chess board)      *
  * that the mouse has clicked on                                 *
  ****************************************************************/
  Point getcell()
  {
    if (mouseX-indentXBoard>=0 && mouseX-indentXBoard<=640 && mouseY-indentYBoard>=0&& mouseY-indentYBoard<=640)
      return new Point((mouseX-indentXBoard)/cell, num- 1-(mouseY-indentYBoard)/cell);  
    else
      return null;
  }

/***click **************************************
  * it will complete all appropriate tasks     *
  * when the mouse is pressed                  *
  *********************************************/
  void click()
  {
    if (pawnReachEnd==true)
    {
      Point cellClicked = getcell(); 
      if (cellClicked == null || !cellClicked.equals(new Point(3, 3)) && !cellClicked.equals(new Point(3, 4)) &&  !cellClicked.equals(new Point(4, 3)) && !cellClicked.equals(new Point(4, 4)))
        return;        
      if (cellClicked.x==3 && cellClicked.y==3)
        board[pawnCell.point.x][pawnCell.point.y].figure = new Rook(pawnCell.colour);
      else if (cellClicked.x==4 && cellClicked.y==3)
        board[pawnCell.point.x][pawnCell.point.y].figure = new Knight(pawnCell.colour);
      else if (cellClicked.x==4 && cellClicked.y==4)
        board[pawnCell.point.x][pawnCell.point.y].figure = new Bishop(pawnCell.colour);
      else
        board[pawnCell.point.x][pawnCell.point.y].figure = new Queen(pawnCell.colour);
      pawnReachEnd=false;
    } else if (selectedCells==null)
    {
      Point cellClicked = getcell(); 
      if (cellClicked==null)
        return;      
      eFigure cellClickedFigure = getEFigure(cellClicked);
      if (cellClickedFigure==null)
        return;
      Colour cellClickedFigureColour = getFigureColour(cellClicked);
      if (cellClickedFigureColour!=thisTurn)
        return;
      ArrayList<Point> moves = getPossibleMoves(cellClicked, cellClickedFigure, cellClickedFigureColour);
      if (moves.size()==0)
        return;
      highlightCells(moves);  
      board[cellClicked.x][cellClicked.y].isFigureSelected=true; // now selected all neccesary cells
      selectedCells= new Previous(cellClicked, moves);//old information inside new member
    } else 
    {
      Point newCellClicked = getcell();  
      if (selectedCells.isMovePossible(newCellClicked))
      {
        board[newCellClicked.x][newCellClicked.y].figure = board[selectedCells.previousCellClicked.x][selectedCells.previousCellClicked.y].figure;
        board[selectedCells.previousCellClicked.x][selectedCells.previousCellClicked.y].figure = null;
        if (board[newCellClicked.x][newCellClicked.y].getEFigure()== eFigure.KING ||board[newCellClicked.x][newCellClicked.y].getEFigure()== eFigure.ROOK)
        {
          if (thisTurn==Colour.WHITE)
            isWhiteKingOrRookMove=true;
          else
            isBlackKingOrRookMove=true;
        }
        if (board[newCellClicked.x][newCellClicked.y].getEFigure()== eFigure.KING)
        { 
          //castling to the right
          if (newCellClicked.equals(new Point (6, 0)))//new point is the new king point
          {        
            board[5][0].figure=board[7][0].figure;//changing rook
            board[7][0].figure=null;
          } else if (newCellClicked.equals(new Point (6, 7)))
          {
            board[5][7].figure=board[7][7].figure;//changing rook
            board[7][7].figure=null;
          }
          //castling to the left 
          else if (newCellClicked.equals(new Point(2, 0)))//new point is the new king point
          {        
            board[3][0].figure=board[0][0].figure;//changing rook
            board[0][0].figure=null;
          } else if (newCellClicked.equals(new Point(2, 7)))
          {        
            board[3][7].figure=board[0][7].figure;//changing rook
            board[0][7].figure=null;
          } 
          if (thisTurn==Colour.WHITE)
            isWhiteKingOrRookMove=true;
          else
            isBlackKingOrRookMove=true;
        }  
        if (board[newCellClicked.x][newCellClicked.y].getEFigure()== eFigure.PAWN && newCellClicked.y== 7)
        {
          pawnCell = new PawnEnd (newCellClicked, Colour.WHITE);
          pawnReachEnd =true;
        } else if (board[newCellClicked.x][newCellClicked.y].getEFigure()== eFigure.PAWN && newCellClicked.y== 0)
        {
          pawnCell = new PawnEnd (newCellClicked, Colour.BLACK);
          pawnReachEnd=true;
        } 
        thisTurn=thisTurn==Colour.WHITE?Colour.BLACK:Colour.WHITE;
      }   

      erase();
      selectedCells=null;
    }
  }

  class Previous//make a function that true or false
  {
    Point previousCellClicked;
    ArrayList<Point> previousMoves = new ArrayList<Point>();

 /***isMovePossible************************************
  * returns true if the figure in the point clicked   *
  * can move to where you clicked                     *
  ****************************************************/
   boolean isMovePossible(Point cellClicked)
    {
      boolean answer=false;
      if (cellClicked==null)
        return answer;
      for (int i =0; i< previousMoves.size(); i++)
      { 
        if (cellClicked.x==previousMoves.get(i).x && cellClicked.y==previousMoves.get(i).y)
          answer=true;
      } 
      return answer;
    }

    Previous(Point pCC, ArrayList<Point> pM)
    {
      previousCellClicked = pCC;
      previousMoves = pM;
    }
  }
//highlightCells - turns the member isSelected to true for the cell(s) that is/are a possible move for the figure that is clicked on
  void highlightCells (ArrayList<Point> moves)
  {
    if (moves==null)
      return;
    for (int i = 0; i<moves.size(); i++)
      board[moves.get(i).x][moves.get(i).y].isSelected=true;
  }

 /***erase*************************************
  *it moves the figure from where it was to   *
  *its new location which the user provided   *
  ********************************************/
  void erase()
  {
    for (int i = 0; i<selectedCells.previousMoves.size(); i++)
      board[selectedCells.previousMoves.get(i).x][selectedCells.previousMoves.get(i).y].isSelected=false; 
    board[selectedCells.previousCellClicked.x][selectedCells.previousCellClicked.y].isFigureSelected=false;
  }

 /***draw*******************************************************
  * draws everything in the function, makes changes            *
  * and calls draw() function that exists in the cell class    *
  **************************************************************/
  void draw()
  {
    for (int x=0; x<num; x++)
    {
      for (int y=0; y<num; y++)
        board[x][y].draw();
    }

    textFont(f, 34);
    fill(0);

    for (int i = 0; i<8; i++)
      text(char('1'+i), 220, 675 - i*80);

    for (char j=0; j<8; j++)
      text(char('A'+j), 290+j*80, 745);

    //displays the turn
    text("This Turn: " + thisTurn, 20, 45);

    if (pawnReachEnd)
    {
      fill(#00F4FF);
      int x =indentXBoard+cell*3;
      int y =indentYBoard+cell*3;
      rect(x, y, cell, cell);
      rect(x, y+cell, cell, cell);
      rect(x+cell, y, cell, cell);
      rect(x+cell, y+cell, cell, cell);
      if (pawnCell.colour==Colour.WHITE)
      {
        image(queen, x, y, width/13, height/9);
        image(bishop, x-indentXFigure+cell, y-indentYFigure*1.25, width/12, height/8);
        image(rook, x, y+cell, width/13, height/9); 
        image(knight, x+indentXFigure+cell, y+indentYFigure+cell, width/16, height/10.5);
      } else
      {
        image(queenB, x+indentXFigure, y+indentYFigure/3, width/14.5, height/10);
        image(bishopB, x+indentXFigure+cell, y +indentYFigure*1.25, width/16, height/11.5);
        image(rookB, x, y+cell, width/13, height/9);
        image(knightB, x+cell, y+cell, width/13, height/9);
      }
    }
  }
}

class Cell
{
  private boolean isSelected = false; 
  private boolean isFigureSelected = false;
  private Colour colour;//color of cell
  private int x;
  private int y;
  private Figure figure=null; 

  Cell(Colour c, int x, int y, eFigure ef, Colour cf)//cf-color of figure, ef-type of figure
  {
    colour=c;//color of cell
    this.x=x;
    this.y=y;

    //stores the right type of figure in an object w the base class
    //Also passes through the color of the figure. 
    //Also doesn't need NONE, because we initialized f with null in the beginning
    switch(ef)
    {
    case BISHOP: 
      figure= new Bishop(cf);
      break;
    case ROOK: 
      figure= new Rook(cf);
      break;
    case PAWN: 
      figure= new Pawn(cf);
      break;
    case KING: 
      figure= new King (cf);
      break;
    case QUEEN: 
      figure= new Queen (cf);
      break;
    case KNIGHT: 
      figure= new Knight (cf);
    }
  }

 /***getEFigureColour**********************
   *calls getEFigureColour function       *
  * that exists in the figure classes     *
  ****************************************/
  eFigure getEFigure()
  {
    if (figure == null)
      return null;
    else   
    return figure.getEFigure();
  }

 /***getFigureColour**********************
   *calls getFigureColour function       *
  * that exists in the figure class      *
  ***************************************/
  Colour getFigureColour()
  {
    if (figure == null)
      return null;
    return figure.getFigureColour();
  }

 /***draw*******************************************************
   *draws everything in the function, makes new changes        *
  *and calls draw() function that exists in the figure class   *
  *************************************************************/
  void draw()//draws cell and calls to draw figure
  {  
    if (isSelected==true) 
      fill(#9DFA97);         
    else if (isFigureSelected == true)  
      fill(#AAF7FF);
    else if (colour==Colour.BLACK)
      fill(#52380E);
    else
      fill(#C69648);

    rect(indentXBoard + x*cell, indentYBoard+(num-y-1)*cell, cell, cell);//draws the cell itself
    // since y starts at the bottom of the screen, logistically it makes sense to draw cells from the bottom going up
    //indentXBoard and indentYBoard - top x and y coordinate of the board itself.

    if (figure!=null)// if f==null, then there are no figures in the cell
      figure.draw(x, y);// goes to the function of the class which the pointer is pointing to- the figure stored in f
  }
}

class Figure //base class which allows for other classes to be stored in an object w the base class
{
  Colour colour;  
 /***draw************************************
   *draws everything in the function        *
  * (basically draws the figure)            *
  ******************************************/
  void draw(int x, int y)// virtual function - allows us to use functions in other classes that inherit this one
  {
  }

 /***getEFigure************************************
   *returns the name of the figure of the         *
  * point that is given (returns an enum)         *
  ************************************************/
  eFigure getEFigure()
  {
    return null;
  }

 /***getFigureColour************************************
   *returns the name of the colour for the figure of   *
  * the point that is given (returns an enum)          *
  *****************************************************/
  Colour getFigureColour()
  {
    return null;
  }
}
/*Any class that extends from this class has these same functions*/
class Bishop extends Figure//pointy figure
{
  Bishop(Colour colour)//constructor and uses the member, colour from base class
  { 
    this.colour=colour;
  }  
  void draw(int x, int y)//draws the figure
  {
    if (colour==Colour.BLACK)
      image(bishopB, indentXBoard + x*cell+indentXFigure, indentYBoard+(num-y-1)*cell+ indentYFigure*1.25, width/16, height/11.5);
    else
      image(bishop, indentXBoard + x*cell-indentXFigure, indentYBoard+(num-y-1)*cell-indentYFigure*1.25, width/12, height/8);
  } 

  eFigure getEFigure()
  {
    return eFigure.BISHOP;
  }

  Colour getFigureColour()
  {
    return colour;
  }
}


class Knight extends Figure
{

  Knight(Colour colour)
  { 
    this.colour=colour;
  }

  void draw(int x, int y)
  {
    if (colour==Colour.BLACK)
      image(knightB, indentXBoard + x*cell, indentYBoard+(num-y-1)*cell, width/13, height/9);
    else
      image(knight, indentXBoard + x*cell+indentXFigure, indentYBoard+(num-y-1)*cell+indentYFigure, width/16, height/10.5);
  } 

  eFigure getEFigure()
  {
    return eFigure.KNIGHT;
  }

  Colour getFigureColour()
  {
    return colour;
  }
}

class Queen extends Figure
{
  Queen(Colour colour)
  { 
    this.colour=colour;
  }

  void draw(int x, int y)
  {
    if (colour==Colour.BLACK)
      image(queenB, indentXBoard + x*cell+indentXFigure, indentYBoard+(num-y-1)*cell+indentYFigure/3, width/14.5, height/10);
    else
      image(queen, indentXBoard + x*cell, indentYBoard+(num-y-1)*cell, width/13, height/9);
  } 

  eFigure getEFigure()
  {
    return eFigure.QUEEN;
  }

  Colour getFigureColour()
  {
    return colour;
  }
}

class King extends Figure
{


  King(Colour colour)
  { 
    this.colour=colour;
  }

  void draw(int x, int y)
  {
    if (colour==Colour.BLACK)
      image(kingB, indentXBoard + x*cell, indentYBoard+(num-y-1)*cell, width/13, height/9.5);
    else
      image(king, indentXBoard + x*cell, indentYBoard+(num-y-1)*cell+indentYFigure/1.5, width/14, height/10);
  } 

  eFigure getEFigure()
  {
    return eFigure.KING;
  }

  Colour getFigureColour()
  {
    return colour;
  }
}

class Pawn extends Figure
{

  Pawn(Colour colour)
  { 
    this.colour=colour;
  }

  void draw(int x, int y)
  {
    if (colour==Colour.BLACK)
      image(pawnB, indentXBoard + x*cell, indentYBoard+(num-y-1)*cell, width/13, height/9);
    else
      image(pawn, indentXBoard + x*cell+indentXFigure*3, indentYBoard+(num-y-1)*cell+indentYFigure, width/20, height/11);
  } 

  eFigure getEFigure()
  {
    return eFigure.PAWN;
  }

  Colour getFigureColour()
  {
    return colour;
  }
}

class Rook extends Figure
{

  Rook(Colour colour)
  { 
    this.colour=colour;
  }

  void draw(int x, int y)
  {
    if (colour==Colour.BLACK)
      image(rookB, indentXBoard + x*cell, indentYBoard+(num-y-1)*cell, width/13, height/9);
    else
      image(rook, indentXBoard + x*cell, indentYBoard+(num-y-1)*cell, width/13, height/9);
  } 

  eFigure getEFigure()
  {
    return eFigure.ROOK;
  }

  Colour getFigureColour()
  {
    return colour;
  }
}
