@import Foundation;

#define NSBase32StringEncoding  0x4D467E32

NS_ASSUME_NONNULL_BEGIN

@interface Base32Encoder : NSObject

+ (NSData *)dataFromBase32String:(NSString *)base32String;

+ (NSString *)base32StringFromData:(NSData *)data;

#pragma mark - NSSData

+ (NSData *)dataWithBase32String:(NSString *)base32String;

+ (NSString *)base32StringWithData:(NSData*)data;


#pragma mark - NSString

+ (NSString *)stringFromBase32String:(NSString *)base32String;

+ (NSString *)base32StringWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
