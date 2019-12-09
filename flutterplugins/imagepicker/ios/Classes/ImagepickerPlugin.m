#import "ImagepickerPlugin.h"
#import <imagepicker/imagepicker-Swift.h>

@implementation ImagepickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImagepickerPlugin registerWithRegistrar:registrar];
}
@end
