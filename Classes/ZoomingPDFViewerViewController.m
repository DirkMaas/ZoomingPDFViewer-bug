//    File: ZoomingPDFViewerViewController.m
//Abstract: ViewController whose view is a PDFScrollView.
// Version: 1.0
//
//Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
//Inc. ("Apple") in consideration of your agreement to the following
//terms, and your use, installation, modification or redistribution of
//this Apple software constitutes acceptance of these terms.  If you do
//not agree with these terms, please do not use, install, modify or
//redistribute this Apple software.
//
//In consideration of your agreement to abide by the following terms, and
//subject to these terms, Apple grants you a personal, non-exclusive
//license, under Apple's copyrights in this original Apple software (the
//"Apple Software"), to use, reproduce, modify and redistribute the Apple
//Software, with or without modifications, in source and/or binary forms;
//provided that if you redistribute the Apple Software in its entirety and
//without modifications, you must retain this notice and the following
//text and disclaimers in all such redistributions of the Apple Software.
//Neither the name, trademarks, service marks or logos of Apple Inc. may
//be used to endorse or promote products derived from the Apple Software
//without specific prior written permission from Apple.  Except as
//expressly stated in this notice, no other rights or licenses, express or
//implied, are granted by Apple herein, including but not limited to any
//patent rights that may be infringed by your derivative works or by other
//works in which the Apple Software may be incorporated.
//
//The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
//MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
//THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
//FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
//OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//
//IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
//OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
//MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
//AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
//STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
//POSSIBILITY OF SUCH DAMAGE.
//
//Copyright (C) 2010 Apple Inc. All Rights Reserved.
//

#import "ZoomingPDFViewerViewController.h"
#import "PDFScrollView.h"

@implementation ZoomingPDFViewerViewController
@synthesize scrollView;


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	// Create our PDFScrollView and add it to the view controller.
	scrollView = [[PDFScrollView alloc] initWithFrame:[[self view] bounds]];

	
    [[self view] addSubview:scrollView];
}


- (void)viewDidLoad
{
// a work-around, otherwise the view does not scroll until it is zoomed
	[self.scrollView setZoomScale:1.0 animated:NO];
/*
The bug appears when contentOffset is between roughly 2700 and 5900 when the screen is tapped.  (Tapping causes the
zoomScale to be set to 0.5.)
To put the initial contentOffset at a spot where the bug appears, set it to 4000.
To put the initial contentOffset at a spot where the bug does NOT appear, set it to 0.
*/
	const float offset(4000);
	self.scrollView.contentOffset = CGPointMake(0.0, offset);
	UIGestureRecognizer *recognizer;
	recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
	[scrollView addGestureRecognizer:recognizer];
	recognizer.delaysTouchesBegan = YES;
	[recognizer release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Responding to gestures

- (void)handleTapFrom:(UIPinchGestureRecognizer *)recognizer 
{
	[self zoomOut];
}


-(void)zoomOut
{
	NSLog(@"zoomOut begin offset.y=%f", self.scrollView.contentOffset.y);
	self.scrollView.bounces=NO;
// The following line works correctly no matter the contentOffset, but I can't use it because I need
// to chain animations.
//	[self.scrollView setZoomScale:0.5 animated:YES];


/*************************************
This is where the bug appears
**************************************/
    [UIView animateWithDuration:4.0
        animations:^
		{
			self.scrollView.zoomScale = 0.5;
		}
        completion:^(BOOL finished)
		{
			NSLog(@"zoomOut end offset.y=%f", self.scrollView.contentOffset.y);
//			[self.scrollView scrollViewDidEndZoomingOut:TRUE];
		}
	];

}

@end
