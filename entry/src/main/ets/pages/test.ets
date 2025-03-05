@Entry
@Component
struct Test {
  @Provide bb: NavPathStack = new NavPathStack()
  @Provide aa: NavPathStack = new NavPathStack()
  @Provide cc: number = 1

  build() {
    Navigation(this.bb) {
      Text(`${this.cc++}`).fontColor(Color.Red)
    }

  }
}