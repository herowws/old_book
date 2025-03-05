import { LitheRefresh, RefreshController } from '@abner/lithe_refresh';
import { PostsAPI } from '../../apis/posts';
import { PostsModel } from '../../common/model/posts';
import { ThemeData, ThemeManager } from '../../common/theme/theme_manager';
import { Tools } from '../../common/utils/tools';
import { HomeController } from './controller';


@Component
struct PostsCard {
  @Prop item: PostsModel

  build() {
    Column() {
      Image(Tools.cover(this.item.images))
        .borderRadius({ topLeft: 5, topRight: 5 })
      Column() {
        Flex() {
          Text(this.item.title)
            .maxLines(2)
            .textAlign(TextAlign.Start)
            .padding({ top: 5, bottom: 5 })
        }

        Flex() {
          Image(this.item.avatar)
            .borderRadius(99)
            .width(20)
            .height(20)
            .padding({ right: 2 })
          Text(this.item.nickname)
            .fontSize(12)
            .maxLines(1)
            .fontColor('#999999')
            .height(20)
          Blank()

          SymbolGlyph($r('sys.symbol.heart'))
            .fontSize(15)
            .fontColor(['#999999'])
            .height(20)
            .padding({ left: 3, right: 3 })
          Text(`${this.item.likes ?? 0}`)
            .fontSize(12)
            .height(20)
            .fontColor('#888888')
            .maxLines(1)
        }
        .align(Alignment.Start)
      }
      .padding({
        left: 5,
        right: 5,
        top: 8,
        bottom: 8
      })

    }.alignItems(HorizontalAlign.Start)
    .backgroundColor(Color.White)
    .borderRadius(5)

  }
}

@Component
export struct HomePage {
  scroller: Scroller = new Scroller();
  dataSource: HomeController = new HomeController();
  controller: RefreshController = new RefreshController()

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
    }
  }
}


@Component
struct WaterFlowView {
  scroller: Scroller = new Scroller()
  dataSource: WaterFlowDataSource = new WaterFlowDataSource()
  @StorageProp(ThemeManager.themeKey) theme: ThemeData = {} as ThemeData

  build() {
    WaterFlow({ scroller: this.scroller }) {
      LazyForEach(this.dataSource, (item: PostsModel) => {
        FlowItem() {
          PostsCard({ item })
        }
      }, (item: string) => item)
    }
    .columnsTemplate("1fr 1fr")
    .columnsGap(7)
    .rowsGap(7)
    .padding(7)
    .width('100%')
    .height('100%')
    .backgroundColor(this.theme.secondColor)
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.PARENT_FIRST
    })
  }
}

export class WaterFlowDataSource implements IDataSource {
  private dataArray: PostsModel[] = []
  private listeners: DataChangeListener[] = []

  constructor() {
    this.fetchList();
  }

  async fetchList() {
    this.dataArray = await PostsAPI.postsList(1, 12, 0);
    this.notifyDataReload()
  }

  // 获取索引对应的数据
  public getData(index: number): PostsModel {
    return this.dataArray[index]
  }

  // 通知控制器数据重新加载
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  // 通知控制器数据增加
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  // 通知控制器数据变化
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index)
    })
  }

  // 通知控制器数据删除
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index)
    })
  }

  // 通知控制器数据位置变化
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to)
    })
  }

  //通知控制器数据批量修改
  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    })
  }

  // 获取数据总数
  public totalCount(): number {
    return this.dataArray.length
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

  // 增加数据
  public add1stItem(): void {
    //this.dataArray.splice(0, 0, this.dataArray.length)
    this.notifyDataAdd(0)
  }

  // 在数据尾部增加一个元素
  public addLastItem(): void {
    //this.dataArray.splice(this.dataArray.length, 0, this.dataArray.length)
    this.notifyDataAdd(this.dataArray.length - 1)
  }

  // 在指定索引位置增加一个元素
  public addItem(index: number): void {
    //this.dataArray.splice(index, 0, this.dataArray.length)
    this.notifyDataAdd(index)
  }

  // 删除第一个元素
  public delete1stItem(): void {
    this.dataArray.splice(0, 1)
    this.notifyDataDelete(0)
  }

  // 删除第二个元素
  public delete2ndItem(): void {
    this.dataArray.splice(1, 1)
    this.notifyDataDelete(1)
  }

  // 删除最后一个元素
  public deleteLastItem(): void {
    this.dataArray.splice(-1, 1)
    this.notifyDataDelete(this.dataArray.length)
  }

  // 在指定索引位置删除一个元素
  public deleteItem(index: number): void {
    this.dataArray.splice(index, 1)
    this.notifyDataDelete(index)
  }

  // 重新加载数据
  public reload(): void {
    this.dataArray.splice(1, 1)
    this.dataArray.splice(3, 2)
    this.notifyDataReload()
  }
}