import java.util.Iterator;
import java.util.ArrayList;

PImage cageimg,grassimg;//草原,檻のテクスチャマッピング用
Field field;//Fieldクラス(後述)のインスタンス
//Field2 field2;
/************************************************************************** 
*                                                                　　　　 *
*  DNA クラス                                                             *
*  遺伝子型の集団の中の個体の遺伝子情報を数値として格納するクラス     　　*
*                                                                         *
*  由川担当                                                               *
***************************************************************************/

class DNA{

  float[] genes;//個体の遺伝子情報
  
  //遺伝子情報初期化用のコンストラクタ
  DNA(){
    genes= new float[1];//.
    /**/
    for(int i=0;i<genes.length;i++){
       genes[i]=random(0,1); //今回の場合豚の体の大きさを表す遺伝子情報を入れる.
    }  
  }
  
  /*親が子を産むという状況を表現するための引数付きコンストラクタ
    引数newgenesが子供の遺伝子情報を表す.*/
  DNA(float[] newgenes){
      genes=newgenes;
  }
  
  //親の遺伝子情報を子に複製
  DNA copyDNA(){
    float[] newgenes=new float[genes.length];
    for(int i=0; i<newgenes.length;i++){
       newgenes[i]=genes[i];
    }
    return new DNA(newgenes); 
  }
  
  /*
    引数で指定された確率で遺伝子が突然変異を起こす.
   */
  void mutation(float prob){
  for (int i = 0; i < genes.length; i++) {
      if (random(1) < prob) {
         genes[i] = random(0,1);
      }
    }
  }
}

/*************************************************************************** 
*                                                                          *
*  Meat クラス                                                             *
*  豚が食べる肉の情報や肉の出現についての処理を扱うクラス                  *
*                                                                          *                                      *
*  由川担当                                                                *
***************************************************************************/

class Meat{
  ArrayList<PVector> meat;//肉のリスト生成
  
  //指定した数だけ肉をランダムに設置するためのコンストラクタ(シミュレーションの初期状態に使う) 
  Meat(int num){
    meat = new ArrayList();
    //ここで肉をランダムに設置している
    for(int i=0;i<num;i++){
      meat.add(new PVector(random(width),random(height)));
    }
  }
  
  //マウスを通してのイベント処理で肉を追加できるようにした処置
  //これはFieldクラスのgenerateMeatメソッドで利用している.
  void addMeat(PVector m){
    meat.add(m.get());
  }
  
  //肉の表示
  void showMeat(){
    for (PVector m : meat) {
     //肉を檻の範囲内に表示させる
     if(m.x>150 && m.x<width-100 && m.y>100 && m.y<height-100){ 
        fill(#955629);
        pushMatrix();
          translate(m.x,m.y);
          drawMeat(50);
        popMatrix();
      }
    }
  }
  
  //豚が肉を食べるということを実現するために利用する
  ArrayList getMeat(){
    return this.meat;
  }
  
}


/************************************************************************** 
*                                                                         *
*  Pig クラス                                                             *
*  DNAクラスの内容を豚という形で表現する.豚の移動の様子や肉を食べる処理   *
*  などを記述したクラス.                                                  *
*  由川担当                                                               *
***************************************************************************/

class Pig{
  
  ArrayList<PVector> pig;//豚のリスト生成
 
  PVector position;//豚の位置
  DNA dna;
  float lifespan;//豚の寿命
  //速度のx方向とy方向の乱数を生成するための種
  float xrandom;
  float yrandom;
  
  float size;//豚の大きさ
  float speed;//豚が動く速さ
  
   Pig(PVector p,DNA d){
     position=p.get();//豚の位置の取得
     lifespan=300;
     xrandom=random(1000);
     yrandom=random(1000);
     dna=d;
     
     /*
       genes[0]の値(0～1まで)を10から0に変換することで
       豚の動くスピードを実現
       同様にgenes[0]の値を0から60までに変換することで
       豚の大きさの変化を実現
       
       このようにすることで,豚の大きさが大きいほど,豚が動くスピード
       が遅くなるという状況を実現させている.
     */
     speed=map(dna.genes[0],0,1,10,0);
     size=map(dna.genes[0],0,1,0,60);
   }
  
