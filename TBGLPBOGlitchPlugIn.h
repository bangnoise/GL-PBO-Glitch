//
//  TBTextureGlitchPlugIn.h
//  glitch
//
//  Created by Tom on 04/09/2010.
//  Copyright (c) 2010 Tom Butterworth. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface TBGLPBOGlitchPlugIn : QCPlugIn
{
	GLint _maxTexSize;
	NSSize _pboSize;
	GLuint _pbo;
	NSUInteger _pboRowBytes;
	GLenum _packFormat;
	GLenum _packType;
	NSUInteger _unpackOffset;
	NSUInteger _unpackWidth;
	NSUInteger _unpackHeight;
	NSUInteger _outputWidth;
	NSUInteger _outputHeight;
	NSUInteger _outputByteOffset;
	GLenum _unpackFormat;
	GLenum _unpackType;
	GLenum _internalFormat;
	BOOL _isFlipped;
	BOOL _shouldColorMatch;
}
@property (assign) id <QCPlugInInputImageSource> inputImage;
@property NSUInteger inputPackFormat;
@property NSUInteger inputPackType;
@property NSUInteger inputUnpackOffset;
@property NSUInteger inputUnpackWidth;
@property NSUInteger inputUnpackHeight;
@property NSUInteger inputUnpackFormat;
@property NSUInteger inputUnpackType;
@property (assign) id <QCPlugInOutputImageProvider> outputImage;
@end
