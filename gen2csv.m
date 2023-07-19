function gen2csv(mpc, file, delim)

PC1     = 11;
MU_PMAX = 22;

if ~isfield(mpc, 'gen') || isempty(mpc.gen)
  disp('gen2csv: no gen data');
  return;
endif

if nargin < 2
  file = "gen.m";
endif
if nargin < 3
  delim = ',';
endif

if (ischar (file))
  [fid, msg] = fopen (file, "wt");
elseif (is_valid_file_id (file))
  [fid, msg] = deal (file, "invalid file number");
else
  error ("gen2csv: FILE must be a filename string or numeric FID");
endif

if (fid < 0)
  error (["gen2csv: " msg]);
endif

gen_header0 = strjoin({"GEN_BUS", "PG", "QG", "QMAX", "QMIN", "VG", "MBASE", "GEN_STATUS", "PMAX", "PMIN"}, delim);
gen_header_pq = strjoin({"GEN_BUS", "PG", "QG", "QMAX", "QMIN", "VG", "MBASE", "GEN_STATUS", "PMAX", "PMIN", "PC1", "PC2", "QC1MIN", "QC1MAX", "QC2MIN", "QC2MAX", "RAMP_AGC", "RAMP_10", "RAMP_30", "RAMP_Q", "APF"}, delim);
gen_header_opf = strjoin({"GEN_BUS", "PG", "QG", "QMAX", "QMIN", "VG", "MBASE", "GEN_STATUS", "PMAX", "PMIN", "PC1", "PC2", "QC1MIN", "QC1MAX", "QC2MIN", "QC2MAX", "RAMP_AGC", "RAMP_10", "RAMP_30", "RAMP_Q", "APF", "MU_PMAX", "MU_PMIN", "MU_QMAX", "MU_QMIN"}, delim);

if size(mpc.gen, 2) < PC1
  fprintf(fid, "%s\n", gen_header0);
elseif size(mpc.gen, 2) < MU_PMAX
  fprintf(fid, "%s\n", gen_header_pq);
else
  fprintf(fid, "%s\n", gen_header_opf);
endif
dlmwrite(fid, mpc.gen, '-append', 'delimiter', delim, 'precision', '%.9g');

if (ischar (file))
  fclose (fid);
endif