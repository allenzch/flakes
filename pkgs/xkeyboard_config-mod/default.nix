{
  xkeyboard_config,
}:

xkeyboard_config.overrideAttrs {
  patches = [ ./ru-layout-custom.patch ];
}
