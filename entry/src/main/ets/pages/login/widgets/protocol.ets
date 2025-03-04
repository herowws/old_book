import { webview } from '@kit.ArkWeb';

@Component
export struct Protocol {
  controller: webview.WebviewController = new webview.WebviewController();
  @State active: boolean = false
  @Consume('pageStack') pageStack: NavPathStack;
  @Link required: boolean;

  onWebview(parameter: string) {
    let url = `https://www.baidu.com/s?wd=${parameter}`;
    this.pageStack.pushPathByName("webview", url, false);
  }

  build() {
    Row() {
      Toggle({ type: ToggleType.Checkbox, isOn: this.required })
        .onChange((v) => {
          this.required = v;
        })
        .width(13)
        .height(13)
      Text() {
        Span('我已阅读并同意')
          .fontColor(0x999999)
        Span('《用户协议》')
          .onClick(() => this.onWebview('用户协议'))
        Span('《隐私政策》')
          .onClick(() => this.onWebview('隐私政策'))
        Span('《未成年个人信息保护规则》')
          .onClick(() => this.onWebview('未成年个人信息保护规则'))
      }
      .fontColor(0x1C3564)
      .fontSize(13)
      .lineHeight(19)
    }.alignItems(VerticalAlign.Top)
  }
}
