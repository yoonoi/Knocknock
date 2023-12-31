import 'package:flutter/material.dart';
import 'package:knocknock/components/buttons.dart';
import 'package:knocknock/models/my_appliance_model.dart';
import 'package:knocknock/providers/my_appliance.dart';
import 'package:knocknock/providers/page_index.dart';
import 'package:knocknock/screens/display_info_screen.dart';
import 'package:knocknock/services/model_service.dart';
import 'package:provider/provider.dart';
import 'package:knocknock/screens/home_screen.dart';
import 'package:knocknock/widgets/app_bar_back.dart';

class ManualRegister extends StatefulWidget {
  const ManualRegister({super.key});

  @override
  State<ManualRegister> createState() => _ManualRegisterState();
}

const List<String> list = <String>['냉장고', '세탁기', '어쩌구', '저쩌구'];

class _ManualRegisterState extends State<ManualRegister> {
  ModelService modelService = ModelService();
  String dropdownValue = list.first;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  late MyModelRegistering? info;

  getModelInfo() async {
    final modelName = myController.text.trim();
    info = await modelService.findRegistering(modelName);
    print('넣었니? $info');
    if (!mounted) return;
    context.read<RegisterAppliance>().register(info);
  }

  failLoad() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Retrieve the text the that user has entered by using the
          // TextEditingController.
          content: const Text(
            '모델명을 조회할 수 없습니다.',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  dup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Retrieve the text the that user has entered by using the
          // TextEditingController.
          content: const Text(
            '이미 내 가전으로 등록되어있습니다.\n내 가전 목록으로 이동하시겠어요?',
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<CurrentPageIndex>().move(3);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              child: const Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: '직접 입력하기',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 30,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '제품의 모델명을\n정확히 입력해주세요',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                decoration: const BoxDecoration(
                    // image: DecorationImage(
                    //   image: AssetImage('assets/images/label_example_blur.png'),
                    // ),
                    ),
                child: Image.asset('assets/images/label_example_blur.png',
                    scale: 1.5),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Text(
                        '모델명 : ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      title: TextFormField(
                        controller: myController,
                        decoration: const InputDecoration(
                          hintText: '모델명을 입력하세요.',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '값을 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    KnockButton(
                      onPressed: () async {
                        await getModelInfo();
                        if (info == null) {
                          failLoad();
                        } else if (info!.category! == '중복') {
                          dup();
                        } else {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const DisplayInfoScreen(),
                            ),
                          );
                        }
                      },
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.16,
                      label: '조회하기',
                      bColor: Theme.of(context).colorScheme.primary,
                      fColor: Theme.of(context).colorScheme.onPrimary,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
