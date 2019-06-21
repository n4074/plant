(import ./.).shellFor {
  packages = p: [p.plant-core p.plant-module ];
  withHoogle = true;
}
