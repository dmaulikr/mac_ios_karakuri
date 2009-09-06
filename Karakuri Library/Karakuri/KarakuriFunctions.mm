//
//  KarakuriFunctions.mm
//  Karakuri Prototype
//
//  Created by numata on 09/07/22.
//  Copyright 2009 Satoshi Numata. All rights reserved.
//

#import "KarakuriFunctions.h"

#include <string>

#import <Foundation/Foundation.h>


void KRSleep(float interval)
{
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

float KRCurrentTime()
{
    return [NSDate timeIntervalSinceReferenceDate];
}

bool KRCheckOpenGLExtensionSupported(const std::string& extensionName)
{
    const char *extensions = (const char *)glGetString(GL_EXTENSIONS);
    return (strstr(extensions, extensionName.c_str()) != NULL);
}

std::string KRGetKarakuriVersion()
{
    return "0.7.3";
}

