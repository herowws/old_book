export class Tools {
  static cover(image: string | undefined): string {
    if (image == undefined) {
      return '';
    }
    let arr = image.split(',');
    if (arr.length == 0) {
      return '';
    }
    return arr[0];
  }
}