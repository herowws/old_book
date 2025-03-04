import { UserModel } from '../common/model/user';
import { http } from '../common/utils/http';

export class UserAPI {
  static async signIn(mobile: string, smsCode: string): Promise<UserModel | null> {
    const result = await http.post({
      'url': '/api/v1/user/signIn',
      loading: true,
      data: {
        'type': 0,
        'region': '+86',
        'mobile': mobile,
        'smsCode': smsCode,
      }
    });
    const data = result?.data as UserModel;
    if (result?.code != 0 || data == null) {
      return null;
    }
    return data;
  }
}