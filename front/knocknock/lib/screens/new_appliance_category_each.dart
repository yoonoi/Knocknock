import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';
import 'package:knocknock/components/tile.dart';
import 'package:knocknock/constants/color_chart.dart';
import 'package:knocknock/models/appliance_model.dart';
import 'package:knocknock/providers/appliance.dart';
import 'package:knocknock/screens/home_screen.dart';
import 'package:knocknock/screens/new_appliance_categories.dart';
import 'package:knocknock/screens/new_appliance_detail.dart';
import 'package:knocknock/services/model_service.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:knocknock/widgets/app_bar_back.dart';
import 'package:provider/provider.dart';

class NewApplianceCategoryEach extends StatefulWidget {
  const NewApplianceCategoryEach({Key? key}) : super(key: key);

  @override
  State<NewApplianceCategoryEach> createState() =>
      _NewApplianceCategoryEachState();
}

class _NewApplianceCategoryEachState extends State<NewApplianceCategoryEach> {
  final ModelService modelService = ModelService();
  late Future<List<NewModelTile>> modelListFuture; // Future to load modelList
  List<Color> colors = [
    ColorChart.first,
    ColorChart.second,
    ColorChart.third,
    ColorChart.forth,
    ColorChart.fifth,
  ];
  late String selectedCategory;
  @override
  void initState() {
    super.initState();
    // modelListFuture = loadNewModelData(); // Initialize the future
  }

  // 찜 추가
  Future<bool> addLike(int modelId) async {
    late String response;

    response = await modelService.addLike(modelId);
    if (response == '201') {
      return true;
    } else {
      //메세지 pop...
    }
    return false;
  }

  // 찜 삭제
  Future<bool> deleteLike(int modelId) async {
    late String response;

    response = await modelService.cancelLike(modelId);
    if (response == '200') {
      return true;
    } else {
      //메세지 pop...
    }
    return false;
  }

