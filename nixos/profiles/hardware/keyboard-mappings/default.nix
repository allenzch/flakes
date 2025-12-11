{
  services = {
    udev.extraHwdb = ''
      evdev:input:b*v046Dp4089*
        KEYBOARD_KEY_70039=esc
        KEYBOARD_KEY_70029=capslock

      evdev:input:b*v1A81p2039*
        KEYBOARD_KEY_70039=esc
        KEYBOARD_KEY_70029=capslock

      evdev:input:b*v258Ap1006*
        KEYBOARD_KEY_70039=esc
        KEYBOARD_KEY_70029=capslock

      evdev:input:b*v05ACp0256*
        KEYBOARD_KEY_70039=esc
        KEYBOARD_KEY_70029=capslock
        KEYBOARD_KEY_700e3=leftctrl
        KEYBOARD_KEY_700e2=leftmeta
        KEYBOARD_KEY_700e0=leftalt

    '';
  };
}
