//
//  TBTextureGlitchPlugIn.m
//  glitch
//
//  Created by Tom Butterworth on 04/09/2010.
//

#import <OpenGL/CGLMacro.h>

#import "TBGLPBOGlitchPlugIn.h"

#define	kQCPlugIn_Name				@"GL PBO Glitch / bangnoise"
#define	kQCPlugIn_Description		@"Misrepresents image data to produce glitch.\n\nPass in 0 for Unpack Width and/or Unpack Height to use the dimension(s) of the input image. Illegal combinations of Format and Type will honour Format and ignore Type.\nIf Unpack Width, Height and Offset overrun the available data, output will be cropped.\nConsult http://www.opengl.org/sdk/docs/man/xhtml/glTexImage2D.xml\nBy Tom Butterworth (bangnoise) 2010"

static void TBRowLengthTextureRelease(CGLContextObj cgl_ctx, GLuint name, void* context)
{
	glDeleteTextures(1, &name);
}

@implementation TBGLPBOGlitchPlugIn

@dynamic inputImage, inputPackFormat, inputPackType, inputUnpackOffset, inputUnpackWidth, inputUnpackHeight, inputUnpackFormat, inputUnpackType, outputImage;

+ (GLenum)formatAtIndex:(NSUInteger)index
{
	GLenum formats[13] = {GL_RED, GL_GREEN, GL_BLUE, GL_ALPHA, GL_RGB, GL_BGR, GL_RGBA, GL_BGRA, GL_ABGR_EXT, GL_LUMINANCE,
		GL_LUMINANCE_ALPHA, GL_YCBCR_422_APPLE, GL_RGB_422_APPLE};
	if (index < 13) return formats[index];
	else return 0;
}

+ (GLenum)internalFormatAtIndex:(NSUInteger)index
{
	GLenum internals[13] = {GL_RGB, GL_RGB, GL_RGB, GL_RGBA, GL_RGB, GL_RGB, GL_RGBA, GL_RGBA, GL_RGBA, GL_LUMINANCE, GL_LUMINANCE_ALPHA, GL_RGB, GL_RGB};
	if (index < 13) return internals[index];
	else return 0;
}

