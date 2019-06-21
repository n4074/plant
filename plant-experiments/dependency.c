#include "dependency.h"
#include <unistd.h>

void libinternalfunc(int i) {
    sleep(i);
}

void libfunc() {
    libinternalfunc(1);
}
