//
//  MyUIWebView.m
//  citycircles
//
//  Created by mjamison on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyUIWebView.h"
#import "HtmlGenerator.h"


@implementation MyUIWebView

- (void) loadRequest:(NSURLRequest *)request {
	NSString *URLString = [[request URL] absoluteString];
	
	HtmlGenerator * mygenerator = [[HtmlGenerator alloc] init];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath: path];
	NSString *htmlString;
	if ([URLString rangeOfString:@"/load/"].location != NSNotFound) {
		//This is the initial loading
		htmlString = [mygenerator getHTML: 10 to_zl: 10 center_x: 160 center_y: 125 from_origin_x: -1 from_origin_y: -1];
		
		//NSData *htmlData = [NSData dataFromContent: filePath];
		//[self loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
		
		
	} else {
		NSArray *chunks = [URLString componentsSeparatedByString:@"/"];
		int from_zl = [(NSString *)[chunks objectAtIndex:0] intValue];
		int to_zl = [(NSString *)[chunks objectAtIndex:1] intValue];
		int center_x = [(NSString *)[chunks objectAtIndex:2] intValue];
		int center_y = [(NSString *)[chunks objectAtIndex:3] intValue];
		int from_origin_x = [(NSString *)[chunks objectAtIndex:0] intValue];
		int from_origin_y = [(NSString *)[chunks objectAtIndex:0] intValue];
		htmlString = [mygenerator getHTML: from_zl to_zl: to_zl center_x: center_x center_y: center_y from_origin_x: from_origin_x from_origin_y: from_origin_y];
		//[self loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
	}
	//return [super loadHTMLString: htmlString baseURL: baseURL];
	
	//NSData *htmlData = [NSData data: filePath];
	NSLog(htmlString);
	NSData *htmlData=[htmlString dataUsingEncoding:NSUTF8StringEncoding];
	//[super loadRequest:request];
	[super loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
	//[super loadRequest: request];
	//make the string something
	//[super loadHTMLString: htmlString baseURL: baseURL];
}

@end
