//
//  FoursquareWebViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/27/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "FoursquareWebViewController.h"

@interface FoursquareWebViewController () <UIWebViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIWebView *foursquareWebView;
@end

@implementation FoursquareWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestToLoadWebPage];
}

-(void)requestToLoadWebPage
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *urlString = [NSString stringWithFormat:@"http://foursquare.com/v/%@",self.location.venueID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.foursquareWebView loadRequest:request];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

- (void) webViewDidStartLoad: (UIWebView*)webView
{
    [self.spinner startAnimating];
}

- (void) webViewDidFinishLoad: (UIWebView*)webView
{

    [self.spinner stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Web View Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [av show];
}

-(void) alertView:(UIAlertView*) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Okay" delegate:self cancelButtonTitle:@"Thanks" destructiveButtonTitle:@"Thank you very much!" otherButtonTitles:nil];
        
        [sheet showInView:self.view];
    }
}


@end
