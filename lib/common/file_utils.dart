class FileUtils {
  static String getFileNameFromUrl(String url) {
    // 使用 Uri 类将 URL 解析为路径的一部分
    Uri uri = Uri.parse(url);
    return uri.pathSegments.last; // 获取最后一个路径片段作为文件名
  }
}