  //豚の表示
  void showPig() {
   //檻の範囲内で表示する
   if(position.x>100 && position.x<width-100 && position.y>100 && position.y<height-100){ 
      fill(#ffc0cb, lifespan);
       pushMatrix();
       translate(position.x,position.y,0);
       rotateX(radians(90));
       drawPig(size);
      popMatrix();
     }
     
  }
  
  //豚がランダムに動く様子を表現する更新処理を記述
  void update(){
    
    //0から1の乱数の種をspeedで
    float vx = map(noise(xrandom),0,1,-speed,speed);
    float vy = map(noise(yrandom),0,1,-speed,speed);
    
    PVector velocity = new PVector(vx,vy);//初期速度の設定
    //x方向,y方向の速度を示す乱数値を更新 このようにすることで豚が動くアニメーションを実現
    xrandom += 0.01;
    yrandom += 0.01;
    position.add(velocity);
    lifespan -= 0.5;
    
    //豚が檻から出ないようにするための処置
    if (position.x < size+100 || position.x+size>width-100) {
       velocity.x*=-1;
       if(position.x<size+100) position.x *=-1;
       else if(position.x+size>width-100) position.x=2*(width+100-size)-position.x;
    }
    if (position.y < size+100 || position.y+size>height-100){
       velocity.y *=-1;  
       if(position.y<size+100) position.y *=-1;
       else if(position.y+size>height-100) position.y=2*(height+100-size)-position.y;
    } 
  }
   
  //豚が動く様子のアニメーションとその時の豚の様子を表示
  void execute() {
    update();
    showPig();
  }
  
  
  void eat(Meat m){
    ArrayList<PVector> meat=m.getMeat();
     for (int i = meat.size()-1; i >=0; i--) {
      PVector meatposition = meat.get(i);
      float distance = PVector.dist(position, meatposition);//肉と豚の位置から距離を求める
      
      //肉と豚の距離が豚の大きさより小さければ豚は肉を食べることができるとし
      //寿命をのばして,肉を取り除く
      if (distance < size) {
        lifespan += 100; 
        meat.remove(i);
      }
    }
  }
  
    Pig reproduce(){
    //0.1%の確率で親が子を生成する.
    if(random(1)<0.001){
      //子に親の遺伝子を複製
       DNA child=dna.copyDNA();
       child.mutation(0.01);//1%の確率で突然変異
      return new Pig(position,child);
    }
    else {
      return null;
    }
  }
  
    //豚が寿命が尽き死んでいるかいないか判定
    boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
  /*
    //豚が肉を食べるということを実現するために利用する
  ArrayList getPig(){
    return pig;
  }
  */
  
}

class Wolf{
 
  PVector position;//豚の位置
  DNA dna;
  float lifespan;//豚の寿命
  //速度のx方向とy方向の乱数を生成するための種
  float xrandom;
  float yrandom;
  
  float size;//豚の大きさ
  float speed;//豚が動く速さ
  
   Wolf(PVector w,DNA d){
     position=w.get();//狼の位置の取得
     lifespan=300;
     xrandom=random(1000);
     yrandom=random(1000);
     dna=d;
     
     /*
       genes[0]の値(0～1まで)を10から0に変換することで
       豚の動くスピードを実現
       同様にgenes[0]の値を0から60までに変換することで
       豚の大きさの変化を実現
       
       このようにすることで,豚の大きさが大きいほど,豚が動くスピード
       が遅くなるという状況を実現させている.
     */
     speed=map(dna.genes[0],0,1,10,0);
     size=map(dna.genes[0],0,1,0,60);
   }
  
