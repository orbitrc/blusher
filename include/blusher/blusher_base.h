#ifndef _BL_BLUSHER_BASE_H
#define _BL_BLUSHER_BASE_H

#include <QtCore/QtGlobal>

#ifdef BL_BUILDING
    #define BL_EXPORT Q_DECL_EXPORT
#else
    #define BL_EXPORT Q_DECL_IMPORT
#endif

#endif // _BL_BLUSHER_BASE_H
