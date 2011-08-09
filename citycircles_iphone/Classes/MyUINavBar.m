//UINavigationBar+CustomImage.m    
#import "MyUINavBar.h"
//Global dictionary for recording background image
static NSMutableDictionary *navigationBarImages = NULL;

@implementation UINavigationBar(CustomImage)
//Overrider to draw a custom image

+ (void)initImageDictionary
{
    if(navigationBarImages==NULL){
        navigationBarImages=[[NSMutableDictionary alloc] init];
    }   
}

- (void)drawRect:(CGRect)rect
{
    NSString *imageName=[navigationBarImages objectForKey:[NSValue valueWithNonretainedObject: self]];
    if (imageName==nil) {
        imageName=@"header.png";
    }
    UIImage *image = [UIImage imageNamed: imageName];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

//Allow the setting of an image for the navigation bar
- (void)setImage:(UIImage*)image
{
    [navigationBarImages setObject:image forKey:[NSValue valueWithNonretainedObject: self]];
}
@end