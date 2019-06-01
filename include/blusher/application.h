//  application.h
//
//  Author:     Gene Ryu
//  Created:    2018. 10. 09. 10:48
//  Copyright (c) 2018 Gene Ryu. All rights reserved.
//
//
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
