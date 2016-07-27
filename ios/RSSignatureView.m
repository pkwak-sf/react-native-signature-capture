#import "RSSignatureView.h"
#import "RCTConvert.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PPSSignatureView.h"
#import "RSSignatureViewManager.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@implementation RSSignatureView {
	BOOL _loaded;
	EAGLContext *_context;
	UIButton *saveButton;
	UIButton *clearButton;
	UILabel *titleLabel;
	BOOL _rotateClockwise;
	BOOL _square;
}

@synthesize sign;
@synthesize manager;

- (instancetype)init
{
	if ((self = [super init])) {
	}
	
	return self;
}

- (void) didRotate:(NSNotification *)notification {
	int ori=1;
	UIDeviceOrientation currOri = [[UIDevice currentDevice] orientation];
	if ((currOri == UIDeviceOrientationLandscapeLeft) || (currOri == UIDeviceOrientationLandscapeRight)) {
		ori=0;
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	if (!_loaded) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:)
																								 name:UIDeviceOrientationDidChangeNotification object:nil];
		
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		
		CGSize screen = self.bounds.size;
		
		sign = [[PPSSignatureView alloc]
						initWithFrame: CGRectMake(0, 0, screen.width, screen.height)
						context: _context];
        
        [sign setManager:self.manager];
		
        [self addSubview:sign];
	}
	_loaded = true;
}

- (void)setRotateClockwise:(BOOL)rotateClockwise {
	_rotateClockwise = rotateClockwise;
}

- (void)setSquare:(BOOL)square {
	_square = square;
}

-(void) onSaveButtonPressed {
	saveButton.hidden = YES;
	clearButton.hidden = YES;
	UIImage *signImage = [self.sign signatureImage: _rotateClockwise withSquare:_square];
	
	saveButton.hidden = NO;
	clearButton.hidden = NO;
	
	NSError *error;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths firstObject];
	NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/signature.png"];
	
	//remove if file already exists
	if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
		[[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
		if (error) {
			NSLog(@"Error: %@", error.debugDescription);
		}
	}
	
	// Convert UIImage object into NSData (a wrapper for a stream of bytes) formatted according to PNG spec
	NSData *imageData = UIImagePNGRepresentation(signImage);
	BOOL isSuccess = [imageData writeToFile:tempPath atomically:YES];
	if (isSuccess) {
		NSFileManager *man = [NSFileManager defaultManager];
		NSDictionary *attrs = [man attributesOfItemAtPath:tempPath error: NULL];
		//UInt32 result = [attrs fileSize];
		
		NSString *base64Encoded = [imageData base64EncodedStringWithOptions:0];
		[self.manager saveImage: tempPath withEncoded:base64Encoded];
	}
}

-(void) onClearButtonPressed {
	[self.sign erase];
}

@end
