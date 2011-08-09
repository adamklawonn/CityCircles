//
//  WebView.m
//  poliverse
//
//  Created by reynolds on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyWebView.h"


@implementation MyWebView

@synthesize thiswebView;
@synthesize indicatorView;
@synthesize URL;
@synthesize dataString;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	if ([self.URL length] > 0){
		self.thiswebView.scalesPageToFit = YES;
		NSURL *url = [NSURL URLWithString:self.URL];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[self.thiswebView loadRequest:requestObj];
	}
	else {
		[self.thiswebView loadHTMLString: self.dataString baseURL: [NSURL URLWithString: @""]];
	}

    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(id) initWithMyUrl: (NSString *) aURL{
	if (self = [super init])
    {
		self.URL = aURL;
    }
    return self;
	
}

-(id) initWithString: (NSString *) sString{
	if (self = [super init])
    {
		self.dataString = sString;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)webViewDidStartLoad: (UIWebView *)webView{
	
	[indicatorView startAnimating];
	
}
- (void)webViewDidFinishLoad: (UIWebView *)webView{
	
	[indicatorView stopAnimating];	

}
- (void)webView: (UIWebView *)webView didFailLoadWithError:(NSError *)error{
}


- (void)dealloc {
	[URL release];
	[dataString release];
	[thiswebView release];
	[indicatorView release];
    [super dealloc];
}


@end
