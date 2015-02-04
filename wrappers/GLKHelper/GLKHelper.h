#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLKHelper : NSObject
{
}
+(float*)GLKVector4ToArray:(GLKVector4*)vec;
+(float*)GLKVector3ToArray:(GLKVector3*)vec;
@end
