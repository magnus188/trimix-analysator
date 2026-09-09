#include "services/ota_core.h"
#include <atomic>
#include <cstdio>
#include <thread>

int main() {
    unsigned failures=0;
    for(unsigned iteration=0;iteration<500;++iteration) {
        ota::BootProbation probation; probation.begin(0,true);
        std::atomic<bool> start{false};
        bool supervisor_owned=false;
        auto completed=ota::BootProbation::Completion::AlreadyExpired;
        std::thread supervisor([&] {
            while(!start.load()) std::this_thread::yield();
            supervisor_owned=probation.expire(60000);
        });
        std::thread main([&] {
            while(!start.load()) std::this_thread::yield();
            completed=probation.complete(59999);
        });
        start=true; supervisor.join(); main.join();
        const bool accepted=completed==ota::BootProbation::Completion::Timely;
        if(accepted==supervisor_owned || probation.pending() || probation.expire(60001) ||
           (supervisor_owned && probation.complete(60001)!=ota::BootProbation::Completion::AlreadyExpired)) ++failures;
    }
    for(unsigned iteration=0;iteration<500;++iteration) {
        ota::BootProbation probation; probation.begin(UINT32_MAX-100,true);
        std::atomic<bool> start{false};
        bool supervisor_owned=false;
        auto completed=ota::BootProbation::Completion::Timely;
        std::thread supervisor([&] {
            while(!start.load()) std::this_thread::yield();
            supervisor_owned=probation.expire(59899);
        });
        std::thread main([&] {
            while(!start.load()) std::this_thread::yield();
            completed=probation.complete(59899);
        });
        start=true; supervisor.join(); main.join();
        const bool main_owned=completed==ota::BootProbation::Completion::Timeout;
        if(completed==ota::BootProbation::Completion::Timely || main_owned==supervisor_owned ||
           probation.pending() || probation.expire(59900) ||
           probation.complete(59900)!=ota::BootProbation::Completion::AlreadyExpired) ++failures;
    }
    std::printf("%s 1000 production BootProbation completion/expiry race rounds, including clock wrap; %u failures\n",failures?"FAIL":"PASS",failures);
    return failures?1:0;
}
