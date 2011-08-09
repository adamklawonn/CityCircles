//UINavigationBar+CustomImage.h
#import <Foundation/Foundation.h>

@interface UINavigationBar(CustomImage)
+ (void) initImageDictionary;
- (void) drawRect:(CGRect)rect;
- (void) setImage:(UIImage*)image;
@end
