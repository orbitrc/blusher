//  blusher/Application.h
//
//  Author:     Gene Ryu
//  Created:    2018. 10. 09. 10:48
//  Copyright (c) 2018 Gene Ryu. All rights reserved.
//
//

//==========
// Cobalt
//==========
#ifdef Cobalt

namespace bl {

class Application {
    constructor(list<string> argv);
    int exec();
};

} // namespace bl

#endif // Cobalt

//========
// C
//========
#ifdef __cplusplus
extern "C" {
#endif
#ifndef Cobalt

#include <cobalt.h>

typedef struct object bl_Application;

extern const type __type__bl_Application;

bl_Application bl_Application_constructor(const list_string* argv);

integer bl_Application_exec(const bl_Application *self);

#endif /* Cobalt */
#ifdef __cplusplus
} /* extern "C" */
#endif

//============
// C++
//============
#ifdef __cplusplus
#ifndef Cobalt

#include <string>

namespace bl {

class Application {
private:
public:
    Application();
    ~Application();
    void title(const std::string& name) const;
};

} // namespace bl

#endif // COBALT
#endif // __cplusplus
