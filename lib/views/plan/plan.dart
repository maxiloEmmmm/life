import 'package:flutter/cupertino.dart';

class Plan extends StatefulWidget {
  const Plan({Key? key}) : super(key: key);

  @override
  State<Plan> createState() => _PlanState();
}

// 1 计划
// 2 进度
// 3 deadLine
// 4 可重复
// 5 可关联事件 比如完成增加其他计划的数值 比如一个任务完成一次 另一个任务的某个参数加1 譬如6
// 6 可能有重复计划 这里建议将重复作为另一个计划 而不是绑定在计划本身

// 产出
// 挑选n多个计划 排列组合 完成相应得到产出

class _PlanState extends State<Plan> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // Uncomment to change the background color
      // backgroundColor: CupertinoColors.systemPink,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('计划'),
      ),
      child: ListView(
        children: <Widget>[
          CupertinoButton(
            onPressed: () => {},
            child: const Icon(CupertinoIcons.add),
          ),
          Center(
            child: Text('You have pressed the button times.'),
          ),
        ],
      )
    );
  }
}