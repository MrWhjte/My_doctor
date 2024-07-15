import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretty_gauge/pretty_gauge.dart';

class ScoreScreen extends StatelessWidget {
  final double bmiScore;

  String? bmiStatus;

  String? bmiInterpretation;

  Color? bmiStatusColor;

  ScoreScreen({Key? key, required this.bmiScore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setBmiInterpretation();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Tình trạng của bạn",
            style: TextStyle(fontSize: 25, color: Colors.blue,fontWeight: FontWeight.w700)),
      ),
      body: Container(
          color: Colors.white,
          child: Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrettyGauge(
                        gaugeSize: 350,
                        minValue: 0,
                        maxValue: 40,
                        segments: [
                          GaugeSegment('UnderWeight', 18.5, Colors.red),
                          GaugeSegment('Normal', 6.4, Colors.green),
                          GaugeSegment('OverWeight', 5, Colors.orange),
                          GaugeSegment('Obese', 10.1, Colors.pink),
                        ],
                        valueWidget: Text(
                          bmiScore.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 40),
                        ),
                        currentValue: bmiScore.toDouble(),
                        needleColor: Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        bmiStatus!,
                        style: TextStyle(fontSize: 24, color: bmiStatusColor!,fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Lời khuyên: ",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.start,
                              bmiInterpretation!,
                              style: const TextStyle(fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 300,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                  textAlign: TextAlign.center,
                                  "Kiểm tra lại",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                            ),
                          ),
                        ],
                      )
                    ]),
              )),
    );
  }

  void setBmiInterpretation() {
    if (bmiScore > 40) {
      bmiStatus = "Béo phì cấp độ 3 (béo phì bệnh lý)";
      bmiInterpretation =
          "Đây là mức độ béo phì nghiêm trọng, cần được quản lý chặt chẽ bởi "
              "các chuyên gia y tế. Có thể cần đến các biện pháp can thiệp y tế "
              "như phẫu thuật giảm cân. Quan trọng là phải thay đổi lối sống một "
              "cách toàn diện, bao gồm chế độ ăn uống lành mạnh và tập luyện thể dục thường xuyên.";
      bmiStatusColor = Colors.pink;
    } else if (bmiScore > 35) {
      bmiStatus = "Béo phì cấp độ 2";
      bmiInterpretation =
          "Cần có biện pháp can thiệp y tế và thay đổi lối sống mạnh mẽ để giảm "
              "cân. Thường xuyên kiểm tra sức khỏe và theo dõi các chỉ số y tế"
              " dưới sự hướng dẫn của bác sĩ. Chế độ ăn uống nên được điều chỉnh "
              "nghiêm ngặt và kết hợp với các bài tập thể dục phù hợp.";
      bmiStatusColor = Colors.pink;
    } else if (bmiScore > 30) {
      bmiStatus = "Béo phì cấp độ 1";
      bmiInterpretation =
          "Cần có kế hoạch giảm cân nghiêm túc để tránh các biến chứng sức khỏe "
              "liên quan đến béo phì như tiểu đường, tim mạch và cao huyết áp. "
              "Tăng cường hoạt động thể chất và điều chỉnh chế độ ăn uống dưới "
              "sự giám sát của bác sĩ hoặc chuyên gia dinh dưỡng.";
      bmiStatusColor = Colors.pink;
    } else if (bmiScore >= 25) {
      bmiStatus = "Thừa cân";
      bmiInterpretation =
          "Cần chú ý đến việc giảm cân một cách lành mạnh. Tăng cường vận động, "
              "tập luyện thể dục thường xuyên và giảm lượng calo hấp thụ từ thức "
              "ăn, đặc biệt là các loại thức ăn chứa nhiều đường và chất béo. Nên "
              "tham khảo ý kiến bác sĩ hoặc chuyên gia dinh dưỡng để có kế hoạch "
              "giảm cân hiệu quả.";
      bmiStatusColor = Colors.orange;
    } else if (bmiScore >= 18.5) {
      bmiStatus = "Cân nặng bình thường";
      bmiInterpretation =
          "Duy trì chế độ ăn uống cân đối và tập luyện đều đặn để giữ vững tình "
              "trạng sức khỏe tốt. Kiểm soát lượng calo hấp thụ và tăng cường vận"
              "động thể chất hàng ngày để duy trì cân nặng ổn định.";
      bmiStatusColor = Colors.green;
    } else if (bmiScore < 18.5) {
      bmiStatus = "Thiếu cân";
      bmiInterpretation =
          "Cần bổ sung dinh dưỡng một cách hợp lý để đạt được cân nặng "
          "lý tưởng. Tăng cường chế độ ăn giàu protein, carbohydrate và chất "
          "béo lành mạnh. Nên tham khảo ý kiến bác sĩ hoặc chuyên gia dinh dưỡng "
          "để có kế hoạch ăn uống và tập luyện phù hợp.";
      bmiStatusColor = Colors.red;
    }
  }
}
