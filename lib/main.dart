import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum AppTheme { light, dark }
enum AppLanguage { hindi, english }

class AppState {
  final AppTheme theme;
  final AppLanguage language;

  AppState({required this.theme, required this.language});

  factory AppState.initialState() =>
      AppState(theme: AppTheme.light, language: AppLanguage.english);
}

enum AppActions { toggleTheme, toggleLanguage }

AppState appReducer(AppState state, action) {
  if (action == AppActions.toggleTheme) {
    return AppState(
        theme: state.theme == AppTheme.light ? AppTheme.dark : AppTheme.light,
        language: state.language);
  }

  if (action == AppActions.toggleLanguage) {
    return AppState(
        theme: state.theme,
        language:
        state.language == AppLanguage.english ? AppLanguage.hindi : AppLanguage.english);
  }
  return state;
}

void main() {
  final Store<AppState> store = Store<AppState>(appReducer, initialState: AppState.initialState(),);

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp({required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreBuilder<AppState>(
        builder: (BuildContext context, Store<AppState> store) {

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Redux',
            theme: ThemeData(
              brightness:
              store.state.theme == AppTheme.light ? Brightness.light : Brightness.dark,
            ),
            home: MyHomePage(t: store.state.language == AppLanguage.hindi ? 1 : 0,z: store.state.theme == AppTheme.light ? 1 : 0),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final int t;
  final int z;
  MyHomePage({required this.t,required this.z});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t==1?"पहला काम":"First Task"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: z==1?Colors.black:Colors.white,
              width: 8
            ),
            borderRadius: BorderRadius.circular(9)
          ),
          child: Text(
             t==1?"नमस्ते":"Hello",
            style: TextStyle(fontSize: 36),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(z==1?Icons.sunny:FontAwesomeIcons.moon),
              onPressed: () =>
                  StoreProvider.of<AppState>(context).dispatch(AppActions.toggleTheme),
            ),
            Container(
              padding: EdgeInsets.all(12),
              child: DropdownButton(
                value: StoreProvider.of<AppState>(context).state.language,
                items: [
                  DropdownMenuItem(
                    value: AppLanguage.hindi,
                    child: Text('Hindi'),
                  ),
                  DropdownMenuItem(
                    value: AppLanguage.english,
                    child: Text('English'),
                  ),
                ],
                onChanged: (value) => StoreProvider.of<AppState>(context)
                    .dispatch(AppActions.toggleLanguage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}