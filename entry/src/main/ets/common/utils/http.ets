import { rcp } from '@kit.RemoteCommunicationKit';
import util from '@ohos.util';
import { DialogHelper } from '@pura/harmony-dialog';
import { ResponseModel } from '../model/response';

interface HttpParameter {
  url: string
  data?: rcp.RequestContent,
  loading?: boolean
}

class Http {
  base: string = 'http://192.168.110.154';

  buf2String(buf: ArrayBuffer): string {
    let msgArray = new Uint8Array(buf);
    let textDecoder = util.TextDecoder.create("utf-8");
    return textDecoder.decodeToString(msgArray)
  }

  private createSession(): rcp.Session {
    const sessionConfig: rcp.SessionConfiguration = {
      interceptors: [
        new HttpInterceptor(),
      ],
      requestConfiguration: {
        security: {
          tlsOptions: {
            tlsVersion: 'TlsV1.3'
          }
        }
      }
    };
    const session = rcp.createSession(sessionConfig);
    return session;
  }

  async get(parameter: HttpParameter) {
    try {
      const postContent: rcp.RequestContent = {
        'type': 0,
        'mobile': 18375701380,
        'smsCode': '751380',
        'region': '+86'
      }
      const session = rcp.createSession();
      const resp: rcp.Response = await session.get(parameter.url);
      const headers = resp.headers;
      const statusCode = resp.statusCode;
      const body = resp.body;
    } catch (err) {
      console.error(`Response err: Code is ${JSON.stringify(err.code)}, message is ${JSON.stringify(err)}`);
    }
  }

  async post(parameter: HttpParameter): Promise<ResponseModel | null> {
    let url = this.base;
    let id = Math.random().toString();
    if (!parameter.url.startsWith('http')) {
      url = `${url}${parameter.url}`
    } else {
      url = parameter.url;
    }
    let session: rcp.Session = this.createSession();
    try {
      if (parameter.loading) {
        DialogHelper.showLoadingDialog({ dialogId: id });
      }
      const resp: rcp.Response = await session.post(url, parameter.data);
      if (resp.statusCode != 200) {
        return null;
      }
      const bodyBuf = resp.body;
      if (bodyBuf == undefined) {
        return null;
      }
      let body = this.buf2String(bodyBuf)
      let model = JSON.parse(body) as ResponseModel;
      if (model.code != 0 && (model.msg?.length ?? 0) >= 0) {
        DialogHelper.showToast(model.msg, {
          alignment: Alignment.Center
        });
      }
      return model;
    } catch (err) {
      console.error(`Response err: Code is ${JSON.stringify(err.code)}, message is ${JSON.stringify(err)}`);
      return null;
    } finally {
      session.close();
      DialogHelper.closeDialog(id);
    }
  }
}


export const http = new Http()


export class HttpInterceptor implements rcp.Interceptor {
  async intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    let response = await next.handle(context);
    let msg = '';
    switch (response.statusCode) {
      case 500:
        msg = '您的网络不太顺畅';
        break;
      case 403:
        msg = '当前登录已失效，请重新登录';
        break;
    }
    if (msg.length > 0) {
      DialogHelper.showToast(msg, {
        alignment: Alignment.Center
      });
    }
    return response;
  }
}