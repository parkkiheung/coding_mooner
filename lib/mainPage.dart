import 'package:coding_mooner/historyPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mainPageController.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(mainPageController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('나의 작은 씨니어 개발자...코딩무너'),
        leading: const Image(
          image: AssetImage('images/128.png'),
        ),
        actions: [
          TextButton(
              onPressed: () {
                controller.downloadFile();
                print("업데이트 버튼 클릭");
              },
              child: const Text('업데이트')),
          TextButton(
              onPressed: () {
                Get.to(() => HistoryPage());
              },
              child: const Text('기록보기')),
          TextButton(
              onPressed: () {
                Get.dialog(
                  const AlertDialog(
                    title: Text("도움말"),
                    content: Text("Ollama 설치 가이드, 사용법 등에 대한 도움말이 들어갈 예정입니다."),
                  ),
                );
              },
              child: const Text('도움말')),
        ],
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width * 0.5,
            height: MediaQuery.sizeOf(context).height * 1,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 184, 216, 180),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        DropdownButton(
                            items: const [
                              DropdownMenuItem(
                                value: "codeReview",
                                child: Text("코드리뷰"),
                              ),
                              DropdownMenuItem(
                                value: "tc",
                                child: Text("Test Code 생성"),
                              ),
                              DropdownMenuItem(
                                value: "TDD",
                                child: Text("TDD방식으로 구현코드 생성", style: TextStyle(fontSize: 12),),
                              ),
                              DropdownMenuItem(
                                value: "sql",
                                child: Text("SQL 생성"),
                              ),
                            ],
                            value: controller.mainType.value,
                            onChanged: (value) {
                              //print(value);
                              if (value == "sql") {
                                controller.subType.value = "mysql";
                              } else if(value == "TDD") {
                                controller.subType.value = "";
                              }
                              else {
                                controller.subType.value = "Spring";
                              }
                              controller.mainType.value = value!;
                            }),
                        controller.mainType.value == "codeReview" || controller.mainType.value == "tc"
                            ? DropdownButton(
                                items: const [
                                    DropdownMenuItem(
                                      value: "Spring",
                                      child: Text("Spring"),
                                    ),
                                    DropdownMenuItem(
                                      value: "JAVA",
                                      child: Text("JAVA"),
                                    ),
                                    DropdownMenuItem(
                                      value: "PYTHON",
                                      child: Text("PYTHON"),
                                    ),
                                    DropdownMenuItem(
                                      value: "JavaScript",
                                      child: Text("Java Script"),
                                    ),
                                  ],
                                value: controller.subType.value,
                                onChanged: (value) {
                                  //print(value);
                                  controller.subType.value = value!;
                                })
                            : controller.mainType.value=="sql"? DropdownButton(
                                items: const [
                                    DropdownMenuItem(
                                      value: "mysql",
                                      child: Text("MY SQL"),
                                    ),
                                    DropdownMenuItem(
                                      value: "Oracle",
                                      child: Text("oracle"),
                                    ),
                                    DropdownMenuItem(
                                      value: "auroraDB",
                                      child: Text("Aurora DB"),
                                    ),
                                  ],
                                value: controller.subType.value,
                                onChanged: (value) {
                                  print(value);
                                  controller.subType.value = value!;
                                }):SizedBox.shrink(),
                        SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.18,
                            height: MediaQuery.sizeOf(context).height * 0.05,
                            child: TextField(
                                controller: controller.modelTextController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'codellama:13b-instruct',
                                ))),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () async {
                            controller.getAnswer();
                          },
                          child: const Text(
                            '도와줘(클릭)',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextFormField(
                          controller: controller.questionTextController,
                          autofocus: true,
                          obscureText: false,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            labelText: '코드를 입력하세요',
                          ),
                          style: const TextStyle(
                            fontFamily: 'Readex Pro',
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 100,
                          //validator: _model.textControllerValidator.asValidator(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() => Container(
                width: MediaQuery.sizeOf(context).width * 0.5,
                height: MediaQuery.sizeOf(context).height * 1,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(0, 82, 131, 0),
                ),
                child: controller.loading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView(
                          children: [
                            SelectableText(controller.answer.value),
                          ],
                        ),
                      ),
              )),
        ],
      ),
    );
  }
}
