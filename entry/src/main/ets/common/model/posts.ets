export class PostsModel {
  id?: string;
  title?: string;
  body?: string;
  images?: string;
  imagesView?: string;
  type?: number;
  likes?: number;
  reviews?: number;
  nickname?: string;
  avatar?: string;
  topics?: string;
  createTime?: string;
  userid?: string;
  identity?: number;
  origin?: number;

  constructor(
    id?: string,
    title?: string,
    body?: string,
    images?: string,
    imagesView?: string,
    type?: number,
    likes?: number,
    reviews?: number,
    nickname?: string,
    avatar?: string,
    topics?: string,
    createTime?: string,
    userid?: string,
    identity?: number,
    origin?: number
  ) {
    this.id = id;
    this.title = title;
    this.body = body;
    this.images = images;
    this.imagesView = imagesView;
    this.type = type;
    this.likes = likes;
    this.reviews = reviews;
    this.nickname = nickname;
    this.avatar = avatar;
    this.topics = topics;
    this.createTime = createTime;
    this.userid = userid;
    this.identity = identity;
    this.origin = origin;
  }
}