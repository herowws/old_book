import { ThemeData, ThemeManager } from '../common/theme/theme_manager';

@Entry
@Component
struct MainPage {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack()
  @StorageProp(ThemeManager.themeKey) theme: ThemeData = {} as ThemeData
  @State currentIndex: number = 0;

  @Builder
  IconTabBuilder() {
    Button('+', { type: ButtonType.Normal, stateEffect: true })
      .fontSize(20)
      .borderRadius(10)
      .padding({
        left: 20,
        right: 20
      })
      .fontColor(Color.White)
      .backgroundColor(this.theme.mainColor)
  }

  @Builder
  TextTabBuilder(text: string, index: number) {
    Text(text).fontColor(index == this.currentIndex ? this.theme.mainColor : 0x999999)
  }

  @Builder
  build() {
    Navigation(this.pageStack) {
    }

    // Navigation(this.pageStack) {
    //   Tabs({ barPosition: BarPosition.End }) {
    //     TabContent() {
    //       //HomePage()
    //     }
    //     .tabBar(this.TextTabBuilder('首页', 0))
    //
    //     TabContent() {
    //       Text('热门的内容').fontSize(30).onClick(() => {
    //       })
    //     }
    //     .tabBar(this.TextTabBuilder('热门', 1))
    //
    //     TabContent() {
    //       Text('+的内容').fontSize(30).onClick(() => {
    //         this.pageStack.pushPathByName("login", null, false);
    //       })
    //     }
    //     .tabBar(this.IconTabBuilder())
    //
    //     TabContent() {
    //       Text('消息的内容').fontSize(30)
    //     }
    //     .tabBar(this.TextTabBuilder('消息', 3))
    //
    //     TabContent() {
    //       Text('我的内容').fontSize(30)
    //     }
    //     .tabBar(this.TextTabBuilder('我的', 4))
    //   }.onChange((index) => this.currentIndex = index)
    //   .barMode(BarMode.Fixed)
    // }.mode(NavigationMode.Auto)
    // .hideNavBar(false)
    // .hideToolBar(true)
  }
}