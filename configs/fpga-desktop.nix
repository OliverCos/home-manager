{ ... }:

# GNOME app-grid (desktop) entries for the FPGA toolchains installed under /opt.
# Managed declaratively so they are reproducible via home-manager.
{
  xdg.desktopEntries = {
    quartus-lite = {
      name = "Quartus Prime (23.1Lite)";
      genericName = "FPGA Design Suite";
      comment = "Intel Quartus Prime Lite Edition 23.1";
      exec = "/opt/intelFPGA/23.1Lite/quartus/bin/quartus";
      icon = "/opt/intelFPGA/23.1Lite/quartus/adm/quartusii.png";
      terminal = false;
      categories = [ "Development" "Engineering" ];
      startupNotify = false;
    };

    vivado = {
      name = "Vivado 2025.1";
      genericName = "FPGA Design Suite";
      comment = "AMD/Xilinx Vivado Design Suite 2025.1";
      exec = "/opt/2025.1/Vivado/bin/vivado";
      icon = "/opt/2025.1/Vivado/doc/images/vivado_logo.png";
      terminal = false;
      categories = [ "Development" "Engineering" ];
      startupNotify = false;
    };

    vitis = {
      name = "Vitis 2025.1";
      genericName = "Unified Software Platform";
      comment = "AMD/Xilinx Vitis 2025.1";
      exec = "/opt/2025.1/Vitis/bin/vitis";
      icon = "/opt/2025.1/Vitis/ide/browser-app/lnx64/node_modules/@rigel/explorer/src/browser/style/vitis-512x512.png";
      terminal = false;
      categories = [ "Development" "Engineering" ];
      startupNotify = false;
    };

    questa = {
      name = "Questa Sim";
      genericName = "HDL Simulator";
      comment = "Siemens Questa Sim (64-bit)";
      # 32-bit binaries are not installed; force 64-bit platform selection.
      exec = "env MTI_VCO_MODE=64 /opt/questasim/bin/vsim -gui";
      icon = "/opt/questasim/docs/htmldocs/MGC/images/disw/sie-logo-petrol-rgb.png";
      terminal = false;
      categories = [ "Development" "Engineering" ];
      startupNotify = false;
    };
  };
}
