//
//  setleds.h
//  CoolerMasterNumLockToggle
//
//  Created by Jeff Peck - Home on 1/2/18.
//  Copyright © 2018 Jeff Peck. All rights reserved.
//

#ifndef setleds_h
#define setleds_h

#include <CoreFoundation/CoreFoundation.h>
#include <Carbon/Carbon.h>
#include <IOKit/hid/IOHIDLib.h>
#include <fnmatch.h>

const int maxLeds = 3;
const char* ledNames[] = { "num", "caps", "scroll" };
const char* stateSymbol[] = {"-", "+" };
typedef enum { NoChange = -1, Off, On, Toggle } LedState;

void toggle(const char * _key, const char * _nameMatch);
void parseOptions(int argc, const char * argv[]);
void explainUsage(void);
void setAllKeyboards(LedState changes[]);
CFMutableDictionaryRef getKeyboardDictionary(void);

#endif /* setleds_h */
