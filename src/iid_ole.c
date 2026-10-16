// this file contains the actual definitions of
// the IIDs and CLSIDs

// link this file in with the server and any clients


// File created by MIDL compiler version 3.00.44
// at Sat Jan 03 16:34:55 1998
// Compiler settings for if_ole.idl:
// Os (OptLev=s), W1, Zp8, env=Win32, ms_ext, c_ext
// error checks: none
//@@MIDL_FILE_HEADING(  )
#ifdef __cplusplus
extern "C"{
#endif

#ifdef __MINGW32__
# include <w32api.h>

# if __W32API_MAJOR_VERSION == 3 && __W32API_MINOR_VERSION < 10
   // This define is missing from older MingW versions of w32api, even though
   // IID is defined.
#  define __IID_DEFINED__
# endif
#endif

#ifndef __IID_DEFINED__
# define __IID_DEFINED__

typedef struct _IID
{
    unsigned long x;
    unsigned short s1;
    unsigned short s2;
    unsigned char  c[8];
} IID;

#endif

#ifndef CLSID_DEFINED
# define CLSID_DEFINED
typedef IID CLSID;
#endif

const IID IID_IViAI = {0xBE8F954A,0xD4A0,0x4B15,{0x83,0x2E,0x0E,0xDF,0xD5,0x1E,0x73,0xBB}};


const IID LIBID_ViAI = {0x78496282,0xB4E6,0x4DC3,{0x9E,0x18,0x0A,0x3A,0x19,0x84,0x30,0xF5}};


const CLSID CLSID_ViAI = {0x0FC5FC34,0x0F74,0x4E54,{0x9D,0x57,0xE4,0xE8,0x62,0x18,0x39,0xB8}};


#ifdef __cplusplus
}
#endif

