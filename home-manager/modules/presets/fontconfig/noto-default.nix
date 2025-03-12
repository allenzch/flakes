{ pkgs, ... }: {
  custom.misc.fontconfig = {
    enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      roboto-mono
      nerd-fonts.roboto-mono
    ];
    defaultFonts = {
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK SC"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK SC"
      ];
      monospace = [
        "RobotoMono Nerd Font Mono"
      ];
      emoji = [
        "Noto Color Emoji"
      ];
    };
    localeSpecificOverrides = {
      "zh-CN" = [
        { sourceFont = "Noto Sans"; targetFont = "Noto Sans CJK SC"; }
        { sourceFont = "Noto Serif"; targetFont = "Noto Serif CJK SC"; }
      ];
      "zh-HK" = [
        { sourceFont = "Noto Sans CJK SC"; targetFont = "Noto Sans CJK HK"; }
        { sourceFont = "Noto Serif CJK SC"; targetFont = "Noto Serif CJK HK"; }
      ];
      "zh-TW" = [
        { sourceFont = "Noto Sans CJK SC"; targetFont = "Noto Sans CJK TC"; }
        { sourceFont = "Noto Serif CJK SC"; targetFont = "Noto Serif CJK TC"; }
      ];
      "ja" = [
        { sourceFont = "Noto Sans CJK SC"; targetFont = "Noto Sans CJK JP"; }
        { sourceFont = "Noto Serif CJK SC"; targetFont = "Noto Serif CJK JP"; }
      ];
      "ko" = [
        { sourceFont = "Noto Sans CJK SC"; targetFont = "Noto Sans CJK KR"; }
        { sourceFont = "Noto Serif CJK SC"; targetFont = "Noto Serif CJK KR"; }
      ];
    };
  };
}
