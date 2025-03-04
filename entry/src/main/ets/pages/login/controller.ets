import { DialogHelper } from '@pura/harmony-dialog';
import { UserAPI } from '../../apis/user';
import { userService } from '../../services/user';

export class LoginController {
  isSubmitting = false;
  pageStack?: NavPathStack;

  async onSubmit() {
    if (this.isSubmitting) {
      return;
    }
    try {
      this.isSubmitting = true;
      let result = await UserAPI.signIn('18375701380', '751380');
      if (result != null) {
        userService.profile = result;
        userService.token = result.token ?? '';
        DialogHelper.showToast('登录成功');
        this.pageStack?.clear()
      }
    } finally {
      this.isSubmitting = false;
    }
  }
}