{ ... }:

{
  # Display profile management. Profiles are hardware-specific (matched on EDID),
  # so create them on the machine once monitors are connected:
  #
  #   autorandr --save docked     # save current layout as "docked"
  #   autorandr --save mobile
  #
  # i3 calls `autorandr --change` on startup (see i3.nix) to apply the matching
  # profile automatically. Over RDP/xrdp the virtual output simply has no saved
  # profile and is left at the session-negotiated resolution.
  programs.autorandr = {
    enable = true;
  };
}
