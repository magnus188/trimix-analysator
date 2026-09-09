#include "services/ota_core.h"
#include <fstream>
#include <iterator>
#include <iostream>
int main(int argc,char **argv) {
    if(argc!=2) return 2;
    std::ifstream input(argv[1]);
    const std::string json((std::istreambuf_iterator<char>(input)),std::istreambuf_iterator<char>());
    for(const auto family:{ota::Family::Pre3,ota::Family::V3}) {
        for(const auto installed:{"0.1.0","0.2.0","0.3.0"}) {
            ota::Release release; std::string error;
            if(!ota::parse_release(json.data(),json.size(),family,installed,
                "https://github.com/magnus188/trimix-analysator",
                family==ota::Family::Pre3?4194304:6291456,release,error)) {
                std::cerr<<error<<'\n'; return 1;
            }
            if(release.newer!=(std::string(installed)=="0.1.0")) return 1;
            std::cout<<"PASS production parser "<<(family==ota::Family::Pre3?"pre3":"v3")
                <<" installed="<<installed<<" candidate="<<release.version
                <<" newer="<<release.newer<<" size="<<release.size<<'\n';
        }
    }
}
