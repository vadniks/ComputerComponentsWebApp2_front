
import 'dart:ui';

const darkSecondaryColor = Color(0xFF0F0F0F);

const appName = 'PC Components Shop',
  appSince = 'Since 2022',
  appSlogan = 'Build your own PC with PC Configurator online and free! Choose any components you like and buy them!',
  home = 'Home',
  about = 'About',
  componentsList = 'PC Components List',
  totalCost = 'Total cost: ',
  clearSelection = 'Clear selection',
  submitOrder = 'Submit order',
  copyright = 'Copyright (C) 2022 | All Rights Reserved',
  aboutApp = 'About PC Components Shop',
  aboutText = '''We are Leading Company
Provide our customers with superior products and services at the most reasonable rates available. At the time of company formation in 2022, our core business was as a computer parts reseller. We initiated our company with the philosophy that “We refuse to compromise quality for profit” and have not since changed that guiding principle.

The quality of our custom built computers speak for themselves. They are reliable because we use brand name components which equals no headaches. PC Configurator sales and services focus on selling the best possible product at the best possible price. On a local level, PC Configurator’s exists to provide computer hardware and services. PC Configurator’s is very competitive on a national level in terms of price, quality and services. PC Configurator’s major market extends to all those with access to the internet and a web browser.''';

const components = {
  'Processor': 'pc_cpu',
  'Motherboard' : 'pc_mb',
  'Graphics adapter' : 'pc_gpu',
  'Operating memory' : 'pc_ram',
  'Hard drive' : 'pc_hdd',
  'Solid state drive' : 'pc_ssd',
  'Power supply unit' : 'pc_psu',
  'Cooler' : 'pc_fan',
  'Case' : 'pc_case'
};

const appIcon = 'pc_icon.svg',
  svgExtension = '.svg',
  hardwareIcon = 'hwr_ico.svg',
  qualityIcon = 'qlt_ico.svg';

const routeHome = '/',
  routeAbout = '/about';