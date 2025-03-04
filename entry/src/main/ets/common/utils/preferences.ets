import { preferences, ValueType } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

class PreferencesUtil {
  preferences?: preferences.Preferences;

  getPreferencesInstance(context: Context) {
    this.preferences = preferences.getPreferencesSync(context, { name: 'app' })
    console.log('');
  }

  put(key: string, value: ValueType) {
    this.preferences?.putSync(key, value);
    this.preferences?.flush((err: BusinessError) => {
      if (err) {
        hilog.error(0x0000, 'SP___', '本地token存储刷新失败')
      }
      hilog.error(0x0000, 'SP___', '本地token存储刷新成功')
    })
  }

  get(key: string): ValueType {
    let value = this.preferences?.getSync(key, '') as string;
    return value;
  }
}

export const sp = new PreferencesUtil()
