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

    '';
  };
}
