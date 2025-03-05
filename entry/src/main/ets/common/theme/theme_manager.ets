export class ThemeManager {
  // 主题key
  static themeKey: string = 'k_theme';
  static themeList: string = 'k_themeList';
  static themeIndex: string = 'k_themeIndex';

  init() {
    PersistentStorage.persistProp<ThemeData>(ThemeManager.themeKey, ThemeColor.PRIMARY)
    AppStorage.setOrCreate<ThemeData[]>(ThemeManager.themeList, [
      ThemeColor.PRIMARY,
      ThemeColor.RED,
      ThemeColor.YELLOW,
      ThemeColor.BLUE,
      ThemeColor.GREEN,
    ])
    // 被选中主题的索引
    PersistentStorage.persistProp<number>(ThemeManager.themeIndex, 0)
  }

  setTheme(newTheme: ThemeData, index: number) {
    AppStorage.setOrCreate<ThemeData>(ThemeManager.themeKey, newTheme)
    AppStorage.setOrCreate<number>(ThemeManager.themeIndex, index)
  }
}

// 单例模式
export const themeManager = new ThemeManager()

class ThemeColor {
  static readonly PRIMARY: ThemeData = {
    mainColor: '#EC404B',
    secondColor: '#f9faf9',
    title: "primary"
  }
  static readonly RED: ThemeData = {
    mainColor: '#ef4444', secondColor: '#fde8e8',
    title: "red"
  }
  static readonly YELLOW: ThemeData = {
    mainColor: '#ff9500', secondColor: '#fff2e0',
    title: "yellow"
  }
  static readonly BLUE: ThemeData = {
    mainColor: '#188bff', secondColor: '#e3f1ff',
    title: "blue"
  }
  static readonly GREEN: ThemeData = {
    mainColor: '#24b277', secondColor: '#e4f5ee',
    title: "green"
  }
}

export interface ThemeData {
  mainColor: string; // 主色 前景色
  secondColor: string; // 次色 背景色
  title: string // 说明
}