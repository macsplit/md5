#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Md5 : NSObject

+ (NSString*) compute: (NSData*) data;

@end

NS_ASSUME_NONNULL_END
