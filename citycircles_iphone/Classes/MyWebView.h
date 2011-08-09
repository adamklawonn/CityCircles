//
//  WebView.h
//  poliverse
//
//  Created by reynolds on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyWebView : UIViewController
<UIWebViewDelegate> {
	UIWebView *thiswebView;
	UIActivityIndicatorView *indicatorView;
	NSString *URL;
	NSString *dataString;
}

-(id) initWithMyUrl: (NSString *) aURL;
-(id) initWithString: (NSString *) sString;

@property (nonatomic, retain) IBOutlet UIWebView *thiswebView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) NSString *URL;
@property (nonatomic, retain) NSString *dataString;

@end
