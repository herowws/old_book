import { PostsModel } from '../common/model/posts';
import { http } from '../common/utils/http';

export class PostsAPI {
  static async postsList(page: number, size: number, type: number, userId?: string): Promise<Array<PostsModel>> {
    const result = await http.post({
      'url': '/api/v1/posts/list',
      loading: false,
      data: {
        "page": page,
        "size": size,
        "type": type,
        'userId': userId,
      },
    });
    const list = result?.data as Array<PostsModel>;
    if (list == null || list.length == 0) {
      return [];
    }
    return list;
  }
}