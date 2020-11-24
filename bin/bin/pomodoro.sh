#!/bin/bash
#
# Minimalistic Pomodoro Timer
#
# Based on the SU answer found here:
# https://superuser.com/questions/224265/pomodoro-timer-for-linux/669811#669811
#
# Tested in Ubuntu 18.04
#
# From: https://gist.github.com/jameswpm/2833c89b18fc3f571985779cbee0a2b8

notify_work_time () {
  notify-send "Time to Work" "Focus" -u critical -a 'Pomodoro'
  paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
}

notify_short_break_time () {
  notify-send "Short Break Time" -u critical -a 'Pomodoro'
  paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
}

notify_long_break_time () {
  notify-send "Long Break Time" "Take a Rest" -u critical -a 'Pomodoro'
  paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
}

work_time=1500 # 25 min
short_break_time=300 # 5 min
long_break_time=900 # 15 min

case "$1" in
    'start')
            echo "Starting Pomodoro"
            # we want to show counter from 1
            counter=1
            # 2 big rounds
            for i in {0..1}; do
                # 4 pomodoros per round
                for i in {0..3}; do
                    # work
                    notify_work_time
                    echo "Pomodoro ${counter} started at $(date +"%H:%M")"

                    sleep "${work_time}"

                    # don't launch short break after last round as long break is
                    # in effect after this loop
                    if [ "${i}" != 3 ]; then
                        notify_short_break_time
                        sleep "${short_break_time}"
                    fi

                    echo "Pomodoro ${counter} done!"

                    counter=$((counter+1))
                done
                echo "Round done!"
                notify_long_break_time
                sleep "${long_break_time}"
            done
            echo "Done!"
            ;;
    'w')
            secs=${2:-"${work_time}"}
            notify_work_time
            sleep "${secs}" && notify_short_break_time
            ;;
    'sb')
            secs=${2:-"${short_break_time}"}
            sleep "${secs}" && notify_work_time
            ;;
    'lb')
            secs=${2:-"${long_break_time}"}
            sleep "${secs}" && notify_work_time
            ;;
    *)
            echo
            echo "Usage: $0 { start | pomo | sb | lb }"
            echo
            exit 1
            ;;
esac
