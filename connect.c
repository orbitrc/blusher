#include <stdio.h>
#include <stdlib.h>
#include <wayland-client.h>

struct wl_display *display = NULL;

int main(int argc, char *argv[])
{
    display = wl_display_connect(NULL);
    if (display == NULL) {
        printf("Can't connect to display\n");
        exit(1);
    }
    printf("connected\n");

    wl_display_disconnect(display);
    printf("disconnected\n");

    return 0;
}
