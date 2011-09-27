// coded by theiostream
// Google fix by @fr0st -- code taken from iAndroid.

#import <UIKit/UIKit.h>
#import "libactivator/libactivator.h"

static UITextField *searchField = nil;

@interface Search : NSObject <LAListener> {}
@end

@interface UIApplication (theiostream)
- (void)applicationOpenURL:(id)url;
@end

@implementation Search


- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
	UIAlertView *searchAlert = [[UIAlertView alloc] initWithTitle:@"QuickGoogle!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Google" ,nil];
    searchAlert.tag = 1999;
	[searchAlert addTextFieldWithValue:@"" label:nil];
    
    searchField = [searchAlert textFieldAtIndex:0];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
	// searchField.keyboardType = UIKeyboardTypeURL; // @fr0st did this; epicfail.
	searchField.keyboardAppearance = UIKeyboardAppearanceAlert;
	searchField.autocorrectionType = UITextAutocorrectionTypeNo;
	searchField.secureTextEntry = NO;

    [searchAlert show];
    
    [searchAlert release];

	[event setHandled:YES];
}

- (void)dealloc {
	searchField = nil;
	[super dealloc];
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please provide a search term or url." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	BOOL releaseStuff = NO;
	NSString *str = nil;
	
	if ([alert tag]==1999) {
    	if (buttonIndex == 1) {
        	
        	if ([searchField.text isEqualToString:@""]) {
            	[errorAlert show];
            	[errorAlert release];
            	return;
            }
        	
        	// stolen from SpotURL by FilippoBiga!
            NSArray *keys = [[NSArray alloc] initWithObjects:@"http://",@"www.",@".com",@".net",@".org",@".us",@".me",@".it",@".uk",@".de",nil];
        	for (NSString *k in keys) {
        		NSRange range = [searchField.text rangeOfString:k];
        		if (range.location != NSNotFound) {
        			
        			if ([searchField.text hasPrefix:@"http://"]) str = searchField.text;
        			else str = [NSString stringWithFormat:@"http://%@", searchField.text];
        			
        			[[UIApplication sharedApplication] applicationOpenURL:[NSURL URLWithString:str]];
        			releaseStuff = YES;
        		}
        	}
        	// =====
        	
        	if (releaseStuff) {
        		str = nil;
        		[keys release];
        		releaseStuff = NO;
        		return;
        	}
        	
        	NSString *query = [searchField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/search?q=%@&ie=utf-8&oe=utf-8", query]];
			
			[[UIApplication sharedApplication] applicationOpenURL:url];
            
        }
    }
}
        

+ (void)load
{
  [[LAActivator sharedInstance] registerListener:[self new] forName:@"am.theiostre.quickgoogle"];
}

@end