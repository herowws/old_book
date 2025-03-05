import { LitheRefresh, RefreshController } from '@abner/lithe_refresh';
import { PostsAPI } from '../../apis/posts';
import { PostsModel } from '../../common/model/posts';
import { ThemeData, ThemeManager } from '../../common/theme/theme_manager';
import { Tools } from '../../common/utils/tools';
import { HomeController } from './controller';

@Entry
@Component
export struct HomePage {
  scroller: Scroller = new Scroller();
  dataSource: HomeController = new HomeController();
  controller: RefreshController = new RefreshController()
  @StorageProp(ThemeManager.themeKey) theme: ThemeData = {} as ThemeData

  @Builder
  itemLayout(_this: HomePage) {
    WaterFlowView({
      scroller: _this.scroller
    })
  }

  build() {
    Column() {
      LitheRefresh({
        scroller: this.scroller,
        controller: this.controller,
        itemLayout: () => {
          this.itemLayout(this)
        },
        onRefresh: () => {
          //下拉刷新
          setTimeout(() => {
            this.controller.finishRefresh()
          }, 2000)
        },
        onLoadMore: () => {
          //上拉加载
          setTimeout(() => {
            this.controller.finishLoadMore()
          }, 2000)
        }
      })
    }.backgroundColor(this.theme.secondColor)
  }
}


@Component
struct WaterFlowView {
  scroller: Scroller = new Scroller()
  dataSource: WaterFlowDataSource = new WaterFlowDataSource()

  build() {
    WaterFlow({ scroller: this.scroller }) {
      LazyForEach(this.dataSource, (item: PostsModel) => {
        FlowItem() {
          Column() {
            Image(Tools.cover(item.images))
              .borderRadius({ topLeft: 5, topRight: 5 })

            Column() {
              Flex() {
                Text(item.title)
                  .textAlign(TextAlign.Start).padding({ top: 5, bottom: 5 })
              }.backgroundColor(Color.Red)

              Flex() {
                Image(item.avatar)
                  .borderRadius(99)
                  .width(20)
                  .height(20)
                Text(item.nickname)
                Blank()
                Text('赞')
              }.backgroundColor(Color.Yellow)
            }.padding({ left: 5, right: 5 })

          }.alignItems(HorizontalAlign.Start)
        }
      }, (item: string) => item)
    }
    .columnsTemplate("1fr 1fr")
    .columnsGap(10)
    //.rowsGap(20)
    .width('100%')
    .height('100%')
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.PARENT_FIRST
    })
  }
}

// 实现IDataSource接口的对象，用于瀑布流组件加载数据
export class WaterFlowDataSource implements IDataSource {
  private list: Array<PostsModel> = [];
  private listeners: DataChangeListener[] = []

  constructor() {
    this.fetchList();
  }

  async fetchList() {
    this.list = await PostsAPI.postsList(1, 10, 0);
    this.notifyDataReload()
  }

  // 通知控制器数据重新加载
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  // 获取索引对应的数据
  public getData(index: number): PostsModel {
    return this.list[index]
  }


  // 获取数据总数
  public totalCount(): number {
    return this.list.length
  }

  // 注册改变数据的控制器
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  // 注销改变数据的控制器
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }
}