  Future<List<NewModelTile>> loadNewModelData(
    String type,
    String keyword,
    String category,
  ) async {
    try {
      final loadedModelList = await modelService.findNewModelList(
        type: type,
        keyword: keyword,
        category: category,
      );
      return loadedModelList;
    } catch (e) {
      // 에러 처리
      print("Error loading clothing data: $e");
      return [];
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedCategory = context.watch<SelectedAppliance>().category;
    modelListFuture = loadNewModelData('', '', selectedCategory);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String dropdownValue = '모델명';
  String textValue = '';
  TextEditingController keywordController = TextEditingController();

  onSearch() async {
    String keyword = keywordController.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String type = dropdownValue == '모델명' ? 'model' : 'brand';
      // 여기에서 선택한 dropdownValue와 textValue를 사용하여 작업을 수행합니다.
      print('Dropdown Value: $dropdownValue');
      print('Text Value: $keyword');

      setState(() {
        modelListFuture = loadNewModelData(type, keyword, selectedCategory);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(selectedCategory),
      //   leading: IconButton(
      //     alignment: AlignmentDirectional.centerEnd,
      //     enableFeedback: false,
      //     onPressed: () {
      //       print('누름!');
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => const NewApplianceCategories()));
      //     },
      //     icon: const Icon(Icons.west_rounded),
      //   ),
      // ),
      appBar: AppBarBack(
        title: selectedCategory,
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            padding: const EdgeInsets.all(10),
                            borderRadius: BorderRadius.circular(20),
                            dropdownColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.surfaceTint,
                            ),
                            // underline: Container(
                            //   height: 1,
                            //   color: Theme.of(context).colorScheme.surfaceTint,
                            // ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            items: <String>['모델명', '업체명']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: keywordController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              isDense: true,
                              hintText: '검색어를 입력하세요',
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                              suffixIcon: IconButton(
                                onPressed: onSearch,
                                icon: const Icon(Icons.search),
                              ),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            validator: (String? value) {
                              return (value == null) ? '값을 입력하세요' : null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder<List<NewModelTile>>(
                  future: modelListFuture, // Use the preloaded future

                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // 데이터가 아직 준비되지 않은 경우에 대한 UI
                      return const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // 에러 발생 시에 대한 UI
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      // 데이터가 비어 있는 경우에 대한 UI
                      return const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text('원하는 조건의 제품을 찾을 수 없어요:('),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // 데이터를 사용하여 ListView.builder 생성
                      List<NewModelTile> modelList = snapshot.data!;
                      return Expanded(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              //아래 속성들을 조절하여 원하는 값을 얻을 수 있다.
                              begin: Alignment.center,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.01)
                              ],
                              stops: const [0.92, 1],
                              tileMode: TileMode.mirror,
                            ).createShader(bounds);
                          },
                          child: ScrollWrapper(
                            primary: true,
                            scrollOffsetUntilVisible: 10,
                            promptAlignment: Alignment.bottomRight,
                            promptAnimationCurve: Curves.slowMiddle,
                            scrollToTopDuration:
                                const Duration(milliseconds: 1500),
                            builder: (context, properties) {
                              return ListView.builder(
                                key: const PageStorageKey<String>('value'),
                                itemCount: modelList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  // heading(등급)넣어주기 위한 조건
                                  if (index == 0 ||
                                      modelList[index - 1].modelGrade !=
                                          modelList[index].modelGrade) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min, // 추가

                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                            '${modelList[index].modelGrade}등급'),
                                        const Divider(
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                        Tile(
                                          isBookmarked: true,
                                          color: colors[
                                              modelList[index].modelGrade! - 1],
                                          bookmarkIcon: IconButton(
                                            onPressed: () async {
                                              // 찜
                                              if (!modelList[index].isLiked!) {
                                                if (await addLike(
                                                    modelList[index]
                                                        .modelId!)) {
                                                  setState(() {
                                                    modelList[index].isLiked =
                                                        true;
                                                  });
                                                }
                                              } else {
                                                if (await deleteLike(
                                                    modelList[index]
                                                        .modelId!)) {
                                                  setState(() {
                                                    modelList[index].isLiked =
                                                        false;
                                                  });
                                                }
                                              }
                                            },
                                            icon: modelList[index].isLiked!
                                                ? Icon(
                                                    Icons.favorite_rounded,
                                                    color: Colors
                                                        .blueGrey.shade100,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.4), // 그림자 색상과 투명도
                                                        offset: const Offset(0,
                                                            1), // 그림자 offset (가로, 세로)
                                                        blurRadius:
                                                            4, // 그림자의 흐림 정도
                                                      ),
                                                      const Shadow(
                                                        color: Colors.white,
                                                        offset: Offset(0, -1),
                                                        blurRadius: 2,
                                                      ),
                                                    ],
                                                  )
                                                : Icon(
                                                    Icons
                                                        .favorite_outline_rounded,
                                                    color: Colors
                                                        .blueGrey.shade100,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.4), // 그림자 색상과 투명도
                                                        offset: const Offset(0,
                                                            1), // 그림자 offset (가로, 세로)
                                                        blurRadius:
                                                            4, // 그림자의 흐림 정도
                                                      ),
                                                      const Shadow(
                                                        color: Colors.white,
                                                        offset: Offset(0, -1),
                                                        blurRadius: 2,
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          onTap: () {},
                                          onLongPress: () {},
                                          child: ListTile(
                                            onTap: () {
                                              // 상세 페이지로 이동
                                              context
                                                  .read<SelectedAppliance>()
                                                  .selectModel(modelList[index]
                                                      .modelId!);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NewApplianceDetail()), // SignUpPage는 회원가입 페이지 위젯입니다.
                                              );
                                            },
                                            leading: Image.asset(
                                                'assets/icons/$selectedCategory.png'),
                                            title: Text(
                                              modelList[index].modelName!,
                                              style: const TextStyle(
                                                  color: Colors.black87),
                                            ),
                                            subtitle: Text(
                                              modelList[index].modelBrand!,
                                              style: const TextStyle(
                                                  color: Colors.black54),
                                            ),
                                            trailing: const Icon(
                                                Icons.chevron_right_rounded,
                                                size: 35,
                                                color: Colors.white70),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    );
                                  }
                                  // divide할 필요없으면 그냥 카드
                                  return Column(
                                    children: [
                                      Tile(
                                        isBookmarked: true,
                                        color: colors[
                                            modelList[index].modelGrade! - 1],
                                        bookmarkIcon: IconButton(
                                          onPressed: () async {
                                            // 찜
                                            if (!modelList[index].isLiked!) {
                                              if (await addLike(
                                                  modelList[index].modelId!)) {
                                                setState(() {
                                                  modelList[index].isLiked =
                                                      true;
                                                });
                                              }
                                            } else {
                                              if (await deleteLike(
                                                  modelList[index].modelId!)) {
                                                setState(() {
                                                  modelList[index].isLiked =
                                                      false;
                                                });
                                              }
                                            }
                                          },
                                          icon: modelList[index].isLiked!
                                              ? Icon(
                                                  Icons.favorite_rounded,
                                                  color:
                                                      Colors.blueGrey.shade100,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.4), // 그림자 색상과 투명도
                                                      offset: const Offset(0,
                                                          1), // 그림자 offset (가로, 세로)
                                                      blurRadius:
                                                          4, // 그림자의 흐림 정도
                                                    ),
                                                    const Shadow(
                                                      color: Colors.white,
                                                      offset: Offset(0, -1),
                                                      blurRadius: 2,
                                                    ),
                                                  ],
                                                )
                                              : Icon(
                                                  Icons
                                                      .favorite_outline_rounded,
                                                  color:
                                                      Colors.blueGrey.shade100,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.4), // 그림자 색상과 투명도
                                                      offset: const Offset(0,
                                                          1), // 그림자 offset (가로, 세로)
                                                      blurRadius:
                                                          4, // 그림자의 흐림 정도
                                                    ),
                                                    const Shadow(
                                                      color: Colors.white,
                                                      offset: Offset(0, -1),
                                                      blurRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        onTap: () {},
                                        onLongPress: () {},
                                        child: ListTile(
                                          onTap: () {
                                            context
                                                .read<SelectedAppliance>()
                                                .selectModel(
                                                    modelList[index].modelId!);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const NewApplianceDetail()), // SignUpPage는 회원가입 페이지 위젯입니다.
                                            );
                                          },
                                          leading: Image.asset(
                                              'assets/icons/$selectedCategory.png'),
                                          title: Text(
                                            modelList[index].modelName!,
                                            style: const TextStyle(
                                                color: Colors.black87),
                                          ),
                                          subtitle: Text(
                                            modelList[index].modelBrand!,
                                            style: const TextStyle(
                                                color: Colors.black54),
                                          ),
                                          trailing: const Icon(
                                            Icons.chevron_right_rounded,
                                            size: 35,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            )),
      ),
    );
  }
}
