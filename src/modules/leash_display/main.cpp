extern "C" __EXPORT int main(int argc, const char * const * const argv);

#include <display.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "images/images.h"
#include "status.hpp"
#include "screen.hpp"

#include <systemlib/systemlib.h>

#include <uORB/uORB.h>
#include <uORB/topics/airdog_status.h>
#include <uORB/topics/leash_display.h>

static bool main_thread_should_exit = false;
static bool thread_running = false;
static int deamon_task;


static int leash_display_thread_main(int argc, char *argv[])
{
    Status status;
    thread_running = true;
    int currentScreenId = 0;

    printf("leash_display started\n");

    up_display_mcu_setup();
    display_init();

    while (!main_thread_should_exit)
    {
        bool hasChanges = status.update();

        if (status.screenId != currentScreenId)
        {
            display_clear();

            switch (status.screenId)
            {
                case LEASHDISPLAY_NONE:
                    break;

                case LEASHDISPLAY_LOGO:
                    Screen::showLogo();
                    break;

                case LEASHDISPLAY_MAIN:
                    break;
            }

            display_redraw_all();

            currentScreenId = status.screenId;
        }

        if (hasChanges)
        {
            printf("mode %d buttons %x\n", status.mode, status.buttons);
            printf("screenId %d\n", status.screenId);
            printf("airdog_battery %d\n", status.airdog_battery);
            printf("leash_battery %.5f\n", (double)status.leash_battery);
        }
    }

    thread_running = false;

    printf("leash_display ended");

    return 0;
}


static void getOrbData(const struct orb_metadata *meta, void *data) {
    int fd = orb_subscribe(meta);
    orb_copy(meta, fd, data);
    orb_unsubscribe(fd);
}

int
main(int argc, const char * const * const argv)
{
    if (argc > 1 && strcmp("start", argv[1]) == 0)
    {
        if (!thread_running)
        {
            main_thread_should_exit = false;
            deamon_task = task_spawn_cmd("leash_display",
                                         SCHED_DEFAULT,
                                         SCHED_PRIORITY_DEFAULT - 30,
                                         3000,
                                         leash_display_thread_main,
                                         (const char **)argv);
        }
        else
        {
            printf("already running");
            /* this is not an error */
        }
    }
    else if (argc > 1 && strcmp(argv[1], "stop") == 0)
    {
        if (thread_running)
        {
            main_thread_should_exit = true;
        }
        else
        {
            printf("not started");
        }
    }
    else if (argc > 2 && strcmp(argv[1], "show") == 0)
    {
        struct leash_display_s leash_display;
        static orb_advert_t to_leash_display = 0;

        leash_display.screenId = atoi(argv[2]);
        if (to_leash_display > 0)
        {
            orb_publish(ORB_ID(leash_display), to_leash_display, &leash_display);
        }
        else
        {
            to_leash_display = orb_advertise(ORB_ID(leash_display), &leash_display);
        }
    }
    else if (argc > 3 && strcmp(argv[1], "set") == 0)
    {
        if (strcmp(argv[2], "battery") == 0) {
            struct airdog_status_s airdog_status;
            static orb_advert_t to_airdog_status = 0;

            getOrbData(ORB_ID(airdog_status), &airdog_status);

            printf("old airdog_battery %d\n", airdog_status.battery_remaining);

            airdog_status.battery_remaining = atoi(argv[3]);

            printf("set airdog_battery to %d\n", airdog_status.battery_remaining);

            if (to_airdog_status > 0)
            {
                orb_publish(ORB_ID(airdog_status), to_airdog_status, &airdog_status);
            }
            else
            {
                to_airdog_status = orb_advertise(ORB_ID(airdog_status), &airdog_status);
            }
        }
    }
    else
    {
        printf("Wrong parameters:\n"
               "parameters:"
               "\tstart\n"
               "\tstop\n"
               "\tshow screenId\n"
               );
    }

    if (0){
        printf("command show:\n");

        display_clear();

        if (strcmp("logo", argv[2]) == 0)
        {
            printf("show logo:\n");
            display_bitmap(0, 0, imageInfo[0].w, imageInfo[0].h,
                    imageData + imageInfo[0].offset);
        }

        display_redraw_all();
    }

    return 0;
}