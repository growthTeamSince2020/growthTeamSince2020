import 'package:flutter/material.dart';
import 'score_bar.dart';
import 'game.dart';
import 'next_block.dart';
import 'block.dart';

import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    // モデルオブジェクトに変更があると、リッスンしているWidget(配下の子Widet)を再構築する
    ChangeNotifierProvider(
      // モデルオブジェクトを作成する
      create: (context) => Data(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 画面をportraitモードに固定する
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      home: Tetris extends StatefulWidget(),
    );
  }
}

class Tetris extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TetrisState();

}

// 「_」をつけるとプライベートになる
class _TetrisState extends State<Tetris>{

  // Gameエリアのウィジェットにアクセスするためグローバルキーを使う
  // *GameStateをパブリッククラスにし、Keyを受け入れるコンストラクタを作っておくこと
  GlobalKey<GameState> _keyGame = GlobalKey();

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('TETRIS'),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // 全てのWidgetを一つのファイルにいれると面倒になる。
            // 必要なWidgetをデバックで見つけることも難しくなる。
            // なので、別ファイルにクラスを宣言します。
            // ScoreBarクラスはインジケータ表示するWidgetです。
            ScoreBar()

          ],
        )
      ),
    )
  }
}




class Data with ChangeNotifier {
  int score = 0;
  bool isPlaying = false;
  Block nextBlock;

  // 次のブロックをセットする
  void setNextBlock(Block nextBlock) {
    this.nextBlock = nextBlock;
    notifyListeners();
  }

  // 次のブロックを取得する
  Widget getNextBlockWidget() {
    // ゲームがプレイされていない時は空の透明なコンテナを返す
    if (!isPlaying) return Container();

    // ブロックを取得するには幅、高さ、色の情報が必要
    var width = nextBlock.width;
    var height = nextBlock.height;
    var color;

    // ブロックい含まれるコンテナの総数は、幅（Columnsの数）* 高さ(rowsの数)
    // yとxの値をループして、コンテナの行列を生成
    List<Wiget> columns = [];
    for (var y = 0; y < height; ++y) {
      List<Widget> rows = [];
      for (var x = 0; x < width; ++x) {
        // ブロックの形が見えるようコンテナごとに色をつける。
        // サブブロックが行列の要素と同じ座標を持つ場合
        if (nextBlock.subBlocks
                .where((subBlocks) => subBlocks.x == x && subBlocks.y == y)
                .length >
            0) {
          // 次のブロックの色
          color = nextBlock.color;
        } else {
          // 透明色
          color = Colors.transparent;
        }

        // 各コンテナのサイズは 12 * 12
        rows.add(Container(
          width: 12,
          height: 12,
          color: color,
        ));
      }
      // 列と行を使って全てのコンテナを結合し、水平、垂直方向に整列させる。
      columns.add(
          Row(mainAxisAlignment: MainAxisAlignment.center, children: rows));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: columns,
    );
  }
}

mixin Wiget {}

class Block {
  get width => null;

  get height => null;

  get subBlocks => null;

  get color => null;
}
