#import "GLKHelper.h"

@implementation GLKHelper

+(float*)GLKVector4ToArray:(GLKVector4*)vec
{
  return vec->v;
}

+(float*)GLKVector3ToArray:(GLKVector3*)vec
{
  return vec->v;
}

@end
