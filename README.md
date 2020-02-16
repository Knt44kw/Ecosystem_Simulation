# Ecosystem_Simulation
遺伝的アルゴリズムを使って生態系シミュレーション．
<br>具体的には 檻の中にいる豚に食べ物を与えたときに,大小さまざまな豚のうちどの豚が最も生き残るのかを検証する.
適者生存のシミュレーションモデル

### シミュレーションのルール
1. 豚は大小様々で,ランダムに檻に囲まれた草原内を動く. 豚は大きい豚ほど動きが遅く,小さい豚ほど動きが速い.
2. 豚は食べ物(今回は肉)が近くにあれば,それを食べることで寿命を延ばすことができる. <br>食べることができなければいずれ死ぬ.
3. 問題の単純化のため無性生殖を想定し，親の情報を子がそのまま引き継ぐ. この行為を起こす確率を生殖率と呼ぶ.
4. 親から生まれた子が突然変異を1%の確率で起こす.

### プログラムの概要
* DNAクラス: 豚の遺伝子型として,突然変異,遺伝子情報の複製をまとめた<br>
* Pigクラス: 豚の表現型として豚の大きさや移動速度などの情報をまとめた<br>
* Meatクラス: 豚の食べ物になる肉の位置情報をまとめた<br>
* マウスクリックによりPigクラス，Meatクラス内の新たな個体生成のメソッドを呼び出す処理の構築

### シミュレーション結果
* 継続して行っていくと中間ぐらいの大きさの豚が最も生き残る.
* 大きい豚は動きが遅いために,肉にたどり着く前に死ぬ.
* 小さい豚は体の大きさのため肉を見つけることができず死ぬ.
* 生殖率を上げると豚が過剰に生まれ,肉の供給が追いつかず，いずれの大きさの豚でも死ぬ.







