function branch2csv(mpc, file, delim)

ANGMIN = 12;
PF     = 14;
MU_SF  = 18;

if ~isfield(mpc, 'branch') || isempty(mpc.branch)
  disp('branch2csv: no branch data');
  return;
endif

if nargin < 2
  file = "branch.m";
endif
if nargin < 3
  delim = ',';
endif

if (ischar (file))
  [fid, msg] = fopen (file, "wt");
elseif (is_valid_file_id (file))
  [fid, msg] = deal (file, "invalid file number");
else
  error ("branch2csv: FILE must be a filename string or numeric FID");
endif

if (fid < 0)
  error (["branch2csv: " msg]);
endif

br_header0 = strjoin({"F_BUS", "T_BUS", "BR_R", "BR_X", "BR_B", "RATE_A", "RATE_B", "RATE_C", "TAP", "SHIFT", "BR_STATUS"}, delim);
br_header_ang = strjoin({"F_BUS", "T_BUS", "BR_R", "BR_X", "BR_B", "RATE_A", "RATE_B", "RATE_C", "TAP", "SHIFT", "BR_STATUS", "ANGMIN", "ANGMAX"}, delim);
br_header_pf = strjoin({"F_BUS", "T_BUS", "BR_R", "BR_X", "BR_B", "RATE_A", "RATE_B", "RATE_C", "TAP", "SHIFT", "BR_STATUS", "ANGMIN", "ANGMAX", "PF", "QF", "PT", "QT"}, delim);
br_header_opf = strjoin({"F_BUS", "T_BUS", "BR_R", "BR_X", "BR_B", "RATE_A", "RATE_B", "RATE_C", "TAP", "SHIFT", "BR_STATUS", "ANGMIN", "ANGMAX", "PF", "QF", "PT", "QT", "MU_SF", "MU_ST", "MU_ANGMIN", "MU_ANGMAX"}, delim);

if size(mpc.branch, 2) < ANGMIN
  fprintf(fid, "%s\n", br_header0);
elseif size(mpc.branch, 2) < PF
  fprintf(fid, "%s\n", br_header_ang);
elseif size(mpc.branch, 2) < MU_SF
  fprintf(fid, "%s\n", br_header_pf);
else
  fprintf(fid, "%s\n", br_header_opf);
endif
dlmwrite(fid, mpc.branch, '-append', 'delimiter', delim, 'precision', '%.9g');

if (ischar (file))
  fclose (fid);
endif