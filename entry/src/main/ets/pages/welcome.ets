import R from '../common/constants/R';

@Entry
@Component
struct WelcomePage {
  @Consume('pageStack') pageStack: NavPathStack;

  build() {
    Navigation(this.pageStack) {
      Column() {
        Text('老红书')
          .fontSize(40)
          .fontColor(0xEC404B)
          .fontWeight(900)
          .margin({ top: 200, bottom: 10 })
        Text('老登，你渴望力量吗')
          .fontColor(0x5B5B5B)
      }
      .width(R.full)
    }.onAppear(() => {
      setTimeout(() => {
        this.pageStack.pushPath({ name: 'pages/main' }, false);
      }, 300)
    })
  }
}