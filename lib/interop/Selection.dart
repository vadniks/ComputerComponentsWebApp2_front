
class Selection {
  int? cpu, mb, gpu, ram, hdd, ssd, psu, fan, ca$e;

  static const cpuC = 'cpu', mbC = 'mb', gpuC = 'gpu', ramC = 'ram',
      hddC = 'hdd', ssdC = 'ssd', psuC = 'psu', fanC = 'fan', caseC = 'case';

  Selection({
    this.cpu, this.mb, this.gpu,
    this.ram, this.hdd, this.ssd,
    this.psu, this.fan, this.ca$e
  });

  factory Selection.fromString(String fetched) {
    final values = fetched.split(',');
    return Selection(
        cpu: int.tryParse(values[0]),
        mb: int.tryParse(values[1]),
        gpu: int.tryParse(values[2]),
        ram: int.tryParse(values[3]),
        hdd: int.tryParse(values[4]),
        ssd: int.tryParse(values[5]),
        psu: int.tryParse(values[6]),
        fan: int.tryParse(values[7]),
        ca$e: int.tryParse(values[8])
    );
  }

  @override
  String toString() => '$cpu,$mb,$gpu,$ram,$hdd,$ssd,$psu,$fan,${ca$e}';
}
