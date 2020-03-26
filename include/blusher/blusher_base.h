#ifndef _BL_BLUSHER_BASE_H
#define _BL_BLUSHER_BASE_H

#include <QtCore/QtGlobal>

#ifdef BL_BUILDING
    #define BL_EXPORT Q_DECL_EXPORT
#else
    #define BL_EXPORT Q_DECL_IMPORT
#endif

#ifdef Q_OS_LINUX
    #define BL_PLATFORM_LINUX
#elif Q_OS_MACOS
    #DEFINE BL_PLATFORM_MACOS
#elif Q_OS_WIN
    #DEFINE BL_PLATFORM_WINDOWS
#endif

#endif // _BL_BLUSHER_BASE_H
