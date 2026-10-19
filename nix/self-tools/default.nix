{inputs, system}: {
  octa = inputs.octa.packages.${system}.octa-bin;
  revia = inputs.revia.packages.${system}.revia-bin;
  yomu = inputs.yomu.packages.${system}.yomu-bin;
}
