import { JSON } from '@kit.ArkTS';

export class ResponseModel {
  code?: number;
  msg?: string;
  data?: object;

  constructor(code: number, msg: string, data: object) {
    this.code = code;
    this.msg = msg;
    this.data = data;
  }

  fromJson(jsonStr: string) {
    JSON.parse(jsonStr) as ResponseModel;
  }
}


