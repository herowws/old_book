import R from '../../common/constants/R';
import { ThemeData, ThemeManager } from '../../common/theme/theme_manager';
import { LoginController } from './controller';
import { Protocol } from './widgets/protocol';


@Builder
export function RouteBuilder() {
  LoginPage()
}


@Entry
@Component
export struct LoginPage {
  @StorageProp(ThemeManager.themeKey) theme: ThemeData = {} as ThemeData;
  @State required: boolean = false;
  @State isShowSheet: boolean = false;
  @Consume('pageStack') pageStack: NavPathStack;
  controller: LoginController = new LoginController();

  aboutToAppear(): void {
    this.controller.pageStack = this.pageStack;
  }

  @Builder
  SheetBuilder() {
    Column() {
      Text('请阅读并同意以下条款')
        .padding({ top: 20 })
        .fontWeight(500)
      Text('《用户协议》《隐私政策》《未成年个人信息保护规则》')
        .padding({ top: 40, bottom: 40 })
        .fontSize(12)
      Button('同意并继续')
        .width('80%')
        .backgroundColor(this.theme.mainColor)
      Blank()
    }.height(R.full)

  }

  build() {
    NavDestination() {
      Column() {
        Text('老红书')
          .fontSize(40)
          .fontColor(this.theme.mainColor)
          .fontWeight(900)
          .margin({ top: 80, bottom: 10 })

        Text('老登，你渴望力量吗')
          .fontColor(0x5B5B5B)

        Blank()
        Column() {
          Image($r('app.media.avatar'))
            .width(60)
            .height(60)
            .objectFit(ImageFit.Auto)
            .margin({ bottom: 15 })
          Text('老红薯67890DE3')
            .fontWeight(500)
            .fontSize(18)
          Button('登录此账号')
            .backgroundColor(this.theme.mainColor)
            .width(R.full)
            .margin({ top: 15, bottom: 15 })
            .onClick(() => {
              this.controller.onSubmit();
            })
            .bindSheet($$this.isShowSheet, this.SheetBuilder(), {
              height: 220,
              dragBar: false,
              preferType: SheetType.BOTTOM,
              blurStyle: BlurStyle.Thick,
              showClose: false,
            })
          Text('其他登录方式')
            .fontWeight(500)
            .fontSize(13)
            .fontColor(0x1C3564)
          Protocol({ required: this.required })
            .padding(10)
        }
        .padding({ left: 25, right: 25 })
        .margin({ bottom: 20 })
      }
      .height(R.full)
      .width(R.full)
    }
  }
}