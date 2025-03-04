import { webview } from '@kit.ArkWeb';

@Builder
export function RouteBuilder() {
  WebviewPage()
}


@Entry
@Component
struct WebviewPage {
  controller: webview.WebviewController = new webview.WebviewController();
  @Consume('pageStack') pageStack: NavPathStack;
  @State url: string = '';

  aboutToAppear(): void {
    let arr = this.pageStack.getParamByName("webview") as Array<string>;
    if (arr.length > 0) {
      this.url = arr[0];
    }
  }

  build() {
    NavDestination() {
      Column() {
        Web({ src: this.url, controller: this.controller })
          .javaScriptAccess(true)
          .multiWindowAccess(false)
          .onWindowExit(() => {
            console.info("NewWebViewComp onWindowExit");
          })
      }
    }
  }
}