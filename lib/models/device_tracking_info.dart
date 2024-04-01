class DeviceTrackingInfo {
  final String branchId;
  final String sessionId;
  final String userAgent;
  final String platform;
  final String vendor;
  final String language;
  final String browser;
  final String browserVersion;
  final String os;
  final double pixelRatio;
  final int screenWidth;
  final int screenHeight;
  final String orientation;

  DeviceTrackingInfo({
    required this.branchId,
    required this.sessionId,
    required this.userAgent,
    required this.platform,
    required this.vendor,
    required this.language,
    required this.browser,
    required this.browserVersion,
    required this.os,
    required this.pixelRatio,
    required this.screenWidth,
    required this.screenHeight,
    required this.orientation,
  });

  DeviceTrackingInfo.initial()
      : branchId = "",
        sessionId = "",
        userAgent = "unknown",
        platform = "unknown",
        vendor = "unknown",
        language = "unknown",
        browser = "unknown",
        browserVersion = "unknown",
        os = "unknown",
        pixelRatio = 1.0,
        screenWidth = 0,
        screenHeight = 0,
        orientation = "unknown";

  Map<String, dynamic> toJson() => {
        "branchId": branchId,
        "sessionId": sessionId,
        "userAgent": userAgent,
        "platform": platform,
        "vendor": vendor,
        "language": language,
        "browser": browser,
        "browserVersion": browserVersion,
        "os": os,
        "pixelRatio": pixelRatio,
        "screenWidth": screenWidth,
        "screenHeight": screenHeight,
        "orientation": orientation,
      };
}
