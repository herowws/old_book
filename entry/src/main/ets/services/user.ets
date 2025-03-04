import { UserModel } from '../common/model/user';
import { sp } from '../common/utils/preferences';
import { JSON } from '@kit.ArkTS';


class UserService {
  private _profile: UserModel = new UserModel();
  private _token: string = '';

  constructor() {
    this._token = sp.get('token') as string;
    this._profile = sp.get('profile') as UserModel;
  }

  get isLogin() {
    return this._token.length != 0;
  }

  get token() {
    return this._token;
  }

  set token(val: string) {
    this._token = val;
  }

  get profile() {
    return this._profile;
  }

  set profile(val: UserModel) {
    this._profile = val;
    sp.put('profile', JSON.stringify(val));
  }
}

export const userService = new UserService()
