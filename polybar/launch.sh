#!/bin/bash

# Остановить все запущенные экземпляры Polybar
pkill polybar

# Дождаться завершения процессов
while pgrep -x polybar >/dev/null; do sleep 1; done

# Запустить Polybar на всех мониторах
if type "xrandr" > /dev/null; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar main -r &
  done
else
  polybar main -r &
fi

echo "Polybar запущен..."