  //豚の表示
  void showWolf() {
   //檻の範囲内で表示する
   if(position.x>100 && position.x<width-100 && position.y>100 && position.y<height-100){ 
      fill(#ff0000, lifespan);
       pushMatrix();
       translate(position.x,position.y,0);
       rotateX(radians(90));
       drawWolf(size);
      popMatrix();
     }
     
  }
  
  //豚がランダムに動く様子を表現する更新処理を記述
  void update(){
    
    //0から1の乱数の種をspeedで
    float vx = map(noise(xrandom),0,1,-speed,speed);
    float vy = map(noise(yrandom),0,1,-speed,speed);
    
    PVector velocity = new PVector(vx,vy);//初期速度の設定
    //x方向,y方向の速度を示す乱数値を更新 このようにすることで豚が動くアニメーションを実現
    xrandom += 0.01;
    yrandom += 0.01;
    position.add(velocity);
    lifespan -= 0.5;
    
    //豚が檻から出ないようにするための処置
    if (position.x < size+100 || position.x+size>width-100) {
       velocity.x*=-1;
       if(position.x<size+100) position.x *=-1;
       else if(position.x+size>width-100) position.x=2*(width+100-size)-position.x;
    }
    if (position.y < size+100 || position.y+size>height-100){
       velocity.y *=-1;  
       if(position.y<size+100) position.y *=-1;
       else if(position.y+size>height-100) position.y=2*(height+100-size)-position.y;
    } 
  }
   
  //豚が動く様子のアニメーションとその時の豚の様子を表示
  void execute() {
    update();
    showWolf();
  }
  
  
  void eat(Pig p){
    ArrayList<PVector> pig=p.getPig();
     for (int i = pig.size()-1; i >=0; i--) {
      PVector pigposition = pig.get(i);
      float distance = PVector.dist(position, pigposition);//狼と豚の位置から距離を求める
      
      //狼と豚の距離が豚の大きさより小さければ豚は肉を食べることができるとし
      //寿命をのばして,肉を取り除く
      if (distance < size) {
        lifespan += 100; 
        pig.remove(i);
      }
    }
  }
  
  
    //狼が寿命が尽き死んでいるかいないか判定
    boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
  
}

/*************************************************************************** 
*                                                                          *
*  Fieldクラス                                                             *
*  豚や肉の情報をインスタンスとして檻の中で呼び出すクラス.マウスクリックに *
*  より豚や肉も生み出すこともできる..                                      *
*                                                                          *
*  由川担当分                                                              *
*                                                                          *
****************************************************************************/

class Field{

  ArrayList<Pig> pig;
  Meat meat;

  //シミュレーション開始時の豚と肉の位置を設定するコンストラクタ
  Field(int num){
   meat =new Meat((int)(random(num))+2);
   pig=new ArrayList<Pig>();

   
   //肉と豚を引数numで指定した数の中の乱数の範囲内で生成
   for(int i=0;i<(int)(random(num))+2; i++){
      PVector object=new PVector(random(width),random(height));
      DNA dna= new DNA();
      pig.add(new Pig(object,dna));
      meat.addMeat(object);
    }    
  }
  
  //肉の追加(マウスイベント処理で利用)
   void generateMeat(float x,float y){
    meat.addMeat(new PVector(x,y)); 
  }
  
  //豚の追加(マウスイベント処理で利用)
  void bornPig(float x, float y) {
    PVector p = new PVector(x,y);
    DNA dna = new DNA();
    pig.add(new Pig(p,dna));
  }
  
