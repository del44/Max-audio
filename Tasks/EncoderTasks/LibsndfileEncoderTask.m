/*
 *  $Id$
 *
 *  Copyright (C) 2005, 2006 Stephen F. Booth <me@sbooth.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#import "LibsndfileEncoderTask.h"
#import "LibsndfileEncoder.h"

#include <sndfile/sndfile.h>

@implementation LibsndfileEncoderTask

- (id) init
{
	if((self = [super init])) {
		_encoderClass	= [LibsndfileEncoder class];
		return self;
	}
	return nil;
}

- (void)			writeTags						{}
- (int)				format							{ return [[[self encoderSettings] valueForKey:@"majorFormat"] intValue] | [[[self encoderSettings] valueForKey:@"subtypeFormat"] intValue]; }
- (NSString *)		fileExtension					{ return [[self encoderSettings] valueForKey:@"extension"]; }

- (NSString *)		outputFormatName
{
	SF_FORMAT_INFO			formatInfo;

	memset(&formatInfo, 0, sizeof(formatInfo));
	
	formatInfo.format		= [self format];
		   
	sf_command(NULL, SFC_GET_FORMAT_INFO, &formatInfo, sizeof(formatInfo));
	
	return [NSString stringWithCString:formatInfo.name encoding:NSASCIIStringEncoding];
}

@end

@implementation LibsndfileEncoderTask (CueSheetAdditions)

- (BOOL) formatIsValidForCueSheet
{ 
	switch([self format] & SF_FORMAT_TYPEMASK) {
		case SF_FORMAT_WAV:			return YES;					break;
		case SF_FORMAT_AIFF:		return YES;					break;
		default:					return NO;					break;
	}
}

- (NSString *) cueSheetFormatName
{
	switch([self format] & SF_FORMAT_TYPEMASK) {
		case SF_FORMAT_WAV:			return @"WAVE";				break;
		case SF_FORMAT_AIFF:		return @"AIFF";				break;
		default:					return nil;					break;
	}
}

@end

@implementation LibsndfileEncoderTask (iTunesAdditions)

- (BOOL)			formatIsValidForiTunes
{
	switch([self format] & SF_FORMAT_TYPEMASK) {
		case SF_FORMAT_WAV:			return YES;					break;
		case SF_FORMAT_AIFF:		return YES;					break;
		default:					return NO;					break;
	}
}

@end
