function bus2csv(mpc, file, delim)

LAM_P = 14;

if ~isfield(mpc, 'bus') || isempty(mpc.bus)
  disp('bus2csv: no bus data');
  return;
endif

if nargin < 2
  file = "bus.m";
endif
if nargin < 3
  delim = ',';
endif

if (ischar (file))
  [fid, msg] = fopen (file, "wt");
elseif (is_valid_file_id (file))
  [fid, msg] = deal (file, "invalid file number");
else
  error("bus2csv: FILE must be a filename string or numeric FID");
endif

if (fid < 0)
  error(["bus2csv: " msg]);
endif

bus_header0 = strjoin({"BUS_I", "BUS_TYPE", "PD", "QD", "GS", "BS", "BUS_AREA", "VM", "VA", "BASE_KV", "ZONE", "VMAX", "VMIN"}, delim);
bus_header_opf = strjoin({"BUS_I", "BUS_TYPE", "PD", "QD", "GS", "BS", "BUS_AREA", "VM", "VA", "BASE_KV", "ZONE", "VMAX", "VMIN", "LAM_P", "LAM_Q", "MU_VMAX", "MU_VMIN"}, delim);

if size(mpc.bus, 2) < LAM_P
  fprintf(fid, "%s\n", bus_header0);
else
  fprintf(fid, "%s\n", bus_header_opf);
endif
dlmwrite(fid, mpc.bus, '-append', 'delimiter', delim, 'precision', '%.9g');

if (ischar (file))
  fclose (fid);
endif