+ (GLenum)typeForRequestedType:(GLenum)requested format:(GLenum)format
{
	switch (requested) {
		case GL_UNSIGNED_BYTE:
			switch (format) {
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_UNSIGNED_BYTE;
					break;
			}
			break;
		case GL_BYTE:
			switch (format) {
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_BYTE;
					break;
			}
			break;
		case GL_UNSIGNED_SHORT:
			switch (format) {
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_UNSIGNED_SHORT;
					break;
			}
			break;
		case GL_SHORT:
			switch (format) {
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_SHORT;
					break;
			}
			break;
		case GL_HALF_FLOAT:
			switch (format) {
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_HALF_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_INT:
			switch (format) {
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_UNSIGNED_INT;
					break;
			}	
			break;
		case GL_INT:
			switch (format) {
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_INT;
					break;
			}
			break;
		case GL_FLOAT:
			switch (format) {
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_BYTE_3_3_2:
			switch (format) {
				case GL_RGB:
					return GL_UNSIGNED_BYTE_3_3_2;
					break;
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_BYTE_2_3_3_REV:
			switch (format) {
				case GL_RGB:
					return GL_UNSIGNED_BYTE_2_3_3_REV;
					break;
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_SHORT_5_6_5:
			switch (format) {
				case GL_RGB:
					return GL_UNSIGNED_SHORT_5_6_5;
					break;
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_SHORT_5_6_5_REV:
			switch (format) {
				case GL_RGB:
					return GL_UNSIGNED_SHORT_5_6_5_REV;
					break;
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_SHORT_4_4_4_4:
			switch (format) {
				case GL_RGBA:
				case GL_BGRA:
					return GL_UNSIGNED_SHORT_4_4_4_4;
					break;
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_SHORT_4_4_4_4_REV:
			switch (format) {
				case GL_RGBA:
				case GL_BGRA:
					return GL_UNSIGNED_SHORT_4_4_4_4_REV;
					break;
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_SHORT_5_5_5_1:
			switch (format) {
				case GL_RGBA:
				case GL_BGRA:
					return GL_UNSIGNED_SHORT_5_5_5_1;
					break;
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_SHORT_1_5_5_5_REV:
			switch (format) {
				case GL_RGBA:
				case GL_BGRA:
					return GL_UNSIGNED_SHORT_1_5_5_5_REV;
					break;
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_INT_8_8_8_8:
			switch (format) {
				case GL_RGBA:
				case GL_BGRA:
					return GL_UNSIGNED_INT_8_8_8_8;
					break;
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_INT_8_8_8_8_REV:
			switch (format) {
				case GL_RGBA:
				case GL_BGRA:
					return GL_UNSIGNED_INT_8_8_8_8_REV;
					break;
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_INT_10_10_10_2:
			switch (format) {
				case GL_RGBA:
				case GL_BGRA:
					return GL_UNSIGNED_INT_10_10_10_2;
					break;
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_INT_2_10_10_10_REV:
			switch (format) {
				case GL_RGBA:
				case GL_BGRA:
					return GL_UNSIGNED_INT_2_10_10_10_REV;
					break;
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		case GL_UNSIGNED_SHORT_8_8_APPLE:
			switch (format) {
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
		case GL_UNSIGNED_SHORT_8_8_REV_APPLE:
			switch (format) {
				case GL_YCBCR_422_APPLE:
				case GL_RGB_422_APPLE:
					return GL_UNSIGNED_SHORT_8_8_REV_APPLE;
					break;
				default:
					return GL_FLOAT;
					break;
			}
			break;
		default:
			return GL_UNSIGNED_BYTE;
			break;
	}	
}

+ (GLenum)typeAtIndex:(NSUInteger)index forFormat:(GLenum)format
{
	GLenum types[22] = {GL_UNSIGNED_BYTE, GL_BYTE, GL_UNSIGNED_SHORT, GL_SHORT, GL_HALF_FLOAT,
		GL_UNSIGNED_INT, GL_INT, GL_FLOAT, GL_UNSIGNED_BYTE_3_3_2, GL_UNSIGNED_BYTE_2_3_3_REV,
		GL_UNSIGNED_SHORT_5_6_5, GL_UNSIGNED_SHORT_5_6_5_REV, GL_UNSIGNED_SHORT_4_4_4_4,
		GL_UNSIGNED_SHORT_4_4_4_4_REV, GL_UNSIGNED_SHORT_5_5_5_1, GL_UNSIGNED_SHORT_1_5_5_5_REV,
		GL_UNSIGNED_INT_8_8_8_8, GL_UNSIGNED_INT_8_8_8_8_REV, GL_UNSIGNED_INT_10_10_10_2,
		GL_UNSIGNED_INT_2_10_10_10_REV, GL_UNSIGNED_SHORT_8_8_APPLE, GL_UNSIGNED_SHORT_8_8_REV_APPLE};
	GLenum requested;
	if (index < 22) requested = types[index];
	else requested = GL_UNSIGNED_BYTE;
	return [self typeForRequestedType:requested format:format];
}
			
+ (NSUInteger)bytesPerComponentForType:(GLenum)type
{
	switch (type) {
		case GL_UNSIGNED_BYTE:
		case GL_BYTE:
		case GL_UNSIGNED_BYTE_3_3_2:
		case GL_UNSIGNED_BYTE_2_3_3_REV:
			return 1U;
			break;
		case GL_UNSIGNED_SHORT:
		case GL_SHORT:
		case GL_HALF_FLOAT:
		case GL_UNSIGNED_SHORT_5_6_5:
		case GL_UNSIGNED_SHORT_5_6_5_REV:
		case GL_UNSIGNED_SHORT_4_4_4_4:
		case GL_UNSIGNED_SHORT_4_4_4_4_REV:
		case GL_UNSIGNED_SHORT_5_5_5_1:
		case GL_UNSIGNED_SHORT_1_5_5_5_REV:
			return 2U;
			break;
		case GL_UNSIGNED_SHORT_8_8_APPLE:
		case GL_UNSIGNED_SHORT_8_8_REV_APPLE:
			return 2U;
			break;
		default:
			return 4U;
			break;
	}
}

+ (NSUInteger)bytesPerPixelForFormat:(GLenum)format type:(GLenum)type
{	
	switch (format) {
		case GL_RED:
		case GL_GREEN:
		case GL_BLUE:
		case GL_ALPHA:
		case GL_LUMINANCE:
			switch (type) {
				case GL_UNSIGNED_BYTE:
				case GL_BYTE:
					return 1U;
					break;
				case GL_UNSIGNED_SHORT:
				case GL_SHORT:
				case GL_HALF_FLOAT:
					return 2U;
				default:
					return 4U;
					break;
			}
			break;
		case GL_LUMINANCE_ALPHA:
			switch (type) {
				case GL_UNSIGNED_BYTE:
				case GL_BYTE:
					return 2U;
					break;
				case GL_UNSIGNED_SHORT:
				case GL_SHORT:
				case GL_HALF_FLOAT:
					return 4U;
				default:
					return 8U;
					break;
			}
			break;
		case GL_RGB:
		case GL_BGR:
			switch (type) {
				case GL_UNSIGNED_BYTE_3_3_2:
				case GL_UNSIGNED_BYTE_2_3_3_REV:
					return 1U;
					break;
				case GL_UNSIGNED_SHORT_5_6_5:
				case GL_UNSIGNED_SHORT_5_6_5_REV:
					return 2U;
					break;
				case GL_UNSIGNED_BYTE:
				case GL_BYTE:
					return 3U;
					break;
				case GL_UNSIGNED_SHORT:
				case GL_SHORT:
				case GL_HALF_FLOAT:
					return 6U;
				default:
					return 12U;
					break;
			}
			break;
		case GL_RGBA:
		case GL_BGRA:
		case GL_ABGR_EXT:
			switch (type) {
				case GL_UNSIGNED_SHORT_4_4_4_4:
				case GL_UNSIGNED_SHORT_4_4_4_4_REV:
				case GL_UNSIGNED_SHORT_5_5_5_1:
				case GL_UNSIGNED_SHORT_1_5_5_5_REV:
					return 2U;
				case GL_UNSIGNED_BYTE:
				case GL_BYTE:
				case GL_UNSIGNED_INT_8_8_8_8:
				case GL_UNSIGNED_INT_8_8_8_8_REV:
				case GL_UNSIGNED_INT_10_10_10_2:
				case GL_UNSIGNED_INT_2_10_10_10_REV:
					return 4U;
					break;
				case GL_UNSIGNED_SHORT:
				case GL_SHORT:
				case GL_HALF_FLOAT:
					return 8U;
				default:
					return 16U;
					break;
			}
			break;
		case GL_YCBCR_422_APPLE:
		case GL_RGB_422_APPLE:
			return 2U;
			break;
		default:
			return 4U;
			break;
	}
}

+ (NSArray *)formatsArray
{
	return [NSArray arrayWithObjects:@"GL_RED", @"GL_GREEN", @"GL_BLUE", @"GL_ALPHA",
			@"GL_RGB", @"GL_BGR", @"GL_RGBA", @"GL_BGRA", @"GL_ABGR_EXT", @"GL_LUMINANCE", @"GL_LUMINANCE_ALPHA",
			@"GL_YCBCR_422_APPLE", @"GL_RGB_422_APPLE", nil];
}

+ (NSArray *)typesArray
{
	return [NSArray arrayWithObjects:@"GL_UNSIGNED_BYTE", @"GL_BYTE", @"GL_UNSIGNED_SHORT", @"GL_SHORT", @"GL_HALF_FLOAT",
			@"GL_UNSIGNED_INT", @"GL_INT", @"GL_FLOAT", @"GL_UNSIGNED_BYTE_3_3_2", @"GL_UNSIGNED_BYTE_2_3_3_REV",
			@"GL_UNSIGNED_SHORT_5_6_5", @"GL_UNSIGNED_SHORT_5_6_5_REV", @"GL_UNSIGNED_SHORT_4_4_4_4",
			@"GL_UNSIGNED_SHORT_4_4_4_4_REV", @"GL_UNSIGNED_SHORT_5_5_5_1", @"GL_UNSIGNED_SHORT_1_5_5_5_REV",
			@"GL_UNSIGNED_INT_8_8_8_8", @"GL_UNSIGNED_INT_8_8_8_8_REV", @"GL_UNSIGNED_INT_10_10_10_2",
			@"GL_UNSIGNED_INT_2_10_10_10_REV", @"GL_UNSIGNED_SHORT_8_8_APPLE", @"GL_UNSIGNED_SHORT_8_8_REV_APPLE", nil];
}

+ (NSDictionary*) attributes
{
	return [NSDictionary dictionaryWithObjectsAndKeys:kQCPlugIn_Name, QCPlugInAttributeNameKey, kQCPlugIn_Description, QCPlugInAttributeDescriptionKey, nil];
}

+ (NSDictionary*) attributesForPropertyPortWithKey:(NSString*)key
{
	if ([key isEqualToString:@"inputImage"])
	{
		return [NSDictionary dictionaryWithObject:@"Image" forKey:QCPortAttributeNameKey];
	}
	else if ([key isEqualToString:@"inputPackFormat"])
	{
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Pack Format", QCPortAttributeNameKey,
				[NSNumber numberWithUnsignedInt:7U], QCPortAttributeDefaultValueKey,
				[NSNumber numberWithUnsignedInt:0U], QCPortAttributeMinimumValueKey,
				[NSNumber numberWithUnsignedInt:12U], QCPortAttributeMaximumValueKey,
				[self formatsArray], QCPortAttributeMenuItemsKey,
				nil];
	}
	else if ([key isEqualToString:@"inputPackType"])
	{
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Pack Type", QCPortAttributeNameKey,
				[NSNumber numberWithUnsignedInt:17U], QCPortAttributeDefaultValueKey,
				[NSNumber numberWithUnsignedInt:0U], QCPortAttributeMinimumValueKey,
				[NSNumber numberWithUnsignedInt:21U], QCPortAttributeMaximumValueKey,
				[self typesArray], QCPortAttributeMenuItemsKey,
				nil];
	}	
	else if ([key isEqualToString:@"inputUnpackOffset"])
	{
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Unpack Offset", QCPortAttributeNameKey,
				[NSNumber numberWithUnsignedInt:0U], QCPortAttributeDefaultValueKey,
				[NSNumber numberWithUnsignedInt:0U], QCPortAttributeMinimumValueKey,
				nil];
	}	
	else if ([key isEqualToString:@"inputUnpackWidth"])
	{
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Unpack Width", QCPortAttributeNameKey,
				[NSNumber numberWithUnsignedInt:0U], QCPortAttributeDefaultValueKey,
				[NSNumber numberWithUnsignedInt:0U], QCPortAttributeMinimumValueKey,
				nil];
	}
	else if ([key isEqualToString:@"inputUnpackHeight"])
	{
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Unpack Height", QCPortAttributeNameKey,
				[NSNumber numberWithUnsignedInt:0U], QCPortAttributeDefaultValueKey,
				[NSNumber numberWithUnsignedInt:0U], QCPortAttributeMinimumValueKey,
				nil];
	}	
	else if ([key isEqualToString:@"inputUnpackFormat"])
	{
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Unpack Format", QCPortAttributeNameKey,
				[NSNumber numberWithUnsignedInt:7U], QCPortAttributeDefaultValueKey,
				[NSNumber numberWithUnsignedInt:0U], QCPortAttributeMinimumValueKey,
				[NSNumber numberWithUnsignedInt:12U], QCPortAttributeMaximumValueKey,
				[self formatsArray], QCPortAttributeMenuItemsKey,
				nil];
	}
	else if ([key isEqualToString:@"inputUnpackType"])
	{
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Unpack Type", QCPortAttributeNameKey,
				[NSNumber numberWithUnsignedInt:17U], QCPortAttributeDefaultValueKey,
				[NSNumber numberWithUnsignedInt:0U], QCPortAttributeMinimumValueKey,
				[NSNumber numberWithUnsignedInt:21U], QCPortAttributeMaximumValueKey,
				[self typesArray], QCPortAttributeMenuItemsKey,
				nil];
	}
	else if ([key isEqualToString:@"outputImage"])
	{
		return [NSDictionary dictionaryWithObject:@"Image" forKey:QCPortAttributeNameKey];
	}
	return nil;
}

+ (NSArray *)sortedPropertyPortKeys
{
	return [NSArray arrayWithObjects:@"inputImage", @"inputPackFormat", @"inputPackType", @"inputUnpackFormat", @"inputUnpackType", @"inputUnpackWidth", @"inputUnpackHeight", @"inputUnpackOffset", @"outputImage", nil];
}

+ (QCPlugInExecutionMode) executionMode
{
	return kQCPlugInExecutionModeProcessor;
}

+ (QCPlugInTimeMode) timeMode
{
	return kQCPlugInTimeModeNone;
}

@end

@implementation TBGLPBOGlitchPlugIn (Execution)

- (BOOL) startExecution:(id<QCPlugInContext>)context
{	
	CGLContextObj cgl_ctx = [context CGLContextObj];
	
	glGetIntegerv(GL_MAX_TEXTURE_SIZE, &_maxTexSize);
	_pboSize.width = _pboSize.height = 0;
	return YES;
}

#pragma mark Execution
- (BOOL) execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{
	CGLContextObj cgl_ctx = [context CGLContextObj];
	BOOL needsOutputResize = NO;
	BOOL unpackTypeNeedsRevision = NO;
	BOOL hasPushed = NO;
	GLint prevPackBuffer = 0;
	GLint prevUnpackBuffer = 0;
#pragma mark Unpack Parameters
	if ([self didValueForInputKeyChange:@"inputUnpackOffset"])
	{
		_unpackOffset = self.inputUnpackOffset;
		needsOutputResize = YES;
	}
	if ([self didValueForInputKeyChange:@"inputUnpackWidth"])
	{
		_unpackWidth = self.inputUnpackWidth;
		needsOutputResize = YES;
	}
	if ([self didValueForInputKeyChange:@"inputUnpackHeight"])
	{
		_unpackHeight = self.inputUnpackHeight;
		needsOutputResize = YES;
	}
	if ([self didValueForInputKeyChange:@"inputUnpackFormat"])
	{
		_unpackFormat = [[self class] formatAtIndex:self.inputUnpackFormat];
		_internalFormat = [[self class] internalFormatAtIndex:self.inputUnpackFormat];
		unpackTypeNeedsRevision = YES;
		needsOutputResize = YES;
	}
	if ([self didValueForInputKeyChange:@"inputUnpackType"])
	{
		_unpackType = [[self class] typeAtIndex:self.inputUnpackType forFormat:_unpackFormat];
		needsOutputResize = YES;		
	} else if (unpackTypeNeedsRevision)
	{
		_unpackType = [[self class] typeForRequestedType:_unpackType format:_unpackFormat];
	}
#pragma mark Pack Parameters
	BOOL packingChanged = NO;
	GLenum requestedPackFormat, requestedPackType;
	NSUInteger requestedPackRowBytes;
	if ([self didValueForInputKeyChange:@"inputPackFormat"])
	{
		requestedPackFormat = [[self class] formatAtIndex:self.inputPackFormat];
		packingChanged = YES;
		needsOutputResize = YES;
	} else {
		requestedPackFormat = _packFormat;
	}

	if ([self didValueForInputKeyChange:@"inputPackType"])
	{
		requestedPackType = [[self class] typeAtIndex:self.inputPackType forFormat:requestedPackFormat];
		packingChanged = YES;
	} else if (packingChanged)
	{
		requestedPackType = [[self class] typeForRequestedType:_packType format:requestedPackFormat];
	} else
	{
		requestedPackType = _packType;
	}

	if (packingChanged)
	{
		requestedPackRowBytes = [[self class] bytesPerPixelForFormat:requestedPackFormat type:requestedPackType] * _pboSize.width;
		packingChanged = YES;
		needsOutputResize = YES;
	}
	BOOL imageInputHasChanged;
	if ([self didValueForInputKeyChange:@"inputImage"])
	{
		imageInputHasChanged = YES;
	} else {
		imageInputHasChanged = NO;
	}
	if (packingChanged && _pbo)
	{
		if (imageInputHasChanged)
		{
			if (_pbo && requestedPackRowBytes != _pboRowBytes)
			{
				if (!hasPushed) 
				{
					glPushAttrib(GL_ALL_ATTRIB_BITS);
					glPushClientAttrib(GL_CLIENT_PIXEL_STORE_BIT);
					hasPushed = YES;
				}
				if (!prevPackBuffer) glGetIntegerv(GL_PIXEL_PACK_BUFFER_BINDING, &prevPackBuffer);
				glBindBuffer(GL_PIXEL_PACK_BUFFER, _pbo);
//				NSLog(@"glBufferData %u", requestedPackRowBytes * _pboSize.height);
				glBufferData(GL_PIXEL_PACK_BUFFER, requestedPackRowBytes * _pboSize.height, NULL, GL_DYNAMIC_COPY);
				glBindBuffer(GL_PIXEL_PACK_BUFFER, prevPackBuffer);
			}
		} else {
			// We have a pbo so we must have had input before
			// and the image input hasn't changed, so we should copy our existing image data to the new format.
			// this is sometimes lossy
			if (!hasPushed) 
			{
				glPushAttrib(GL_ALL_ATTRIB_BITS);
				glPushClientAttrib(GL_CLIENT_PIXEL_STORE_BIT);
				hasPushed = YES;
			}
			GLenum copyTex;
			glGenTextures(1, &copyTex);
			glEnable(GL_TEXTURE_RECTANGLE_ARB);
			glBindTexture(GL_TEXTURE_RECTANGLE_ARB, copyTex);
			if (!prevUnpackBuffer) glGetIntegerv(GL_PIXEL_UNPACK_BUFFER_BINDING, &prevUnpackBuffer);
			glBindBuffer(GL_PIXEL_UNPACK_BUFFER, _pbo);
			// TODO: more intelligent internal format choice, probably require tracking it
			glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
			glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGBA, _pboSize.width, _pboSize.height, 0, _packFormat, _packType, 0);
			glBindBuffer(GL_PIXEL_UNPACK_BUFFER, prevUnpackBuffer);
			if (!prevPackBuffer) glGetIntegerv(GL_PIXEL_PACK_BUFFER_BINDING, &prevPackBuffer);
			glBindBuffer(GL_PIXEL_PACK_BUFFER, _pbo);
			if (requestedPackRowBytes != _pboRowBytes)
			{
//				NSLog(@"glBufferData (before copy) %u", requestedPackRowBytes);
				glBufferData(GL_PIXEL_PACK_BUFFER, requestedPackRowBytes * _pboSize.height, NULL, GL_DYNAMIC_COPY);
			}
			glPixelStorei(GL_PACK_ALIGNMENT, 1);
			glGetTexImage(GL_TEXTURE_RECTANGLE_ARB, 0, requestedPackFormat, requestedPackType, 0);
			glBindBuffer(GL_PIXEL_PACK_BUFFER, prevPackBuffer);
			glBindTexture(GL_TEXTURE_RECTANGLE_ARB, 0);
			glDeleteTextures(1, &copyTex);
		}
		_packFormat = requestedPackFormat;
		_packType = requestedPackType;
		_pboRowBytes = requestedPackRowBytes;
	} else if (packingChanged) {
		_packFormat = requestedPackFormat;
		_packType = requestedPackType;
		_pboRowBytes = requestedPackRowBytes;
	}

	if (imageInputHasChanged)
	{
		id <QCPlugInInputImageSource> image = self.inputImage;

		if ([image lockTextureRepresentationWithColorSpace:([image shouldColorMatch] ? [context colorSpace] : [image imageColorSpace])
												 forBounds:[image imageBounds]])
		{
			NSUInteger width = [image texturePixelsWide];
			NSUInteger height = [image texturePixelsHigh];
			
			if (!hasPushed) 
			{
				glPushAttrib(GL_ALL_ATTRIB_BITS);
				glPushClientAttrib(GL_CLIENT_PIXEL_STORE_BIT);
				hasPushed = YES;
			}
			
			if (_pbo == 0)
			{
				glGenBuffers(1, &_pbo);
			}
			if (_pboSize.width != width || _pboSize.height != height)
			{
				needsOutputResize = YES;
				_pboSize.width = width;
				_pboSize.height = height;
				_pboRowBytes = [[self class] bytesPerPixelForFormat:_packFormat type:_packType] * width;
//				NSLog(@"packed bpp:%u, rowbytes:%u", [[self class] bytesPerPixelForFormat:_packFormat type:_packType], _pboRowBytes);
				if (!prevPackBuffer) glGetIntegerv(GL_PIXEL_PACK_BUFFER_BINDING, &prevPackBuffer);
				glBindBuffer(GL_PIXEL_PACK_BUFFER, _pbo);
//				NSLog(@"glBufferData (in image resize) %u", _pboRowBytes * height);
				glBufferData(GL_PIXEL_PACK_BUFFER, _pboRowBytes * height, NULL, GL_DYNAMIC_COPY);
			}
			
			glEnable([image textureTarget]);
			
			[image bindTextureRepresentationToCGLContext:cgl_ctx textureUnit:GL_TEXTURE0 normalizeCoordinates:NO];
			
			_isFlipped = [image textureFlipped];
			_shouldColorMatch = [image shouldColorMatch];
			if (!prevPackBuffer) glGetIntegerv(GL_PIXEL_PACK_BUFFER_BINDING, &prevPackBuffer);
			glBindBuffer(GL_PIXEL_PACK_BUFFER, _pbo);
			glPixelStorei(GL_PACK_ALIGNMENT, 1);
			glGetTexImage([image textureTarget], 0, _packFormat, _packType, 0);
			glBindBuffer(GL_PIXEL_PACK_BUFFER, prevPackBuffer);
			[image unbindTextureRepresentationFromCGLContext:cgl_ctx textureUnit:GL_TEXTURE0];
			[image unlockTextureRepresentation];
		} else {
			if (_pbo)
			{
				glDeleteBuffers(1, &_pbo);
				_pbo = 0;
			}
		}

	}
	if (needsOutputResize && _pbo && _pboRowBytes)
	{
		NSUInteger validPBOSize = _pboRowBytes * _pboSize.height;
		//			NSLog(@"PBO size: %u", validPBOSize);
		_outputWidth = _unpackWidth;
		
		if (_outputWidth == 0) _outputWidth = _pboSize.width;
		if (_outputWidth > _maxTexSize) _outputWidth = _maxTexSize;
		
		NSUInteger unpackPixelBytes = [[self class] bytesPerPixelForFormat:_unpackFormat type:_unpackType];
		NSUInteger unpackRowBytes = unpackPixelBytes * _outputWidth;
		//			NSLog(@"unpack bpp: %u rowBytes: %u", unpackPixelBytes, unpackRowBytes);
		if (unpackRowBytes > validPBOSize)
		{
			_outputWidth = validPBOSize / unpackPixelBytes;
			unpackRowBytes = _outputWidth * unpackPixelBytes;
		}
		_outputByteOffset = _unpackOffset * [[self class] bytesPerComponentForType:_unpackType];
		if (_outputByteOffset >= validPBOSize) _outputByteOffset = validPBOSize - unpackRowBytes;
		
		_outputHeight = _unpackHeight;
		if (_outputHeight == 0) _outputHeight = _pboSize.height;
		
		NSUInteger maxHeightInBuffer = (validPBOSize - _outputByteOffset) / unpackRowBytes;
		if (_outputHeight > maxHeightInBuffer) _outputHeight = maxHeightInBuffer;
		if (_outputHeight > _maxTexSize) _outputHeight = _maxTexSize;
		//			NSLog(@"width: %u height: %u", _outputWidth, _outputHeight);
		//			NSLog(@"start: %u end: %u", offset, offset + (unpackRowBytes * _outputHeight));
	}

	if (_pbo && _pboSize.width && _pboSize.height)
	{
		if (!hasPushed)
		{
			glPushAttrib(GL_ALL_ATTRIB_BITS);
			glPushClientAttrib(GL_CLIENT_PIXEL_STORE_BIT);
			hasPushed = YES;
		}
		GLuint tex;
		glGenTextures(1, &tex);
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, tex);
		if (!prevUnpackBuffer) glGetIntegerv(GL_PIXEL_UNPACK_BUFFER_BINDING, &prevUnpackBuffer);
		glBindBuffer(GL_PIXEL_UNPACK_BUFFER, _pbo);
		glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
		glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, _internalFormat,
					 _outputWidth, _outputHeight,
					 0, _unpackFormat, _unpackType, (void *)_outputByteOffset);
		glBindBuffer(GL_PIXEL_UNPACK_BUFFER, prevUnpackBuffer);
		self.outputImage = [context outputImageProviderFromTextureWithPixelFormat:QCPlugInPixelFormatBGRA8
																	   pixelsWide:_outputWidth
																	   pixelsHigh:_outputHeight
																			 name:tex
																		  flipped:_isFlipped
																  releaseCallback:TBRowLengthTextureRelease
																   releaseContext:NULL
																	   colorSpace:[context colorSpace]
																 shouldColorMatch:_shouldColorMatch];
	} else {
		self.outputImage = nil;
	}
	if (hasPushed)
	{
		glPopClientAttrib();
		glPopAttrib();
	}
	return YES;
}

- (void) disableExecution:(id<QCPlugInContext>)context
{
	CGLContextObj cgl_ctx = [context CGLContextObj];
	if (_pbo) glDeleteBuffers(1, &_pbo);
	_pbo = 0;
}

@end