  //シミュレーションの開始をするメソッド
  void execute(){
    meat.showMeat();
     //親が子を生成する,全部の豚を総当たりして子の確率が指定乱数以上で
    for(int i=pig.size()-1;i>=0;i--){
      Pig p=pig.get(i);
      p.execute();
      p.eat(meat);
      if(p.isDead()){
        pig.remove(i);
      }  
      Pig child=p.reproduce();
      if(child!=null){
        pig.add(child);
      }
     }
   }
}

/*
class Field2{
  ArrayList<Wolf> wolf;
  Pig pig;
   Field2(int num){    
     wolf=new ArrayList<Wolf>();
  for(int i=0;i<num; i++){
      PVector object=new PVector(random(width),random(height));
      DNA dna= new DNA();
      wolf.add(new Wolf(object,dna));
     }  
   }
  //シミュレーションの開始をするメソッド
  void execute(){
   for(int i=wolf.size()-1;i>=0;i--){
      Wolf w=wolf.get(i);
      w.execute();
      w.eat(pig);
      
      if(w.isDead()){
        wolf.remove(i);
      }  
    }
  }
  
}
*/

/*************鳴海担当分******************/
//テクスチャマッピングを施した草原の描画
void drawGrass(float s){
   pushMatrix();
     scale(s,s,s);
     beginShape(QUADS);
        texture(grassimg);
        textureMode(NORMAL);
        rotateY(PI/2);
        vertex(0, 0, 0, 0, 0); vertex(0, 0, 1, 0, 1);
        vertex(1, 0, 1, 1, 1); vertex(1, 0, 0, 1, 0);
      endShape();
   popMatrix();
}


//テクスチャマッピングを施した檻の描画
void texturedCage(){
  pushMatrix();
    translate(-.5, -.5, -.5);
    beginShape(QUADS);
      texture(cageimg);
      textureMode(NORMAL);
      vertex(0, 1, 0, 0, 0); vertex(0, 0, 0, 0, 1);
        vertex(1, 0, 0, 1, 1); vertex(1, 1, 0, 1, 0);
      vertex(1, 1, 0, 0, 0); vertex(1, 0, 0, 0, 1);
        vertex(1, 0, 1, 1, 1); vertex(1, 1, 1, 1, 0);
      vertex(1, 1, 1, 0, 0); vertex(1, 0, 1, 0, 1);
        vertex(0, 0, 1, 1, 1); vertex(0, 1, 1, 1, 0);
      vertex(0, 1, 1, 0, 0); vertex(0, 0, 1, 0, 1);
        vertex(0, 0, 0, 1, 1); vertex(0, 1, 0, 1, 0);
      vertex(0, 1, 1, 0, 0); vertex(0, 1, 0, 0, 1);
        vertex(1, 1, 0, 1, 1); vertex(1, 1, 1, 1, 0);
      vertex(0, 0, 0, 0, 0); vertex(0, 0, 1, 0, 1);
        vertex(1, 0, 1, 1, 1); vertex(1, 0, 0, 1, 0);
    endShape();
  popMatrix();
}

//テクスチャマッピングにした檻の大きさや場所の設定
void cage(){
  fill(128, 64, 0);
  pushMatrix();
    scale(1,1,1);
    translate(0, .5, 0);
    texturedCage();
  popMatrix();
}

//テクスチャマッピングした檻をフィールドに表示(これを呼び出して初めて檻が画面に現れる)
void drawCage(float s){
  noStroke();
  pushMatrix();
    scale(s, s, s);
    cage();
  popMatrix();
}
/****************鳴海担当終了*******************/


/****************戸田担当分*********************/
//豚の描画
void pigBody(){
  
  pushMatrix();
    scale(0.7, 0.3, 0.5);
    translate(0, 0.8, 0);
    box(1);
  popMatrix();
  
  pushMatrix();
    scale(0.4, 0.3, 0.35);
    translate(0.7, 1.8, 0);
     box(1);
  popMatrix();
  
  pushMatrix();
    scale(0.17, 0.15, 0.18);
    translate(1.4, 0.2, 1.0);
     box(1);
  popMatrix();
  
   pushMatrix();
    scale(0.17, 0.15, 0.18);
    translate(-1.4, 0.2, 1.0);
     box(1);
  popMatrix();
 
   pushMatrix();
    scale(0.17, 0.15, 0.18);
    translate(1.4, 0.2, -1.0);
     box(1);
  popMatrix();
  
  
   pushMatrix();
    scale(0.17, 0.15, 0.18);
    translate(-1.4, 0.2, -1.0);
     box(1);
  popMatrix();

}

//豚を引数で定めた大きさでフィールド上に表示するための関数
void drawPig(float s){

    noStroke();
    pushMatrix();
      scale(s, s, s);
      pigBody(); 
    popMatrix();
}

void wolfBody(){
  
  pushMatrix();
    scale(0.7, 0.3, 0.5);
    translate(0, 0.8, 0);
    box(1);
  popMatrix();
  
  pushMatrix();
    scale(0.4, 0.3, 0.35);
    translate(0.7, 1.8, 0);
     box(1);
  popMatrix();
  
  pushMatrix();
    scale(0.17, 0.15, 0.18);
    translate(1.4, 0.2, 1.0);
     box(1);
  popMatrix();
  
   pushMatrix();
    scale(0.17, 0.15, 0.18);
    translate(-1.4, 0.2, 1.0);
     box(1);
  popMatrix();
 
   pushMatrix();
    scale(0.17, 0.15, 0.18);
    translate(1.4, 0.2, -1.0);
     box(1);
  popMatrix();
  
  
   pushMatrix();
    scale(0.17, 0.15, 0.18);
    translate(-1.4, 0.2, -1.0);
     box(1);
  popMatrix();

}

//豚を引数で定めた大きさでフィールド上に表示するための関数
void drawWolf(float s){

    noStroke();
    pushMatrix();
      scale(s, s, s);
      wolfBody(); 
    popMatrix();
}



//肉を描画するための関数
void meatBody(){
  
  pushMatrix();
    fill(#955629);
    scale(0.7, 0.3, 0.5);
    box(1);
  popMatrix();
  
  pushMatrix();
    fill(255);
    scale(0.2, 0.1, 0.2);
    translate(2.2, 0.5, 0);
    box(1);
  popMatrix();
  
   pushMatrix();
    fill(255);
    scale(0.2, 0.1, 0.2);
    translate(-2.2, 0.5, 0);
    box(1);
  popMatrix();
  
}

//肉をフィールド上に表示するための関数
void drawMeat(float s){
    pushMatrix();
      scale(s, s, s);
      meatBody();
    popMatrix();
}

/************戸田担当終了**************/


//画面サイズ,画面に現れるフォント設定,テクスチャの読み込みなど初期設定
//由川担当
void setup(){

  size(800,600,P3D);
  noStroke();
  textFont(createFont("Tempus Sans ITC", 20)); 
  field= new Field(10);
  field2= new Field2(2);
  cageimg=loadImage("cage.jpg");
  grassimg=loadImage("grass.jpg");
  
}

//豚,肉,草原,檻の表示とシミュレーションの実行
//Processingでのメイン関数に相当
//由川担当
void draw(){
  background(255);
  lights();
  
  //シミュレーションの初期状態(肉や豚の位置と数)を表示.
  field.execute();
//  field2.execute();
  
  //草原の表示
  for(int i=0;i<4;i++){
    for(int j=0;j<3;j++){  
    pushMatrix();
      translate(200*i,200*j,-200);
      rotateX(radians(90));
      drawGrass(200); 
    popMatrix();     
    
    }
  }
    
  //檻を指定位置に表示
   for(int i=0;i<17;i++){
     for(int j=1;j<12;j++){
       
    pushMatrix();
      translate(0,50*j,-200);
      rotateX(radians(90));
      drawCage(50); 
    popMatrix();     
    
     pushMatrix();
      translate(800,50*j,-200);
      rotateX(radians(90));
      drawCage(50); 
    popMatrix();   
    
     pushMatrix();
      translate(50*i,0,-200);
      rotateX(radians(90));
      drawCage(50); 
    popMatrix();   
    
     pushMatrix();
      translate(50*i,600,-200);
      rotateX(radians(90));
      drawCage(50); 
    popMatrix();   
    
    }
  }
   
   //右クリックで,肉の生成,左クリックで豚の生成をしめすことを画面に表示
   fill(0);
   text("If you click LEFT, you can generate pig.",20,15);
   text("If you click RIGHT, you can generate meat.",20,40);
}

//マウスクリックを行ったときのイベント処理 戸田考案と担当
void mouseClicked() {
 
  //マウスを右クリックしたときの座標を取得することで肉を加える.
  if(mouseButton==RIGHT){
    field.generateMeat(mouseX,mouseY); 
  } 
  
 //マウスを左クリックしたときの座標を取得することで豚を加える.
  if(mouseButton==LEFT){
    field.bornPig(mouseX,mouseY);
  }
    
}