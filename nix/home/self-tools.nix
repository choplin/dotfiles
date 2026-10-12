{selfTools, ...}: {
  home.packages = builtins.attrValues selfTools;
}
