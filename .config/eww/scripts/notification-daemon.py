import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib
import threading
import time
from dataclasses import dataclass, asdict


@dataclass
class Notification:
    summary: str
    body: str
    icon: str


notifications = []


def remove_object(notif: Notification) -> None:
    time.sleep(10)
    notifications.remove(asdict(notif))
    print_state()


def add_object(notif: Notification) -> None:
    notifications.insert(0, asdict(notif))
    print_state()
    timer_thread = threading.Thread(target=remove_object, args=(notif,))
    timer_thread.start()


def print_state() -> None:
    print(notifications)


class NotificationServer(dbus.service.Object):
    def __init__(self):
        bus_name = dbus.service.BusName(
            'org.freedesktop.Notifications', bus=dbus.SessionBus())
        dbus.service.Object.__init__(
            self, bus_name, '/org/freedesktop/Notifications')

    @dbus.service.method(
        'org.freedesktop.Notifications',
        in_signature='susssasa{ss}i',
        out_signature='u'
    )
    def Notify(self, app_name, replaces_id, app_icon, summary,
               body, actions, hints, timeout):
        # print("Received Notification:")
        # print("  App Name:", app_name)
        # print("  Replaces ID:", replaces_id)
        # print("  App Icon:", app_icon)
        # print("  Summary:", summary)
        # print("  Body:", body)
        # print("  Actions:", actions)
        # print("  Hints:", hints)
        # print("  Timeout:", timeout)
        add_object(Notification(str(summary), str(body), str(app_icon)))
        return 0

    @dbus.service.method('org.freedesktop.Notifications', out_signature='ssss')
    def GetServerInformation(self):
        return ("Custom Notification Server", "ExampleNS", "1.0", "1.2")


DBusGMainLoop(set_as_default=True)

if __name__ == '__main__':
    server = NotificationServer()
    mainloop = GLib.MainLoop()
    mainloop.run()
