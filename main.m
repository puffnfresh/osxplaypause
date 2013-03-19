#import <IOKit/hidsystem/IOHIDLib.h>
#import <IOKit/hidsystem/ev_keymap.h>
#import <strings.h>

int main(int argc, char *argv[]) {
  mach_port_t connect = 0;
  mach_port_t master_port;
  mach_port_t service;
  mach_port_t iter;

  IOMasterPort(bootstrap_port, &master_port);
  IOServiceGetMatchingServices(master_port, IOServiceMatching(kIOHIDSystemClass), &iter);

  service = IOIteratorNext(iter);
  IOObjectRelease(iter);

  IOServiceOpen(service, mach_task_self(), kIOHIDParamConnectType, &connect);
  IOObjectRelease(service);

  IOGPoint location = {0, 0};
  NXEventData eventData;

  bzero(&eventData, sizeof(NXEventData));
  eventData.compound.subType = NX_SUBTYPE_AUX_CONTROL_BUTTONS;
  eventData.compound.misc.L[0] = NX_KEYTYPE_PLAY << 16 | NX_KEYDOWN << 8;
  IOHIDPostEvent(connect, NX_SYSDEFINED, location, &eventData, kNXEventDataVersion, 0, FALSE);

  bzero(&eventData, sizeof(NXEventData));
  eventData.compound.subType = NX_SUBTYPE_AUX_CONTROL_BUTTONS;
  eventData.compound.misc.L[0] = NX_KEYTYPE_PLAY << 16 | NX_KEYUP << 8;
  IOHIDPostEvent(connect, NX_SYSDEFINED, location, &eventData, kNXEventDataVersion, 0, FALSE);

  return 0;
}
