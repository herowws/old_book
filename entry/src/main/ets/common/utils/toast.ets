import { common } from '@kit.AbilityKit';
import { promptAction, window } from '@kit.ArkUI';

export class ToastsConfig {
  //------------------------------------公共参数---promptAction.BaseDialogOptions----------------------------------------
  uiAbilityContext?: common.UIAbilityContext; //设置UIAbilityContext
  backCancel: boolean = true; //点击返回键或手势返回时，是否关闭弹窗；实现onWillDismiss函数时，该参数不起作用。true表示关闭弹窗。false表示不关闭弹窗。默认值：true。
  autoCancel: boolean = true; //点击遮障层时，是否关闭弹窗，true表示关闭弹窗。false表示不关闭弹窗。默认值：true
  alignment: DialogAlignment = DialogAlignment.Default; //弹窗的对齐方式。
  offset: Offset = { dx: 0, dy: 0 }; //弹窗相对alignment所在位置的偏移量。默认值：{ dx: 0, dy: 0 }
  maskRect: Rectangle = {
    x: 0,
    y: 0,
    width: '100%',
    height: '100%'
  }; //弹窗遮蔽层区域，在遮蔽层区域内的事件不透传，在遮蔽层区域外的事件透传。
  maskColor: ResourceColor = 0x33000000; //自定义蒙层颜色。默认值 0x33000000
  isModal: boolean = true; //弹窗是否为模态窗口，模态窗口有蒙层，非模态窗口无蒙层。默认值：true，此时弹窗有蒙层。
  showInSubWindow: boolean = false; //某弹框需要显示在主窗口之外时，是否在子窗口显示此弹窗。
  transition?: TransitionEffect; //设置弹窗显示和退出的过渡效果。
  onWillDismiss?: Callback<DismissDialogAction>; //交互式关闭回调函数。
  onDidDisappear?: VoidCallback; //弹窗消失时的事件回调。
  //-----------------------------------公共参数---promptAction.BaseDialogOptions-----------------------------------------}
}

export class Toasts {
  private static config: ToastsConfig = new ToastsConfig(); //默认样式
  private static mainUIContext: UIContext | undefined; //MainWindow的UIContext


  /**
   * 设置默认统一样式
   * @param configs
   */
  static setDefaultConfig(configs: (config: ToastsConfig) => void): void {
    configs(Toasts.config);
  }


  /**
   * 获取MainWindow的UIContext
   * @returns
   */
  static getMainUIContext(): UIContext | undefined {
    if (Toasts.mainUIContext) {
      return Toasts.mainUIContext;
    }
    return Toasts.config?.uiAbilityContext?.windowStage?.getMainWindowSync()?.getUIContext();
  }

  /**
   * 显示吐司
   * @param message 吐司内容
   * @param options
   */
  static showToast(message: string | Resource, options?: ToastOptions) {
    options = options ?? {};
    options.message = message;
    options.uiContext = options.uiContext ?? Toasts.getMainUIContext();

    const showToastOptions: promptAction.ShowToastOptions = {
      message: options.message ?? "",
      duration: options.duration, //默认值1500ms，取值区间：1500ms-10000ms。若小于1500ms则取默认值，若大于10000ms则取上限值10000ms。
      textColor: options.fontColor ?? Color.Black, // 文本提示框文本颜色。默认值：Color.Black
      bottom: options.bottom ?? "80vp", //设置弹窗底部边框距离导航条的高度。默认值：80vp。
      alignment: options.alignment, //对齐方式。默认值：undefined，默认底部偏上位置。
      offset: options.offset ??
        { dx: 0, dy: 0 }, //在对齐方式上的偏移。默认值：{ dx: 0, dy: 0 }，默认没有偏移。说明： 只支持设置px类型的数值，如需设置vp，可以将vp改成px传入。
      backgroundColor: options.backgroundColor, //文本提示框背板颜色，建议八位色值前两位为透明度。默认值：Color.Transparent。
      backgroundBlurStyle: options.backgroundBlurStyle ??
      BlurStyle.COMPONENT_ULTRA_THICK, //文本提示框背板模糊材质。默认值：BlurStyle.COMPONENT_ULTRA_THICK。
      shadow: options.shadow ?? ShadowStyle.OUTER_DEFAULT_MD, //文本提示框背板阴影。默认值：ShadowStyle.OUTER_DEFAULT_MD
      showMode: options.showMode, //设置弹窗是否显示在应用之上。默认值：ToastShowMode.DEFAULT，默认显示在应用内。
    }
    if (options.uiContext) {
      options.uiContext.getPromptAction().showToast(showToastOptions);
    } else {
      window.getLastWindow(getContext()).then((result: window.Window) => {
        result.getUIContext().getPromptAction().showToast(showToastOptions);
      })
    }
  }
}

export interface ToastOptions {

  uiContext?: UIContext; //UIContext上下文

  message?: string | Resource; //显示的文本信息。默认字体为'Harmony Sans'，不支持设置其他字体。
  duration?: number //默认值1500ms，取值区间：1500ms-10000ms。若小于1500ms则取默认值，若大于10000ms则取上限值10000ms。
  fontColor?: ResourceColor; // 文本提示框文本颜色。默认值：Color.Black
  bottom?: string | number; //设置弹窗底部边框距离导航条的高度，ToastShowMode.TOP_MOST模式下，软键盘拉起时，如果bottom值过小，toast要被软键盘遮挡时，会自动避让至距离软键盘80vp处。ToastShowMode.DEFAULT模式下，软键盘拉起时，会上移软键盘的高度。默认值：80vp。说明：当底部没有导航条时，bottom为设置弹窗底部边框距离窗口底部的高度。设置对齐方式alignment后，bottom不生效。
  alignment?: Alignment; //对齐方式。默认值：undefined，默认底部偏上位置。
  offset?: Offset; //在对齐方式上的偏移。默认值：{ dx: 0, dy: 0 }，默认没有偏移。说明： 只支持设置px类型的数值，如需设置vp，可以将vp改成px传入。
  backgroundColor?: ResourceColor; //文本提示框背板颜色，建议八位色值前两位为透明度。默认值：Color.Transparent。说明：当设置了backgroundColor为非透明色时，backgroundBlurStyle需要设置为BlurStyle.NONE，否则颜色显示将不符合预期效果。
  backgroundBlurStyle?: BlurStyle; //文本提示框背板模糊材质。默认值：BlurStyle.COMPONENT_ULTRA_THICK。说明：设置为BlurStyle.NONE即可关闭背景虚化。当设置了backgroundBlurStyle为非NONE值时，则不要设置backgroundColor，否则颜色显示将不符合预期效果。
  shadow?: ShadowOptions | ShadowStyle; //文本提示框背板阴影。默认值：ShadowStyle.OUTER_DEFAULT_MD
  showMode?: promptAction.ToastShowMode; //设置弹窗是否显示在应用之上。默认值：ToastShowMode.DEFAULT，默认显示在应用内。

}